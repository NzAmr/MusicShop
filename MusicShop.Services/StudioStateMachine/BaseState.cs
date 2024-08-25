using AutoMapper;
using Microsoft.Extensions.DependencyInjection;
using MusicShop.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.StudioStateMachine
{
    public class BaseState
    {
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }
        public BaseState(IServiceProvider serviceProvider, MusicShopDBContext context, IMapper mapper)
        {
            Context = context;
            ServiceProvider = serviceProvider;
            Mapper = mapper;
        }

        public Database.StudioReservation CurrentEntity { get; set; }
        public string CurrentState { get; set; }

        public MusicShopDBContext Context { get; set; } = null;

        public virtual Model.StudioReservation MarkAsConfirmed()
        {
            throw new InvalidOperationException("The current state is unable to perform the requested action");
        }

        public virtual Model.StudioReservation MarkAsCancelled( )
        {
            throw new InvalidOperationException("The current state is unable to perform the requested action");
        }


        public BaseState CreateState(string state)
        {
            switch (state)
            {
                case "draft":
                    return ServiceProvider.GetService<DraftState>();
                case "confirmed":
                    return ServiceProvider.GetService<ConfirmedState>();
                case "cancelled":
                    return ServiceProvider.GetService<CancelledState>();
               
                default:
                    throw new InvalidOperationException("Studio reservation State Not supported");
            }
        }

        public virtual List<string> AllowedActions()
        {
            return new List<string>();
        }

    }
}
