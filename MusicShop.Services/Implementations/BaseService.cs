using AutoMapper;
using Microsoft.EntityFrameworkCore;
using MusicShop.Model.BaseModel;
using MusicShop.Services.Database;
using MusicShop.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Implementations
{
    public class BaseService<T, TDb, TSearch> : IService<T, TSearch> where T : class where TDb : BaseEntity where TSearch : BaseSearchObject
    {
        public IMapper Mapper;
        public MusicShopDBContext Context;

        public BaseService(MusicShopDBContext context, IMapper mapper) 
        {
            Context = context;
            Mapper = mapper;
        }

        public virtual IEnumerable<T> Get(TSearch? search = null)
        {
            var set = Context.Set<TDb>().AsQueryable();

            set = AddFilter(set, search);

            set = AddInclude(set, search);

            var entity = set.AsQueryable();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                entity = entity.Skip(search.Page.Value * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = entity.ToList();
            return Mapper.Map<IList<T>>(list);
        }

        public T GetById(int id, TSearch? search = null)
        {
            var set = Context.Set<TDb>().AsQueryable();

            set = AddInclude(set, search);

            var entity = set.OfType<BaseEntity>().FirstOrDefault(element => element.Id == id);

            if (entity == null)
            {
                throw new Exception("Not Found");
            }

            return Mapper.Map<T>(entity);
        }

        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }
    }
}

