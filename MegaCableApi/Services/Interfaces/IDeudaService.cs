using MegaCableApi.DTOs;
using System.Threading.Tasks;

namespace MegaCableApi.Services.Interfaces
{
    public interface IDeudaService
    {
        Task<DeudaDto> CalcularDeuda(int suscriptorId);
    }
}