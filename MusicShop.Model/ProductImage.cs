﻿using MusicShop.Model.BaseModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Model
{
    public class ProductImage : BaseClassModel
    {
        public byte[]? Data { get; set; }
    }
}