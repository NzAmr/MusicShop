using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace MusicShop.Services.Database
{
    public partial class Guitar : Product
    {
        
        public int? GuitarTypeId { get; set; }
        public string? Pickups { get; set; }
        public string? PickupConfiguration { get; set; }
        public int? Frets { get; set; }

        public virtual GuitarType? GuitarType { get; set; }
    }
}
