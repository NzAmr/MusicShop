using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model.Requests
{
    public class SynthesizerUpsertRequest : ProductUpsertRequest
    {
        public int? KeyboardSize { get; set; }
        public bool? WeighedKeys { get; set; }
        public int? Polyphony { get; set; }
        public int? NumberOfPresets { get; set; }
    }
}
