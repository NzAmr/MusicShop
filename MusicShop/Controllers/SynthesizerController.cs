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
    public class SynthesizerController : BaseCRUDController<Model.Synthesizer, SynthesizerSearchObject, SynthesizerUpsertRequest, SynthesizerUpsertRequest>
    {
        public SynthesizerController(ISynthesizerService service) : base(service) {}
        [Authorize(Roles = "Employee")]
        public override ActionResult<Synthesizer> Insert([FromBody] SynthesizerUpsertRequest insert)
        {
            return base.Insert(insert);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Synthesizer> Update(int id, [FromBody] SynthesizerUpsertRequest update)
        {
            return base.Update(id, update);
        }
        [Authorize(Roles = "Employee")]
        public override ActionResult<Synthesizer> Delete(int id)
        {
            return base.Delete(id);
        }

    }
}
