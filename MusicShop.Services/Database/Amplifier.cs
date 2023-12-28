using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class Amplifier : Product
    {
        public int? Voltage { get; set; }
        public int? PowerRating { get; set; }
        public bool? HeadphoneJack { get; set; }
        public bool? Usbjack { get; set; }
        public int? NumberOfPresets { get; set; }

    }
}
