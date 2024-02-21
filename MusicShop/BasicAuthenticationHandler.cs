using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using MusicShop.Model;
using MusicShop.Model.Requests;
using MusicShop.Services.Implementations;
using MusicShop.Services.Interfaces;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace MusicShop
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        public IEmployeeService EmployeeService { get; set; }
        public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> options, ILoggerFactory logger, UrlEncoder encoder, ISystemClock clock, IEmployeeService employeeService) : base(options, logger, encoder, clock)
        {
            EmployeeService = employeeService;
        }

        protected override Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
            {
                return Task.FromResult(AuthenticateResult.Fail("Missing Authorization header"));
            }
            var userType = AuthenticationHeaderValue.Parse(Request.Headers["X-User-Type"]).ToString();
            var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);

            var credentialsBytes = Convert.FromBase64String(authHeader.Parameter);

            var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');

            var username = credentials[0];
            var password = credentials[1];

            var loginRequest = new LoginRequest() { Username = username, Password = password };

            Employee employee = null;

            employee = EmployeeService.Login(loginRequest);
            

            if (employee == null)
            {
                return Task.FromResult(AuthenticateResult.Fail("Incorrect username or password"));
            }

            var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, username),
            new Claim(ClaimTypes.Name, employee.FirstName),
            new Claim(ClaimTypes.Uri, employee.Id.ToString())
        };

            
            var identity = new ClaimsIdentity(claims, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);

            var ticket = new AuthenticationTicket(principal, Scheme.Name);

            return Task.FromResult(AuthenticateResult.Success(ticket));
        }
    }
}
