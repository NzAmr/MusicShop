using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class ProductImage : BaseEntity
    {
        public ProductImage()
        {
            Products = new HashSet<Product>();
        }

        public byte[]? Data { get; set; }

        public virtual ICollection<Product> Products { get; set; }
    }
}
