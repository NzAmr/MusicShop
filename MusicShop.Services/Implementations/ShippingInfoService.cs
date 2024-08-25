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
    public class ShippingInfoService : BaseCRUDService<Model.ShippingInfo, Database.ShippingInfo, NameSearchObject, ShippingInfoInsertRequest, ShippingInfoUpdateRequest>, IShippingInfoService
    {
        public ShippingInfoService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }


        public Model.ShippingInfo GetByCustomerId(int id)
        {

            var item = Context.Set<ShippingInfo>().Include(x => x.Customer)
                .FirstOrDefault(s => s.CustomerId == id);

            if (item == null)
            {
                return null; 
            }

            return Mapper.Map<Model.ShippingInfo>(item);
        }

        public override IQueryable<ShippingInfo> AddInclude(IQueryable<ShippingInfo> query, NameSearchObject? search = null)
        {
            query = query.Include(x => x.Customer);
            return query;
        }


    }
}
