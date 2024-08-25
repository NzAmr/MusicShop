using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.Requests
{
    public class OrderInsertRequest
    {
        public int ProductId { get; set; }
        public int ShippingInfoId { get; set; }
        public string? PaymentId { get; set; }
    }
}
