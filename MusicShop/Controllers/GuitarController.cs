﻿using Microsoft.AspNetCore.Mvc;
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

        public override ActionResult<Guitar> Insert([FromBody] GuitarInsertRequest insert)
        {
            return base.Insert(insert);
        }
        public override ActionResult<Guitar> Update(int id, [FromBody] GuitarUpdateRequest update)
        {
            return base.Update(id, update);
        }


    }
}
