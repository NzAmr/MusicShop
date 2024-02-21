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
    public class EmployeeController : BaseCRUDController<Employee, NameSearchObject, EmployeeUpsertRequest, EmployeeUpsertRequest>
    {
        public EmployeeController(IEmployeeService service) : base(service) {}

        public override ActionResult<Employee> Insert([FromBody] EmployeeUpsertRequest insert)
        {
            return base.Insert(insert);
        }
        [HttpPost("login")]
        public ActionResult<Employee> Login([FromBody] LoginRequest request)
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


    }
}
