using MusicShop.Model.Requests;
using MusicShop.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Interfaces
{
    public interface IAmplifierService : ICRUDService<Model.Amplifier, AmplifierSearchObject, AmplifierInsertRequest, AmplifierUpdateRequest>
    {
    }
}
