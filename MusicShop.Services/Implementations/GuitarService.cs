using AutoMapper;
using Microsoft.EntityFrameworkCore;
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
        public override IQueryable<Guitar> AddInclude(IQueryable<Guitar> query, GuitarSearchObject? search = null)
        {
            query = query.Include(x => x.Brand);
            query = query.Include(x => x.GuitarType);

            return query;
        }

        public override IQueryable<Guitar> AddFilter(IQueryable<Guitar> query, GuitarSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if(search.BrandId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.BrandId == search.BrandId);
            }
            if(search.GuitarTypeId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.GuitarTypeId == search.GuitarTypeId);
            }
            if(search.Model != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Model.ToLower().Contains(search.Model.ToLower()));
            }

            return filteredQuery;
        }
        public override void BeforeInsert(GuitarInsertRequest insert, Guitar entity)
        {
            entity.ProductImage = Convert.FromBase64String(insert.Image);
            entity.CreatedAt = DateTime.Now;
            entity.UpdatedAt = DateTime.Now;
        }
    }
}
