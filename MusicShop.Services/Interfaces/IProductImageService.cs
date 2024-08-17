using MusicShop.Model;
using MusicShop.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Interfaces
{
    public interface IProductImageService : ICRUDService<ProductImage,ProductImageSearchObject, ProductImageUpsertRequest, ProductImageUpsertRequest>
    {
    }
}
