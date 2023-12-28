using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class Synthesizer : Product
    {
        public int? KeyboardSize { get; set; }
        public bool? WeighedKeys { get; set; }
        public int? Polyphony { get; set; }
        public int? NumberOfPresets { get; set; }

    }
}
