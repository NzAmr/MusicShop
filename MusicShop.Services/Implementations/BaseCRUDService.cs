using AutoMapper;
using Microsoft.EntityFrameworkCore;
using MusicShop.Model.BaseModel;
using MusicShop.Services.Database;
using MusicShop.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Implementations
{
    public class BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate>
        : BaseService<T, TDb, TSearch>, ICRUDService<T, TSearch, TInsert, TUpdate>
            where T : class where TDb : BaseEntity where TSearch : BaseSearchObject where TInsert : class where TUpdate : class
    {
        public BaseCRUDService(MusicShopDBContext context, IMapper mapper)
        : base(context, mapper) { }

        public virtual T Insert(TInsert insert)
        {
            var set = Context.Set<TDb>();

            TDb entity = Mapper.Map<TDb>(insert);

            set.Add(entity);

            BeforeInsert(insert, entity);

            Context.SaveChanges();

            return Mapper.Map<T>(entity);
        }

        public virtual void BeforeInsert(TInsert insert, TDb entity)
        {

        }

        public virtual T Update(int id, TUpdate update)
        {
            var set = Context.Set<TDb>();

            var entity = set.Find(id);

            if (entity != null)
            {
                Mapper.Map(update, entity);
            }
            else
            {
                return null;
            }

            Context.SaveChanges();

            return Mapper.Map<T>(entity);

        }
        public T Delete(int id)
        {
            var set = Context.Set<TDb>();

            var entity = set.Find(id);

            if (entity != null)
            {
                set.Remove(entity);
                Context.SaveChanges();
                return Mapper.Map<T>(entity);
            }
            else
            {
                return null;
            }
        }
    }
}
