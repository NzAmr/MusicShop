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
    public class ShippingInfoController : BaseCRUDController<Model.ShippingInfo, NameSearchObject, ShippingInfoUpsertRequest, ShippingInfoUpsertRequest>
    {
        public ShippingInfoController(IShippingInfoService service) : base(service) {}
        [HttpGet("get-by-customer-id")]
        public ShippingInfo GetByCustomerId([FromQuery] int id )
        {
            var _service = (IShippingInfoService)Service;
            return (_service as IShippingInfoService).GetByCustomerId(id);
        }

    }
}
