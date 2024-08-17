using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class GuitarType : BaseEntity
    {
        public GuitarType()
        {
            Basses = new HashSet<Bass>();
            Guitars = new HashSet<Guitar>();
        }

        public string? Name { get; set; }

        public virtual ICollection<Bass> Basses { get; set; }
        public virtual ICollection<Guitar> Guitars { get; set; }
    }
}
