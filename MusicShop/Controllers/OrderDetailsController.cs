using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MusicShop.Model;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Interfaces;

namespace MusicShop.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OrderDetailsController : BaseCRUDController<Model.OrderDetail, OrderSearchObject, OrderInsertRequest, OrderUpdateRequest>
    {
        public OrderDetailsController(IOrderDetailService service) : base(service)
        {
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<OrderDetail> Update(int id, [FromBody] OrderUpdateRequest update)
        {
            return base.Update(id, update);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<OrderDetail> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
