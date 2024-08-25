using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MusicShop.Model;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Implementations;
using MusicShop.Services.Interfaces;
using System.Security.Claims;

namespace MusicShop.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class OrderController : BaseCRUDController<Model.Order, OrderSearchObject, OrderInsertRequest, OrderUpdateRequest>
    {
        private readonly IOrderDetailService _orderDetailsService;
        public OrderController(IOrderDetailService service) : base(service)
        {
            _orderDetailsService = service;
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Order> Update(int id, [FromBody] OrderUpdateRequest update)
        {
            return base.Update(id, update);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Order> Delete(int id)
        {
            return base.Delete(id);
        }
        [HttpGet("get-by-customer")]
        public ActionResult<List<Order>> GetByCustomer()
        {

            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);

            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int customerId))
            {
                return Unauthorized("User is not authenticated or customer ID is missing.");
            }

          

            try
            {
                var res = _orderDetailsService.GetByCustomerId(customerId);

                return Ok(res);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }
       
    }
}
