using AutoMapper;
using MusicShop.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.StudioStateMachine
{
    public class ConfirmedState : BaseState
    {
        public ConfirmedState(IServiceProvider serviceProvider,  MusicShopDBContext context, IMapper mapper)
           : base(serviceProvider, context, mapper) { }

        public override List<string> AllowedActions()
        {
            var list = base.AllowedActions();

            list.Add("Mark as cancelled");

            return list;
        }
    }
}
