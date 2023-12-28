using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MusicShop.Model.BaseModel;

namespace MusicShop.Model.SearchObjects
{
    public class AmplifierSearchObject : BaseSearchObject
    {
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
