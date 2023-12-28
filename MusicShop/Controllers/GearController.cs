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
    public class GearController : BaseCRUDController<Model.Gear, GearSearchObject, GearUpsertRequest, GearUpsertRequest>
    {
        public GearController(IGearService service) : base(service) {}

        
    }
}
