using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.BaseModel
{
    public class Product : BaseClassModel
    {
        public string? ProductNumber { get; set; }
        public Brand? Brand { get; set; }
        public string? Model { get; set; }
        public decimal? Price { get; set; }
        public string? Description { get; set; }
        public DateTime? CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public byte[]? ProductImage { get; set; }
        public string? Type { get; set; }
    }
}
