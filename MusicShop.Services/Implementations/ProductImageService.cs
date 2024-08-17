using AutoMapper;
using MusicShop.Model.Requests;
using MusicShop.Services.Database;
using MusicShop.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Implementations
{
    public class ProductImageService : BaseCRUDService<Model.ProductImage, Database.ProductImage, ProductImageSearchObject, ProductImageUpsertRequest, ProductImageUpsertRequest>, IProductImageService
    {
        public ProductImageService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
