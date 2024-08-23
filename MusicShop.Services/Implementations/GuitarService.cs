using AutoMapper;
using Microsoft.EntityFrameworkCore;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Database;
using MusicShop.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Implementations
{
    public class GuitarService : BaseCRUDService<Model.Guitar, Database.Guitar, GuitarSearchObject, GuitarInsertRequest, GuitarUpdateRequest>, IGuitarService
    {
        public GuitarService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public override IQueryable<Guitar> AddInclude(IQueryable<Guitar> query, GuitarSearchObject? search = null)
        {
            query = query.Include(x => x.Brand);
            query = query.Include(x => x.GuitarType);

            return query;
        }

        public override IQueryable<Guitar> AddFilter(IQueryable<Guitar> query, GuitarSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.BrandId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.BrandId == search.BrandId);
            }

            if (search.GuitarTypeId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.GuitarTypeId == search.GuitarTypeId);
            }

            if (search.Model != null)
            {
                string searchModelLower = search.Model.ToLower();

                filteredQuery = filteredQuery.Where(x =>
                    x.Model.ToLower().Contains(searchModelLower) ||
                    (x.Brand != null && x.Brand.Name.ToLower().Contains(searchModelLower)) ||
                    (x.Brand != null && (x.Brand.Name + " " + x.Model).ToLower().Contains(searchModelLower))
                );
            }


            if (search.PriceFrom != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Price > search.PriceFrom);
            }
            if (search.PriceTo != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Price < search.PriceTo);
            }

            if (search.Pickups != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Pickups.ToLower().Contains(search.Pickups.ToLower()));
            }

            if (search.PickupConfiguration != null)
            {
                filteredQuery = filteredQuery.Where(x => x.PickupConfiguration.ToLower().Contains(search.PickupConfiguration.ToLower()));
            }

            if (search.Frets != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Frets == search.Frets);
            }

            return filteredQuery;
        }

        public override void BeforeInsert(GuitarInsertRequest insert, Guitar entity)
        {
            entity.Type = nameof(Guitar);
            //entity.ProductImage = Convert.FromBase64String(insert.ProductImage);
            entity.CreatedAt = DateTime.Now;
            entity.UpdatedAt = DateTime.Now;
            entity.ProductNumber = GenerateUniqueProductNumber();
        }

        private string GenerateUniqueProductNumber()
        {
            string productNumber;
            bool isUnique;

            do
            {
                productNumber = "PRO" + DateTime.Now.ToString("yyyyMMddHHmmss") + new Random().Next(1000, 9999).ToString();
                isUnique = !Context.Products.Any(x => x.ProductNumber == productNumber);
            }
            while (!isUnique);

            return productNumber;
        }
    }
}
