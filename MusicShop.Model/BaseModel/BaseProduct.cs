using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.BaseModel
{
    public abstract class BaseProduct : BaseClassModel
    {
        public string? ProductNumber { get; set; }
        public int? ProductImageId { get; set; }
        public int? BrandId { get; set; }
        public string? Model { get; set; }
        public decimal? Price { get; set; }
        public string? Description { get; set; }
        public DateTime? CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public byte[]? ProductImage { get; set; }
    }
}
