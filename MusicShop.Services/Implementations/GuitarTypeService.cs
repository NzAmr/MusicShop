using AutoMapper;
using MusicShop.Model;
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
    public class GuitarTypeService : BaseCRUDService<Model.GuitarType, Database.GuitarType, NameSearchObject, NameUpsertRequest, NameUpsertRequest> , IGuitarTypeService
    {
        public GuitarTypeService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
