using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MusicShop.Controllers;
using MusicShop.Model;
using MusicShop.Model.BaseModel;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Interfaces;
using System.Security.Claims;
using System.Threading.Tasks;

[ApiController]
[Route("[controller]")]
[Authorize]
public class ProductController : BaseCRUDController<Product, ProductSearchObject, ProductUpsertRequest, ProductUpsertRequest>
{
    private readonly IProductService _productService;

    public ProductController(IProductService productService) : base(productService)
    {
        _productService = productService;
    }

    [HttpGet("recommendations")]
    public async Task<IActionResult> GetRecommendations()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);

        if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int customerId))
        {
            return Unauthorized("User is not authenticated or customer ID is missing.");
        }

        try
        {
            var recommendations = await _productService.RecommendProductsAsync(customerId);
            return Ok(recommendations);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"Internal server error: {ex.Message}");
        }
    }
}
