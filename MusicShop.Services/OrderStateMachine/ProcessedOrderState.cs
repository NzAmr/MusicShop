using MusicShop.Model;
using MusicShop.Services.Implementations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.OrderStateMachine
{
    public class ProcessedOrderState : OrderBaseState
    {
        public ProcessedOrderState(OrderDetailsService service) : base(service) { }

        public override async Task<OrderDetail> Ship(OrderDetail order)
        {
            order.ShippingStatus = "Shipped";
            await _service.UpdateOrder(order);
            return order;
        }
    }

}
