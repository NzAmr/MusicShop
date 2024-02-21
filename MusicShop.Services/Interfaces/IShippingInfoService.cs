using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Interfaces
{
    public interface IShippingInfoService : ICRUDService<Model.ShippingInfo, NameSearchObject, ShippingInfoUpsertRequest, ShippingInfoUpsertRequest>
    {
        IEnumerable<Model.ShippingInfo> GetByCustomerName(NameSearchObject search);
        IEnumerable<Model.ShippingInfo> GetByCustomerId(int Id);

    }
}
