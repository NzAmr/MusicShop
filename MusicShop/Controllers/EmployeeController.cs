using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MusicShop.Model;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Database;
using MusicShop.Services.Interfaces;
using System.Security.Claims;

namespace MusicShop.Controllers
{
    
    [ApiController]
    [Route("[controller]")]
    public class EmployeeController : BaseCRUDController<Model.Employee, NameSearchObject, EmployeeUpsertRequest, EmployeeUpsertRequest>
    {
        public EmployeeController(IEmployeeService service) : base(service) {}

        public override ActionResult<Model.Employee> Insert([FromBody] EmployeeUpsertRequest insert)
        {
            return base.Insert(insert);
        }
        [HttpPost("login")]
        public ActionResult<Model.Employee> Login([FromBody] LoginRequest request)
        {
            try
            {
                return Ok((Service as IEmployeeService).Login(request));
            }
            catch(Exception ex)
            {
                return BadRequest(ex.Message);
            }
            
        }
        [HttpPost("get-employee-login")]
        public ActionResult<Model.Employee> getEmployeeByLoginData()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);

            if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int employeeId))
            {
                return Unauthorized("User is not authenticated or customer ID is missing.");
            }
            try
            {
                return Ok((Service as IEmployeeService).GetById(employeeId));
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }


    }
}
