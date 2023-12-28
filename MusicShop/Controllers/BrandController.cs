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
    public class BrandController : BaseCRUDController<Brand, GenericNameSearchObject, BrandUpsertRequest, BrandUpsertRequest>
    {
        public BrandController(IBrandService service) : base(service) {}

        public override ActionResult<Brand> Insert([FromBody] BrandUpsertRequest insert)
        {
            return base.Insert(insert);
        }

        public override ActionResult<Brand> Update(int id, [FromBody] BrandUpsertRequest update)
        {
            return base.Update(id, update);
        }
    }
}
