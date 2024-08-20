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
            CreateMap<NameUpsertRequest, Database.Brand>();

            CreateMap<Database.Guitar, Model.Guitar>();
            CreateMap<GuitarInsertRequest, Database.Guitar>();
            CreateMap<GuitarUpdateRequest, Database.Guitar>();

            CreateMap<Database.Amplifier, Model.Amplifier>();
            CreateMap<AmplifierInsertRequest, Database.Amplifier>();

            CreateMap<Database.Bass, Model.Bass>();
            CreateMap<BassUpsertRequest, Database.Bass>();

            CreateMap<Database.Synthesizer, Model.Synthesizer>();
            CreateMap<SynthesizerUpsertRequest, Database.Synthesizer>();
               
            CreateMap<Database.GearCategory, Model.GearCategory>();
            CreateMap<NameUpsertRequest,Database.GearCategory>();

            CreateMap<Database.Gear ,  Model.Gear>();  
            CreateMap<GearUpsertRequest, Database.Gear>();

            CreateMap<Database.ShippingInfo, Model.ShippingInfo>();
            CreateMap<ShippingInfoUpsertRequest, Database.ShippingInfo>();

            CreateMap<Database.Employee, Model.Employee>();
            CreateMap<EmployeeUpsertRequest, Database.Employee>();  

            CreateMap<Database.Customer, Model.Customer>();
            CreateMap<CustomerInsertRequest, Database.Customer>();

            CreateMap<Database.GuitarType, Model.GuitarType>();
            CreateMap<NameUpsertRequest, Database.GuitarType>();

            CreateMap<Database.StudioReservation, Model.StudioReservation>();
            CreateMap<StudioReservationUpsertRequest, Database.StudioReservation>();
        }
    }
}
