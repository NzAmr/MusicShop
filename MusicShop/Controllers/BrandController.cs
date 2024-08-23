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
    public class BrandController : BaseCRUDController<Brand, NameSearchObject, NameUpsertRequest, NameUpsertRequest>
    {
        public BrandController(IBrandService service) : base(service) {}
        [Authorize(Roles = "Employee")]
        public override ActionResult<Brand> Insert([FromBody] NameUpsertRequest insert)
        {
            return base.Insert(insert);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Brand> Update(int id, [FromBody] NameUpsertRequest update)
        {
            return base.Update(id, update);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Brand> Delete(int id)
        {
            return base.Delete(id);
        }
    }
}
