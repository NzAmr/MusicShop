using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.SearchObjects
{
    public class StudioReservationSearchObject :BaseSearchObject
    {
        public int? CustomerId { get; set; }
    }
}
