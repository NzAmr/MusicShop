﻿using MusicShop.Model;
using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class Customer : BaseEntity
    {
        public Customer()
        {
            StudioReservations = new HashSet<StudioReservation>();
            ShippingInfos = new HashSet<ShippingInfo>();
        }

        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public string? Username { get; set; }
        public string? Email { get; set; }
        public string? PasswordHash { get; set; }
        public string? PasswordSalt { get; set; }
        public bool? Status { get; set; }
        public string? PhoneNumber { get; set; }
        public DateTime? CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }

        public virtual ICollection<StudioReservation> StudioReservations { get; set; }
        public virtual ICollection<ShippingInfo> ShippingInfos { get; set; } 

    }
}
