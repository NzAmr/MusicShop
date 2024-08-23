using AutoMapper;
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
    public class ProductService : BaseCRUDService<Model.BaseModel.Product, Database.Product, ProductSearchObject, ProductUpsertRequest, ProductUpsertRequest>, IProductService
    {
        public ProductService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
