using AutoMapper;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Database;
using MusicShop.Services.Helpers;
using MusicShop.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Implementations
{
    public class CustomerService : BaseCRUDService<Model.Customer, Database.Customer, NameSearchObject, CustomerInsertRequest, CustomerUpdateRequest>, ICustomerService
    {

        public CustomerService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override Model.Customer Insert(CustomerInsertRequest insert)
        {
            if(Context.Customers.FirstOrDefault(x=>x.Username == insert.Username) != null)
            {
                throw new Exception("Username is taken");
            }

            if(insert.Password != insert.PasswordConfirm)
            {
                throw new Exception("Password and confirmation must be identical");
            }

            return base.Insert(insert);
        }

        public override void BeforeInsert(CustomerInsertRequest insert, Customer entity)
        {
            var salt = AuthUtils.GenerateSalt();
            entity.PasswordSalt = salt;
            entity.PasswordHash = AuthUtils.GenerateHash(salt, insert.Password);
            entity.CreatedAt = DateTime.Now;
            entity.UpdatedAt = DateTime.Now;
            
    }

        public Model.Customer Login(LoginRequest request)
        {
            var entity = Context.Customers.FirstOrDefault(x => x.Username == request.Username);
            if (entity == null)
            {
                throw new Exception("User not found");
            }
            var hash = AuthUtils.GenerateHash(entity.PasswordSalt, request.Password);

            if (hash != entity.PasswordHash)
            {
                throw new Exception("Wrong password");
            }
            return Mapper.Map<Model.Customer>(entity);

        }
        public override IQueryable<Customer> AddFilter(IQueryable<Customer> query, NameSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if(search.Name != null)
            {
                string searchModelLower = search.Name.ToLower();
                filteredQuery = filteredQuery.Where(x =>
                    x.FirstName.ToLower().Contains(searchModelLower) ||
                    (x.LastName != null && x.LastName.ToLower().Contains(searchModelLower)) ||
                    (x.LastName != null && (x.FirstName + " " + x.LastName).ToLower().Contains(searchModelLower))
                );
            }
            return filteredQuery;
        }
    }
}
