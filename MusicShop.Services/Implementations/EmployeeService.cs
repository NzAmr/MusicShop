using AutoMapper;
using Microsoft.EntityFrameworkCore;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Database;
using MusicShop.Services.Helpers;
using MusicShop.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Implementations
{
    public class EmployeeService : BaseCRUDService<Model.Employee, Database.Employee, NameSearchObject, EmployeeUpsertRequest, EmployeeUpsertRequest>, IEmployeeService
    {
        public EmployeeService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }


        public override Model.Employee Insert(EmployeeUpsertRequest insert)
        {
            if (Context.Employees.FirstOrDefault(x => x.Username == insert.Username) != null)
            {
                throw new Exception("Username is taken");
            }

            if(insert.Password!=insert.PasswordConfirm)
            {
                throw new Exception("Password and confirmation must be identical");
            }


            return base.Insert(insert);
        }

        public override void BeforeInsert(EmployeeUpsertRequest insert, Employee entity)
        {
            var salt = AuthUtils.GenerateSalt();
            entity.PasswordSalt = salt;
            entity.PasswordHash = AuthUtils.GenerateHash(salt, insert.Password);
            entity.CreatedAt = DateTime.Now;
            entity.UpdatedAt = DateTime.Now;
            ShippingInfo shippingInfo = new ShippingInfo();

        }
        public Model.Employee Login(LoginRequest request)
        { 
          var entity = Context.Employees.FirstOrDefault(x => x.Username == request.Username);
          if (entity == null)
            {
                throw new Exception("User not found");
            }
            var hash = AuthUtils.GenerateHash(entity.PasswordSalt, request.Password);

            if(hash != entity.PasswordHash)
            {
                throw new Exception("Wrong password");
            }
            return Mapper.Map<Model.Employee>(entity);
          
        }
        public override Model.Employee Update(int id, EmployeeUpsertRequest update)
        {
            var entity = Context.Employees.Find(id);
            if (entity == null)
            {
                throw new Exception("Employee not found");
            }

            
            Mapper.Map(update, entity);

            if (!string.IsNullOrEmpty(update.Password))
            {
                if (update.Password != update.PasswordConfirm)
                {
                    throw new Exception("Password and confirmation must be identical");
                }

                var salt = AuthUtils.GenerateSalt();
                entity.PasswordSalt = salt;
                entity.PasswordHash = AuthUtils.GenerateHash(salt, update.Password);
            }

            entity.UpdatedAt = DateTime.Now;

            Context.SaveChanges();
            return Mapper.Map<Model.Employee>(entity);
        }
    }
}
