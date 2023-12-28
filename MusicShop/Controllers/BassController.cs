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

       
    }
}
