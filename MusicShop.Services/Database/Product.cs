﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MusicShop.Services.Database
{
    public abstract class Product : BaseEntity
    {
        public Product()
        {
            OrderDetails = new HashSet<Order>();
        }

        public string? ProductNumber { get; set; }
        public int? BrandId { get; set; }
        public string? Model { get; set; }
        public decimal? Price { get; set; }
        public string? Description { get; set; }
        public DateTime? CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public string? Type { get; set; }
        public virtual Brand? Brand { get; set; }
        public virtual byte[]? ProductImage { get; set; }

        public virtual ICollection<Order> OrderDetails { get; set; }
    }
}
