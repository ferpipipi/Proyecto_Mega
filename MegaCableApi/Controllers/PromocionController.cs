using Microsoft.AspNetCore.Mvc;
using MegaCableApi.DTOs;
using Microsoft.Data.SqlClient;

namespace MegaCableApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")] // /api/promociones
    public class PromocionesController : ControllerBase
    {
        private readonly IConfiguration _config;

        public PromocionesController(IConfiguration config)
        {
            _config = config;
        }

        // GET: api/promociones
        [HttpGet]
        public IActionResult GetAllPromociones()
        {
            try
            {
                var promociones = new List<PromocionDto>();
                string connectionString = _config.GetConnectionString("DefaultConnection")
                    ?? throw new InvalidOperationException("Cadena de conexión no configurada.");

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"SELECT 
                                id, nombre, descripcion, tipo_promocion,
                                valor_descuento, es_porcentaje, duracion_meses,
                                fecha_inicio, fecha_fin, activo
                             FROM promociones";

                    SqlCommand command = new SqlCommand(query, connection);
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            promociones.Add(new PromocionDto
                            {
                                id = Convert.ToInt32(reader["id"]),
                                nombre = reader["nombre"]?.ToString(),
                                descripcion = reader["descripcion"]?.ToString(),
                                tipo_promocion = reader["tipo_promocion"]?.ToString(),
                                valor_descuento = reader["valor_descuento"] == DBNull.Value
                                    ? 0
                                    : Convert.ToDecimal(reader["valor_descuento"]),
                                es_porcentaje = reader["es_porcentaje"] != DBNull.Value && Convert.ToBoolean(reader["es_porcentaje"]),
                                duracion_meses = reader["duracion_meses"] == DBNull.Value
                                    ? 0
                                    : Convert.ToInt32(reader["duracion_meses"]),
                                fecha_inicio = reader["fecha_inicio"] == DBNull.Value
                                    ? DateTime.MinValue
                                    : Convert.ToDateTime(reader["fecha_inicio"]),
                                fecha_fin = reader["fecha_fin"] == DBNull.Value
                                    ? DateTime.MinValue
                                    : Convert.ToDateTime(reader["fecha_fin"]),
                                activo = reader["activo"] != DBNull.Value && Convert.ToBoolean(reader["activo"])
                            });
                        }
                    }
                }

                return Ok(new { success = true, count = promociones.Count, data = promociones });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { success = false, message = "Error interno", error = ex.Message });
            }
        }

        // POST: api/promociones
        [HttpPost]
        public IActionResult Post([FromBody] PromocionDto promocion)
        {
            string connectionString = _config.GetConnectionString("DefaultConnection")
                ?? throw new InvalidOperationException("Cadena de conexión no configurada.");

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"INSERT INTO promociones (
                                    nombre, descripcion, tipo_promocion,
                                    valor_descuento, es_porcentaje, duracion_meses,
                                    fecha_inicio, fecha_fin, activo
                                ) VALUES (
                                    @nombre, @descripcion, @tipo_promocion,
                                    @valor_descuento, @es_porcentaje, @duracion_meses,
                                    @fecha_inicio, @fecha_fin, @activo
                                )";

                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@nombre", promocion.nombre ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@descripcion", promocion.descripcion ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@tipo_promocion", promocion.tipo_promocion ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@valor_descuento", promocion.valor_descuento);
                command.Parameters.AddWithValue("@es_porcentaje", promocion.es_porcentaje);
                command.Parameters.AddWithValue("@duracion_meses", promocion.duracion_meses);
                command.Parameters.AddWithValue("@fecha_inicio", promocion.fecha_inicio);
                command.Parameters.AddWithValue("@fecha_fin", promocion.fecha_fin);
                command.Parameters.AddWithValue("@activo", promocion.activo);

                connection.Open();
                command.ExecuteNonQuery();
            }

            return Ok(new { success = true, message = "Promoción creada correctamente" });
        }
    }
}
