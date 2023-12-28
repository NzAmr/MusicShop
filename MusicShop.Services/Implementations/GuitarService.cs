using AutoMapper;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Database;
using MusicShop.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Implementations
{
    public class GuitarService : BaseCRUDService<Model.Guitar, Database.Guitar, GuitarSearchObject, GuitarInsertRequest, GuitarUpdateRequest>, IGuitarService
    {
        public GuitarService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
