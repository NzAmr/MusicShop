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
    public class AmplifierController : BaseCRUDController<Model.Amplifier, AmplifierSearchObject, AmplifierInsertRequest, AmplifierUpdateRequest>
    {
        public AmplifierController(IAmplifierService service) : base(service)
        {
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Amplifier> Insert([FromBody] AmplifierInsertRequest insert)
        {
            return base.Insert(insert);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Amplifier> Update(int id, [FromBody] AmplifierUpdateRequest update)
        {
            return base.Update(id, update);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Amplifier> Delete(int id)
        {
            return base.Delete(id);
        }

    }
}
