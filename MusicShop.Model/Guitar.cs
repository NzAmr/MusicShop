using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model
{
    public class Guitar : Product
    {

        public string? Pickups { get; set; }
        public string? PickupConfiguration { get; set; }
        public int? Frets { get; set; }
        public virtual GuitarType? GuitarType { get; set; }

    }
}
