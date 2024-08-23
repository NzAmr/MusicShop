using MusicShop.Model;
using MusicShop.Services.Implementations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.OrderStateMachine
{
    public class PendingOrderState : OrderBaseState
    {
        public PendingOrderState(OrderDetailsService service) : base(service) { }

        public override async Task<OrderDetail> Process(OrderDetail order)
        {
            order.ShippingStatus = "Processed";
            await _service.UpdateOrder(order);
            return order;
        }
    }

}
