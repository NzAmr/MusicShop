using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.BaseModel
{
    public class ProductSearchObject : BaseSearchObject
    {
        public int? BrandId { get; set; }
        public string? Model { get; set; }
        public decimal? PriceFrom { get; set; }
        public decimal? PriceTo { get; set; }
    }
}
