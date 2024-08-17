using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.Requests
{
    public class ProductImageUpsertRequest
    {
        public int ProductId { get; set; }
        public String? Data { get; set; }
    }
}
