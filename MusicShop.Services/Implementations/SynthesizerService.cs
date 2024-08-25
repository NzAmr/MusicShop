using AutoMapper;
using Microsoft.EntityFrameworkCore;
using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using MusicShop.Services.Database;
using MusicShop.Services.Interfaces;
using System;
using System.Linq;

namespace MusicShop.Services.Implementations
{
    public class SynthesizerService : BaseCRUDService<Model.Synthesizer, Database.Synthesizer, SynthesizerSearchObject, SynthesizerUpsertRequest, SynthesizerUpsertRequest>, ISynthesizerService
    {
        public SynthesizerService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override void BeforeInsert(SynthesizerUpsertRequest insert, Synthesizer entity)
        {
            entity.Type = nameof(Synthesizer);
            entity.CreatedAt = DateTime.Now;
            entity.UpdatedAt = DateTime.Now;
        }


        public override IQueryable<Synthesizer> AddInclude(IQueryable<Synthesizer> query, SynthesizerSearchObject? search = null)
        {
            query = query.Include(x => x.Brand);

            return query;
        }

        public override IQueryable<Synthesizer> AddFilter(IQueryable<Synthesizer> query, SynthesizerSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

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
                filteredQuery = filteredQuery.Where(x => x.Price > search.PriceFrom);
            }
            if (search.PriceTo != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Price < search.PriceTo);
            }


            if (search.KeyboardSize != null)
            {
                filteredQuery = filteredQuery.Where(x => x.KeyboardSize == search.KeyboardSize);
            }

            if (search.WeighedKeys != null)
            {
                filteredQuery = filteredQuery.Where(x => x.WeighedKeys == search.WeighedKeys);
            }

            if (search.Polyphony != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Polyphony == search.Polyphony);
            }

            if (search.NumberOfPresets != null)
            {
                filteredQuery = filteredQuery.Where(x => x.NumberOfPresets == search.NumberOfPresets);
            }

            return filteredQuery;
        }
    }
}
