﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MusicShop.Model.BaseModel;

namespace MusicShop.Model.SearchObjects
{
    public class OrderSearchObject : BaseSearchObject
    {
        public int? CustomerId { get; set; }

    }
}
