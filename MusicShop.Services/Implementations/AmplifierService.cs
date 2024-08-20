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
    public class AmplifierServivce : BaseCRUDService<Model.Amplifier, Database.Amplifier, AmplifierSearchObject, AmplifierInsertRequest, AmplifierUpdateRequest>, IAmplifierService
    {
        public AmplifierServivce(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Amplifier> AddInclude(IQueryable<Amplifier> query, AmplifierSearchObject? search = null)
        {
            query = query.Include(x => x.Brand);
            return query;
        }
        public override void BeforeInsert(AmplifierInsertRequest insert, Amplifier entity)
        {
            entity.CreatedAt = DateTime.Now;
            entity.UpdatedAt = DateTime.Now;
        }
    }
}
