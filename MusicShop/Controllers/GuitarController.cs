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

    public class GuitarController : BaseCRUDController<Model.Guitar, GuitarSearchObject, GuitarInsertRequest, GuitarUpdateRequest>
    {
        public GuitarController(IGuitarService service) : base(service){ }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Guitar> Insert([FromBody] GuitarInsertRequest insert)
        {
            return base.Insert(insert);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Guitar> Update(int id, [FromBody] GuitarUpdateRequest update)
        {
            return base.Update(id, update);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Guitar> Delete(int id)
        {
            return base.Delete(id);
        }


    }
}
