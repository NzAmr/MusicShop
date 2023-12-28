using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.SearchObjects
{
    public class GearSearchObject : ProductSearchObject
    {
        public int? GearCategoryId { get; set; }
    }
}
