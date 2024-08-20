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
    public class GearService : BaseCRUDService<Model.Gear, Database.Gear, GearSearchObject, GearUpsertRequest, GearUpsertRequest>, IGearService
    {
        public GearService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override void BeforeInsert(GearUpsertRequest insert, Gear entity)
        {
            entity.CreatedAt = DateTime.Now;
            entity.UpdatedAt = DateTime.Now;
        }
        public override IQueryable<Gear> AddInclude(IQueryable<Gear> query, GearSearchObject? search = null)
        {
            query = query.Include(x => x.Brand);
            return query;
        }
    }
}
