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
    public class BrandService : BaseCRUDService<Model.Brand, Database.Brand, GenericNameSearchObject, BrandUpsertRequest, BrandUpsertRequest>, IBrandService
    {
        public BrandService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Brand> AddFilter(IQueryable<Database.Brand> query, GenericNameSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!String.IsNullOrEmpty(search.Name))
            {
                filteredQuery = filteredQuery.Where(x => x.Name.ToLower().Contains(search.Name.ToLower()));
            }

            return filteredQuery;
        }
    }
}
