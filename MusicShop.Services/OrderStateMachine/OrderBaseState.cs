using System.Threading.Tasks;
using MusicShop.Services.Database;
using MusicShop.Services.Implementations;

namespace MusicShop.Services.StateMachine
{
    public class OrderBaseState
    {
        protected readonly OrderDetailsService _service;

        public OrderBaseState(OrderDetailsService service)
        {
            _service = service;
        }

        public virtual Task<OrderDetail> Process(OrderDetail order) => Task.FromResult(order);
        public virtual Task<OrderDetail> Pack(OrderDetail order) => Task.FromResult(order);
        public virtual Task<OrderDetail> Ship(OrderDetail order) => Task.FromResult(order);
    }
}
