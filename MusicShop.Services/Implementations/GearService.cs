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
    public class GearService : BaseCRUDService<Model.Gear, Database.Gear, GearSearchObject, GearUpsertRequest, GearUpsertRequest>, IGearService
    {
        public GearService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override void BeforeInsert(GearUpsertRequest insert, Gear entity)
        {
            entity.Type = nameof(Gear);

            entity.CreatedAt = DateTime.Now;
            entity.UpdatedAt = DateTime.Now;
            entity.ProductNumber = GenerateUniqueProductNumber();
        }
        public override IQueryable<Gear> AddInclude(IQueryable<Gear> query, GearSearchObject? search = null)
        {
            query = query.Include(x => x.Brand);
            query = query.Include(x => x.GearCategory);
            return query;
        }
        public override IQueryable<Gear> AddFilter(IQueryable<Gear> query, GearSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.GearCategoryId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.GearCategoryId == search.GearCategoryId);
            }

            if (search.BrandId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.BrandId == search.BrandId);
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
                filteredQuery = filteredQuery.Where(x => x.Price >= search.PriceFrom);
            }

            if (search.PriceTo != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Price <= search.PriceTo);
            }

            return filteredQuery;
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
