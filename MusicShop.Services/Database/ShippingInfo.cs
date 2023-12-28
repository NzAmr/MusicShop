using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class ShippingInfo : BaseEntity
    {
        public ShippingInfo()
        {
            Customers = new HashSet<Customer>();
        }

        public string? Country { get; set; }
        public string? StateOrProvince { get; set; }
        public string? City { get; set; }
        public string? ZipCode { get; set; }
        public string? StreetAddress { get; set; }

        public virtual ICollection<Customer> Customers { get; set; }
    }
}
