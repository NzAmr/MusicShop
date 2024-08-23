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
    public class BassController : BaseCRUDController<Model.Bass, BassSearchObject, BassUpsertRequest, BassUpsertRequest>
    {
        public BassController(IBassService service) : base(service) {}
        [Authorize(Roles = "Employee")]
        public override ActionResult<Bass> Insert([FromBody] BassUpsertRequest insert)
        {
            return base.Insert(insert);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Bass> Update(int id, [FromBody] BassUpsertRequest update)
        {
            return base.Update(id, update);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Bass> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
