using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MusicShop.Model;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Interfaces;
using System.Security.Claims;

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
        [HttpPost("get-customer-login")]
        public ActionResult<Customer> getCustomerByLoginData()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);

            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int customerId))
            {
                return Unauthorized("User is not authenticated or customer ID is missing.");
            }
            try
            {
                return Ok((Service as ICustomerService).GetById(customerId));
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }
    }
}
