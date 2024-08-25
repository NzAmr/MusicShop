using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model
{
    public class Order: BaseClassModel
    {
        public string? OrderNumber { get; set; }
        public DateTime? OrderDate { get; set; }
        public string? ShippingStatus { get; set; }
        public string? PaymentId { get; set; }
        public virtual Product? Product { get; set; }
        public virtual ShippingInfo? ShippingInfo { get; set; }
    }
}
