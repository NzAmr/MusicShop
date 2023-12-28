using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model
{
    public class Synthesizer : BaseProduct
    {
        public int? KeyboardSize { get; set; }
        public bool? WeighedKeys { get; set; }
        public int? Polyphony { get; set; }
        public int? NumberOfPresets { get; set; }
    }
}
