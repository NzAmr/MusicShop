using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using MusicShop.Model;
using MusicShop.Model.BaseModel;
using MusicShop.Services.Database;
using MusicShop.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MusicShop.Services.Implementations
{
    public class ProductService : BaseCRUDService<Model.BaseModel.Product, Database.Product, ProductSearchObject, ProductUpsertRequest, ProductUpsertRequest>, IProductService
    {
        private readonly MLContext _mlContext;
        private readonly ITransformer _model;

        public ProductService(MusicShopDBContext context, IMapper mapper) : base(context, mapper)
        {
            _mlContext = new MLContext();
            _model = TrainModel();
        }

        public override IQueryable<Database.Product> AddFilter(IQueryable<Database.Product> query, ProductSearchObject? search = null)
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
                filteredQuery = filteredQuery.Where(x => x.Price >= search.PriceFrom);
            }
            if (search.PriceTo != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Price <= search.PriceTo);
            }


            return filteredQuery;
        }

        private ITransformer TrainModel()
        {
            var products = Context.Products.Select(p => new ProductFeatures
            {
                Id = p.Id,
                Description = p.Description ?? "",
                Brand = p.Brand.Name ?? ""
            }).ToList();

            var data = _mlContext.Data.LoadFromEnumerable(products);

            var pipeline = _mlContext.Transforms.Text.FeaturizeText("DescriptionFeaturized", nameof(ProductFeatures.Description))
                .Append(_mlContext.Transforms.Text.FeaturizeText("BrandFeaturized", nameof(ProductFeatures.Brand)))
                .Append(_mlContext.Transforms.Concatenate("Features", "DescriptionFeaturized", "BrandFeaturized"));

            return pipeline.Fit(data);
        }

        public static double ComputeCosineSimilarity(float[] featuresA, float[] featuresB)
        {
            double dotProduct = 0.0;
            double magnitudeA = 0.0;
            double magnitudeB = 0.0;

            for (int i = 0; i < featuresA.Length; i++)
            {
                dotProduct += featuresA[i] * featuresB[i];
                magnitudeA += Math.Pow(featuresA[i], 2);
                magnitudeB += Math.Pow(featuresB[i], 2);
            }

            magnitudeA = Math.Sqrt(magnitudeA);
            magnitudeB = Math.Sqrt(magnitudeB);

            if (magnitudeA == 0 || magnitudeB == 0)
                return 0;

            return dotProduct / (magnitudeA * magnitudeB);
        }

        public async Task<List<Model.BaseModel.Product>> RecommendProductsAsync(int customerId)
        {
            var purchasedProductIds = await Context.Orders
                .Where(o => o.ShippingInfo.CustomerId == customerId)
                .Select(o => o.ProductId)
                .Distinct()
                .ToListAsync();

            var allProducts = Context.Products.Include(x => x.Brand).ToList();
            var productFeatures = allProducts
                .Select(p => new ProductFeatures
                {
                    Id = p.Id,
                    Description = p.Description ?? "",
                    Brand = p.Brand?.Name ?? ""
                }).ToList();

            var transformedData = _mlContext.Data.LoadFromEnumerable(productFeatures);
            var features = _model.Transform(transformedData);
            var productFeatureVectors = _mlContext.Data.CreateEnumerable<ProductPrediction>(features, reuseRowObject: false).ToList();

            var recommendations = new List<Tuple<Model.BaseModel.Product, double>>();
            var recommendedProductIds = new HashSet<int>();

            foreach (var product in productFeatureVectors)
            {
                if (purchasedProductIds.Contains(product.Id))
                    continue;

                double similarityScore = productFeatureVectors
                    .Where(p => p.Id != product.Id && purchasedProductIds.Contains(p.Id))
                    .Select(p => ComputeCosineSimilarity(product.Features, p.Features))
                    .DefaultIfEmpty(0)
                    .Max();

                if (similarityScore > 0 && !recommendedProductIds.Contains(product.Id))
                {
                    var productEntity = allProducts.First(p => p.Id == product.Id);
                    var mappedProduct = Mapper.Map<Model.BaseModel.Product>(productEntity);

                    recommendations.Add(new Tuple<Model.BaseModel.Product, double>(mappedProduct, similarityScore));
                    recommendedProductIds.Add(product.Id);
                }
            }

            var sortedRecommendations = recommendations
                .OrderByDescending(r => r.Item2)
                .Select(r => r.Item1)
                .ToList();

            return sortedRecommendations.Take(3).ToList();
        }



        public class ProductFeatures
        {
            public int Id { get; set; }
            public string Description { get; set; }
            public string Brand { get; set; }
        }

        public class ProductPrediction
        {
            public int Id { get; set; }

            [VectorType]
            public float[] Features { get; set; }
        }
    }
}
