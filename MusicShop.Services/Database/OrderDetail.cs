using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class OrderDetail : BaseEntity
    {
        public int? ProductId { get; set; }
        public int? ShippingInfoId { get; set; }
        public string? OrderNumber { get; set; }
        public DateTime? OrderDate { get; set; }
        public string? ShippingStatus { get; set; }
        public virtual Product? Product { get; set; }
        public virtual ShippingInfo? ShippingInfo { get; set; }
    }
}
