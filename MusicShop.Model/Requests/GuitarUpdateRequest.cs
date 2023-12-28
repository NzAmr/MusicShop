using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.Requests
{
    public class GuitarUpdateRequest
    {
        public int? GuitarTypeId { get; set; }
        public string? Model { get; set; }
        public string? Pickups { get; set; }
        public string? PickupConfiguration { get; set; }
        public int? Frets { get; set; }

        public int? BrandId { get; set; }

        public decimal? Price { get; set; }
        public string? Description { get; set; }
        public DateTime? UpdatedAt { get; set; }
    }
}
