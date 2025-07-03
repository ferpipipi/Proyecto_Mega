using MegaCableApi.DTOs;
using MegaCableApi.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace MegaCableApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DeudaController : ControllerBase
    {
        private readonly IDeudaService _deudaService;

        public DeudaController(IDeudaService deudaService)
        {
            _deudaService = deudaService;
        }

        [HttpGet("{suscriptorId}")]
        public async Task<IActionResult> GetDeuda(int suscriptorId)
        {
            try
            {
                var deuda = await _deudaService.CalcularDeuda(suscriptorId);
                return Ok(new
                {
                    success = true,
                    data = deuda
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new
                {
                    success = false,
                    message = ex.Message
                });
            }
        }
    }
}