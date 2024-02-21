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
    public class ShippingInfoService : BaseCRUDService<Model.ShippingInfo, Database.ShippingInfo, NameSearchObject, ShippingInfoUpsertRequest, ShippingInfoUpsertRequest>, IShippingInfoService
    {
        public ShippingInfoService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public IEnumerable<Model.ShippingInfo> GetByCustomerName(NameSearchObject? search = null)
        {
            var customer = Context.Set<Customer>().FirstOrDefault(c => c.FirstName.ToLower().Contains(search.Name.ToLower()));
            var item = Context.Set<Database.ShippingInfo>().Where(x => x.Id == customer.ShippingInfoId).ToList();

            return Mapper.Map<IEnumerable<Model.ShippingInfo>>(item);
        }
        public IEnumerable<Model.ShippingInfo> GetByCustomerId(int id)
        {
            var customer = Context.Set<Customer>().FirstOrDefault(x => x.Id == id);
            var item = Context.Set<ShippingInfo>().Where(s => s.Id == customer.ShippingInfoId).ToList();

            return Mapper.Map<IEnumerable<Model.ShippingInfo>>(item);
        }
    }
}
