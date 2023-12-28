using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class GearCategory : BaseEntity
    {
        public GearCategory()
        {
            Gears = new HashSet<Gear>();
        }

        public string? Name { get; set; }

        public virtual ICollection<Gear> Gears { get; set; }
    }
}
