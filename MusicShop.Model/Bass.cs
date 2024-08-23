using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model
{
    public class Bass : Product
    {
        public int? GuitarTypeId { get; set; }
        public string? Pickups { get; set; }
        public int? Frets { get; set; }

    }
}
