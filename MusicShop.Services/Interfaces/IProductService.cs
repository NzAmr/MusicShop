using MusicShop.Model.BaseModel;
using MusicShop.Services.Implementations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Interfaces
{
    public interface IProductService : ICRUDService<Model.BaseModel.Product, ProductSearchObject, ProductUpsertRequest, ProductUpsertRequest>
    {
    }
}
