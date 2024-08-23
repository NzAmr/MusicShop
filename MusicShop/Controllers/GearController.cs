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
        [Authorize(Roles = "Employee")]
        public override ActionResult<Gear> Insert([FromBody] GearUpsertRequest insert)
        {
            return base.Insert(insert);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Gear> Update(int id, [FromBody] GearUpsertRequest update)
        {
            return base.Update(id, update);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Gear> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
