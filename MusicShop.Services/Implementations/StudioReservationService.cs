using System;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using MusicShop.Model;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Database;
using MusicShop.Services.Interfaces;
using MusicShop.Services.StudioStateMachine;
using System.Net;

namespace MusicShop.Services.Implementations
{
    public class StudioReservationService : BaseCRUDService<Model.StudioReservation, Database.StudioReservation, StudioReservationSearchObject, StudioReservationUpsertRequest, StudioReservationUpsertRequest>, IStudioReservationService
    {
        private IMQRabbitService _rabbitService;
        private BaseState BaseState { get; }
        public StudioReservationService(MusicShopDBContext context, IMapper mapper, BaseState baseState ,IMQRabbitService mQRabbitService) : base(context, mapper)
        {
            BaseState = baseState;
            _rabbitService = mQRabbitService;
        }
        
        public override IQueryable<Database.StudioReservation> AddInclude(IQueryable<Database.StudioReservation> query, StudioReservationSearchObject? search = null)
        {
            query = query.Include(x => x.Customer);
            return query;
        }

        public override void BeforeInsert(StudioReservationUpsertRequest insert, Database.StudioReservation entity)
        {
     
            ValidateReservationDate(entity);

            
            var existingReservations = Context.StudioReservations
                .Where(r => r.Status == "confirmed" && r.TimeFrom.HasValue && r.TimeTo.HasValue
                            && ((entity.TimeFrom >= r.TimeFrom && entity.TimeFrom < r.TimeTo)
                                || (entity.TimeTo > r.TimeFrom && entity.TimeTo <= r.TimeTo)
                                || (entity.TimeFrom <= r.TimeFrom && entity.TimeTo >= r.TimeTo)))
                .ToList();

            if (existingReservations.Any())
            {
                throw new InvalidOperationException("Studio is already in use during this time.");
            }
            entity.Status = "draft";

            base.BeforeInsert(insert, entity);
        }

        private void ValidateReservationDate(Database.StudioReservation entity)
        {
            var now = DateTime.Now;
            var minimumAdvanceTime = now.AddHours(2);

            if (entity.TimeFrom == null || entity.TimeTo == null)
            {
                throw new ArgumentException("Reservation times cannot be null.");
            }

            var timeFrom = entity.TimeFrom.Value;
            var timeTo = entity.TimeTo.Value;

            var allowedStartTime = new TimeSpan(8, 0, 0);
            var allowedEndTime = new TimeSpan(20, 0, 0);


            var timeFromPart = timeFrom.TimeOfDay;
            var timeToPart = timeTo.TimeOfDay;


            if (timeFromPart < allowedStartTime || timeToPart > allowedEndTime)
            {
                throw new ArgumentException($"Reservation must be between {allowedStartTime} o'clock and {allowedEndTime} o'clock.");
            }


            if (timeFrom < minimumAdvanceTime)
            {
                throw new ArgumentException("Reservation must be made at least 2 hours in advance.");
            }

            if (timeTo <= timeFrom)
            {
                throw new ArgumentException("End time must be after the start time.");
            }
        }
        public Model.StudioReservation MarkAsCancelled(int id)
        {
            var item = Context.StudioReservations.Include(x => x.Customer).FirstOrDefault(x =>x.Id ==id);

            if (item == null)
            {
                throw new Exception("Reservation Not Found");
            }

            var state = BaseState.CreateState(item.Status);
            state.CurrentEntity = item;
            var emailReciever = item.Customer.Email;
            _rabbitService.sendEmail(new Mail()
            {
                ToAddress = emailReciever,
                EmailSubject = "Reservation cancelled!",
                EmailBody = $"Your studio reservation on {item.TimeFrom} has been cancelled!"
            });
            return state.MarkAsCancelled();
        }
        public Model.StudioReservation MarkAsConfirmed(int id)
        {
            var item = Context.StudioReservations.Include(x=>x.Customer).FirstOrDefault(x => x.Id == id);

            if (item == null)
            {
                throw new Exception("Reservation Not Found");
            }

            var state = BaseState.CreateState(item.Status);
            state.CurrentEntity = item;

            var emailReciever = item.Customer.Email;
            _rabbitService.sendEmail(new Mail()
            {
                ToAddress = emailReciever,
                EmailSubject = "Reservation confirmed!",
                EmailBody = $"Your studio reservation on {item.TimeFrom} has been confirmed!"
            });
            return state.MarkAsConfirmed();
        }

        public List<Model.StudioReservation> GetByCustomerId(int id)
        {
            var res = Context.StudioReservations.Where(x=>x.CustomerId == id).ToList();


            return Mapper.Map<List<Model.StudioReservation>>(res);
        }
    }
}
