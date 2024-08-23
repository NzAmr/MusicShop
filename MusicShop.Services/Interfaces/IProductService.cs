using MusicShop.Model.BaseModel;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MusicShop.Services.Interfaces
{
    public interface IProductService : ICRUDService<Product, ProductSearchObject, ProductUpsertRequest, ProductUpsertRequest>
    {
        Task<List<Product>> RecommendProductsAsync(int customerId);
    }
}
