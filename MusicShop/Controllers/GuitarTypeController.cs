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
    public class GuitarTypeController : BaseCRUDController<GuitarType, NameSearchObject, NameUpsertRequest, NameUpsertRequest>
    {
        public GuitarTypeController(IGuitarTypeService service) : base(service)
        {
        }

        public override ActionResult<GuitarType> Insert([FromBody] NameUpsertRequest insert)
        {
            return base.Insert(insert);
        }

        public override ActionResult<GuitarType> Update(int id, [FromBody] NameUpsertRequest update)
        {
            return base.Update(id, update);
        }
    }
}
