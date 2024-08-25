using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MusicShop.Model;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Interfaces;
using System.Security.Claims;

namespace MusicShop.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ShippingInfoController : BaseCRUDController<Model.ShippingInfo, NameSearchObject, ShippingInfoInsertRequest, ShippingInfoUpdateRequest>
    {
        public ShippingInfoController(IShippingInfoService service) : base(service) {}
        [HttpGet("get-by-customer-id")]
        public ShippingInfo GetByCustomerId([FromQuery] int id )
        {
            var _service = (IShippingInfoService)Service;
            return (_service as IShippingInfoService).GetByCustomerId(id);
        }
        [HttpGet("get-by-customer-id-from-request")]
        public ActionResult<ShippingInfo> GetByCustomerIdFromRequest()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);

            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int customerId))
            {
                return Unauthorized("User is not authenticated or customer ID is missing.");
            }
            var _service = (IShippingInfoService)Service;
            return (_service as IShippingInfoService).GetByCustomerId(customerId);
        }
    }
}
