using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MusicShop.Services.Database
{
    public abstract class Product : BaseEntity
    {
        public Product()
        {
            OrderDetails = new HashSet<OrderDetail>();
        }

        public string? ProductNumber { get; set; }
        public int? ProductImageId { get; set; }
        public int? BrandId { get; set; }
        public string? Model { get; set; }
        public decimal? Price { get; set; }
        public string? Description { get; set; }
        public DateTime? CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }

        public virtual Brand? Brand { get; set; }
        public virtual ProductImage? ProductImage { get; set; }

        public virtual ICollection<OrderDetail> OrderDetails { get; set; }
    }
}
