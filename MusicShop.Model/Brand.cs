using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model
{
    public class Brand : BaseClassModel
    {
        public string? Name { get; set; }


        public override string ToString() => Name.ToString();
       
    }
}
