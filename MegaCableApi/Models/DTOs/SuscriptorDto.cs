// 
namespace MegaCableApi.DTOs {
    public class SuscriptoresDto {
        public required int id { get; set; }
        public required string? nombre { get; set; }
        public required string? alias { get; set; }
        public required string? correo { get; set; }
        public required string? celular { get; set; }
        public required int? ciudad_id { get; set; }
        public required int? colonia_id { get; set; }
        public required string? estados_abreviatura { get; set; }
        public required string? tipo_suscriptor_codigo { get; set; }
    }
}