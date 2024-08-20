using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.Requests
{
    public class StudioReservationUpsertRequest
    {
        public DateTime? TimeFrom { get; set; }
        public DateTime? TimeTo { get; set; }

        public int? CustomerId { get; set; }
    }
}
