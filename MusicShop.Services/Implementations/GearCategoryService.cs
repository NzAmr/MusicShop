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
    public class GearCategoryService : BaseCRUDService<Model.GearCategory, Database.GearCategory, NameSearchObject, NameUpsertRequest, NameUpsertRequest>, IGearCategoryService
    {
        public GearCategoryService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
