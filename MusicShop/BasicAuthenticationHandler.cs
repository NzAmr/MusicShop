using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using MusicShop.Model;
using MusicShop.Model.Requests;
using MusicShop.Services.Interfaces;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace MusicShop
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly IEmployeeService _employeeService;
        private readonly ICustomerService _customerService;

        public BasicAuthenticationHandler(
            IOptionsMonitor<AuthenticationSchemeOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder,
            ISystemClock clock,
            IEmployeeService employeeService,
            ICustomerService customerService
        ) : base(options, logger, encoder, clock)
        {
            _employeeService = employeeService;
            _customerService = customerService;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
            {
                return AuthenticateResult.Fail("Missing Authorization header");
            }

            var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
            var credentialsBytes = Convert.FromBase64String(authHeader.Parameter);
            var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');

            if (credentials.Length != 2)
            {
                return AuthenticateResult.Fail("Invalid authorization header format");
            }

            var username = credentials[0];
            var password = credentials[1];

            object user = null;
            string role = null;
            string userId = null;

            try
            {
               
                var employee = _employeeService.Login(new LoginRequest { Username = username, Password = password });
                if (employee != null)
                {
                    user = employee;
                    role = "Employee";
                    userId = employee.Id.ToString();
                }
            }
            catch (Exception)
            {
               
            }

            if (user == null)
            {
                try
                {
                    
                    var customer = _customerService.Login(new LoginRequest { Username = username, Password = password });
                    if (customer != null)
                    {
                        user = customer;
                        role = "Customer";
                        userId = customer.Id.ToString();
                    }
                }
                catch (Exception)
                {
                   
                }
            }

            if (user == null)
            {
                return AuthenticateResult.Fail("Incorrect username or password");
            }

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, username),
                new Claim(ClaimTypes.Name, GetFirstName(user)),
                new Claim(ClaimTypes.Role, role),
                new Claim(ClaimTypes.NameIdentifier, userId)
            };

            var identity = new ClaimsIdentity(claims, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);
            var ticket = new AuthenticationTicket(principal, Scheme.Name);

            return AuthenticateResult.Success(ticket);
        }

        private string GetFirstName(object user)
        {
            if (user is Employee employee)
            {
                return employee.FirstName;
            }
            else if (user is Customer customer)
            {
                return customer.FirstName;
            }
            return string.Empty;
        }
    }
}
