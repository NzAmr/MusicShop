using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class Gear : Product
    {
        public int? GearCategoryId { get; set; }

        public virtual GearCategory? GearCategory { get; set; }

    }
}
