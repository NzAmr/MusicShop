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
    public class BassService : BaseCRUDService<Model.Bass, Database.Bass, BassSearchObject, BassUpsertRequest, BassUpsertRequest>, IBassService
    {
        public BassService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Bass> AddFilter(IQueryable<Bass> query, BassSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search.BrandId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.BrandId == search.BrandId);
            }

            if (search.Model != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Model.ToLower().Contains(search.Model.ToLower()));
            }

            if (search.PriceFrom != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Price > search.PriceFrom);
            }
            if (search.PriceTo != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Price < search.PriceTo);
            }

            if (search.Description != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Description.ToLower().Contains(search.Description.ToLower()));
            }

            if (search.GuitarTypeId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.GuitarTypeId == search.GuitarTypeId);
            }

            if (search.Pickups != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Pickups.ToLower().Contains(search.Pickups.ToLower()));
            }

            if (search.Frets != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Frets == search.Frets);
            }

            if (search.ProductNumber != null)
            {
                filteredQuery = filteredQuery.Where(x => x.ProductNumber.ToLower().Contains(search.ProductNumber.ToLower()));
            }

           

            return filteredQuery;
        }

        public override IQueryable<Bass> AddInclude(IQueryable<Bass> query, BassSearchObject? search = null)
        {
            query = query.Include(x => x.Brand);
            query = query.Include(x => x.GuitarType);

            return query;
        }

        public override void BeforeInsert(BassUpsertRequest insert, Bass entity)
        {
            entity.Type = nameof(Bass);

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
