using MusicShop.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MusicShop.Services.Interfaces
{
    public interface IMQRabbitService
    {
        void sendEmail(Mail mail);
    }
}
