using AutoMapper;
using MusicShop.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.StudioStateMachine
{
    public class DraftState : BaseState
    {
        public DraftState(IServiceProvider serviceProvider,  MusicShopDBContext context, IMapper mapper)
           : base(serviceProvider, context, mapper) { }

        public override List<string> AllowedActions()
        {
            var list = base.AllowedActions();

            list.Add("Mark as confirmed");
            list.Add("Mark as cancelled");

            return list;
        }

        public override Model.StudioReservation MarkAsCancelled()
        {
            if(CurrentEntity == null)
            {
                return null;
            }
            CurrentEntity.Status = "cancelled";
            Context.Update(CurrentEntity);
            Context.SaveChanges();
            return Mapper.Map<Model.StudioReservation>(CurrentEntity);  
        }
        public override Model.StudioReservation MarkAsConfirmed()
        {
            if (CurrentEntity == null)
            {
                return null;
            }

            var existingReservations = Context.StudioReservations
                .Where(r =>r.Status=="confirmed" && r.TimeFrom.HasValue && r.TimeTo.HasValue
                            && ((CurrentEntity.TimeFrom >= r.TimeFrom && CurrentEntity.TimeFrom < r.TimeTo)
                                || (CurrentEntity.TimeTo > r.TimeFrom && CurrentEntity.TimeTo <= r.TimeTo)
                                || (CurrentEntity.TimeFrom <= r.TimeFrom && CurrentEntity.TimeTo >= r.TimeTo)))
                .ToList();

            if (existingReservations.Any())
            {
                throw new InvalidOperationException("Studio is already in use during this time.");
            }

            CurrentEntity.Status = "confirmed";
            Context.Update(CurrentEntity);
            Context.SaveChanges();
            return Mapper.Map<Model.StudioReservation>(CurrentEntity);
        }
    }
}
