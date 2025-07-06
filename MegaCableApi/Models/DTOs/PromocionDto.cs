namespace MegaCableApi.DTOs
{
    public class PromocionDto
    {
        public int id { get; set; }
        public string? nombre { get; set; }
        public string? descripcion { get; set; }
        public string? tipo_promocion { get; set; }
        public decimal valor_descuento { get; set; }
        public bool es_porcentaje { get; set; }
        public int duracion_meses { get; set; }
        public DateTime fecha_inicio { get; set; }
        public DateTime fecha_fin { get; set; }
        public bool activo { get; set; }

        public string? ciudad_nombre { get; set; }
        public List<string> colonias_nombre { get; set; } = new();

        // Este campo no se usa al crear/actualizar promociones
        public int ciudad_id { get; set; }
        
        public List<int> colonias_id { get; set; } = new();
    }
}
