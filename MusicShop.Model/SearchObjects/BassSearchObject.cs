using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.SearchObjects
{
    public class BassSearchObject : BaseSearchObject
    {
        public int? GuitarTypeId { get; set; }
        public string? Model { get; set; }
        public string? Pickups { get; set; }
        public int? Frets { get; set; }
        public string? ProductNumber { get; set; }
        public byte[]? ProductImage { get; set; }
        public int? BrandId { get; set; }
        public decimal? PriceFrom { get; set; }
        public decimal? PriceTo { get; set; }
        public string? Description { get; set; }

    }
}
