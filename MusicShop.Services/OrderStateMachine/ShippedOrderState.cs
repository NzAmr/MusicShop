using MusicShop.Model;
using MusicShop.Services.Implementations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.OrderStateMachine
{
    public class ShippedOrderState : OrderBaseState
    {
        public ShippedOrderState(OrderDetailsService service) : base(service) { }

        public override async Task<OrderDetail> Deliver(OrderDetail order)
        {
            order.ShippingStatus = "Delivered";
            await _service.UpdateOrder(order);
            return order;
        }

        public override async Task<OrderDetail> Cancel(OrderDetail order)
        {
            order.ShippingStatus = "Cancelled";
            await _service.UpdateOrder(order);
            return order;
        }
    }

}
