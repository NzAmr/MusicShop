using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MusicShop.Model.BaseModel;

namespace MusicShop.Model.SearchObjects
{
    public class GuitarSearchObject : BaseSearchObject
    {
        public int? BrandId { get; set; }
        public string? Model { get; set; }
        public decimal? PriceFrom { get; set; }
        public decimal? PriceTo { get; set; }
        public int? GuitarTypeId { get; set; }
        public string? Pickups { get; set; }
        public string? PickupConfiguration { get; set; }
        public int? Frets { get; set; }
    }
}
