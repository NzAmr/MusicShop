﻿using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model
{
    public class Amplifier : Product
    {
        public string? ProductNumber { get; set; }
        public int? ProductImageId { get; set; }
        public int? BrandId { get; set; }
        public string? Model { get; set; }
        public decimal? Price { get; set; }
        public string? Description { get; set; }
        public int? Voltage { get; set; }
        public int? PowerRating { get; set; }
        public bool? HeadphoneJack { get; set; }
        public bool? Usbjack { get; set; }
        public int? NumberOfPresets { get; set; }
    }
}
