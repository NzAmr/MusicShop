using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.Requests
{
    public class GuitarInsertRequest
    {
        public byte[]? ProductImage { get; set; }
        public int BrandId { get; set; }
        public string Model { get; set; }
        public decimal Price { get; set; }
        public string Description { get; set; }
        public int GuitarTypeId { get; set; }
        public string Pickups { get; set; }
        public string PickupConfiguration { get; set; }
        public int Frets { get; set; }
    }
}
