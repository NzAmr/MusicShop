using System;
using System.Collections.Generic;

namespace MusicShop.Services.Database
{
    public partial class GuitarType
    {
        public GuitarType()
        {
            Basses = new HashSet<Bass>();
            Guitars = new HashSet<Guitar>();
        }

        public int Id { get; set; }
        public string? Name { get; set; }

        public virtual ICollection<Bass> Basses { get; set; }
        public virtual ICollection<Guitar> Guitars { get; set; }
    }
}
