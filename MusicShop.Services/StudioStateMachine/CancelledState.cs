using AutoMapper;
using MusicShop.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.StudioStateMachine
{
    public class CancelledState : BaseState
    {
        public CancelledState(IServiceProvider serviceProvider,  MusicShopDBContext context, IMapper mapper)
           : base(serviceProvider, context, mapper) { }

        
    }
}
