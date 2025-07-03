// MegaCableApi/DTOs/DeudaDto.cs
namespace MegaCableApi.DTOs
{
    public class DeudaDto
    {
        public int SuscriptorId { get; set; }
        public string Nombre { get; set; }
        public string Alias { get; set; }
        public decimal Total { get; set; }
        public DateTime FechaCalculo { get; set; }
        public DateTime FechaProximoPago { get; set; }
        public List<ServicioDeudaDto> Servicios { get; set; } = new();
        public List<PromocionDeudaDto> Promociones { get; set; } = new();
    }

    public class ServicioDeudaDto
    {
        public string Nombre { get; set; }
        public decimal Precio { get; set; }
    }

    public class PromocionDeudaDto
    {
        public string Nombre { get; set; }
        public decimal Descuento { get; set; }
    }
}