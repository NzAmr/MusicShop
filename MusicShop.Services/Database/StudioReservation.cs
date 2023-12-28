using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class StudioReservation : BaseEntity
    {
        public int? CustomerId { get; set; }
        public DateTime? TimeFrom { get; set; }
        public DateTime? TimeTo { get; set; }

        public virtual Customer? Customer { get; set; }
    }
}
