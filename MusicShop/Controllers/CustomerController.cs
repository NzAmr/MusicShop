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
    public class CustomerController : BaseCRUDController<Model.Customer, NameSearchObject, CustomerInsertRequest, CustomerUpdateRequest>
    {
        public CustomerController(ICustomerService service) : base(service) {}

        public override ActionResult<Customer> Insert([FromBody] CustomerInsertRequest insert)
        {
            return base.Insert(insert);
        }

        [HttpPost("login")]
        public ActionResult<Customer> Login([FromBody] LoginRequest request)
        {
            try
            {
                return Ok((Service as ICustomerService).Login(request));
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }
    }
}
