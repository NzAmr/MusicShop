using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MusicShop.Model;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Interfaces;

namespace MusicShop.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProductImageController : BaseCRUDController<ProductImage, ProductImageSearchObject, ProductImageUpsertRequest, ProductImageUpsertRequest>
    {
        public ProductImageController(IProductImageService service) : base(service)
        {
        }

   
    }
}
