// 
namespace MegaCableApi.DTOs {
    public class SuscriptoresDto {
        public int id { get; set; }
        public string? nombre { get; set; }
        public string? alias { get; set; }
        public string? correo { get; set; }
        public string? celular { get; set; }
        public int? ciudad_id { get; set; }
        public int? colonia_id { get; set; }
        public string? estados_abreviatura { get; set; }
        public string? tipo_suscriptor_codigo { get; set; }
    }
}