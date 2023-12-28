using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class Bass : Product
    {
        public int? GuitarTypeId { get; set; }
        public string? Pickups { get; set; }
        public int? Frets { get; set; }

        public virtual GuitarType? GuitarType { get; set; }
    }
}
