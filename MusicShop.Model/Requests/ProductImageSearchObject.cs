using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.Requests
{
    public class ProductImageSearchObject : BaseSearchObject
    {
        public int ProductId { get; set; }
    }
}
