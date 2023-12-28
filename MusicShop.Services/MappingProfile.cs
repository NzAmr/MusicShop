using AutoMapper;
using MusicShop.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace MusicShop.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.Brand, MusicShop.Model.Brand>();
            CreateMap<Database.Guitar, Model.Guitar>();
            CreateMap<GuitarInsertRequest, Database.Guitar>();

            CreateMap<BrandUpsertRequest, Database.Brand>();

            CreateMap<Database.Amplifier, Model.Amplifier>();
            CreateMap<AmplifierInsertRequest, Database.Amplifier>();
               
            
        }
    }
}
