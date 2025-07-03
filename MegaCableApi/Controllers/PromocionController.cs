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
                var connectionString = _config.GetConnectionString("DefaultConnection")
                    ?? throw new InvalidOperationException("Cadena de conexión no configurada.");

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT 
                            p.id, p.nombre, p.descripcion, p.tipo_promocion,
                            p.valor_descuento, p.es_porcentaje, p.duracion_meses,
                            p.fecha_inicio, p.fecha_fin, p.activo,
                            ciu.nombre AS ciudad_nombre,
                            col.nombre AS colonia_nombre
                        FROM promociones p
                        LEFT JOIN promocion_colonias pc ON p.id = pc.id_promocion
                        LEFT JOIN colonias col ON pc.id_colonia = col.id
                        LEFT JOIN ciudades ciu ON col.ciudad_id = ciu.id";

                    SqlCommand command = new SqlCommand(query, connection);
                    connection.Open();

                    var promoDict = new Dictionary<int, PromocionDto>();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            int id = Convert.ToInt32(reader["id"]);

                            if (!promoDict.ContainsKey(id))
                            {
                                promoDict[id] = new PromocionDto
                                {
                                    id = id,
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
                                    activo = reader["activo"] != DBNull.Value && Convert.ToBoolean(reader["activo"]),
                                    ciudad_nombre = reader["ciudad_nombre"]?.ToString(),
                                    colonias_nombre = new List<string>()
                                };
                            }

                            var coloniaNombre = reader["colonia_nombre"]?.ToString();
                            if (!string.IsNullOrEmpty(coloniaNombre) && !promoDict[id].colonias_nombre.Contains(coloniaNombre))
                            {
                                promoDict[id].colonias_nombre.Add(coloniaNombre);
                            }
                        }
                    }

                    promociones = promoDict.Values.ToList();
                }

                return Ok(new { success = true, count = promociones.Count, data = promociones });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { success = false, message = "Error interno", error = ex.Message });
            }
        }

        
        [HttpPost]
        public IActionResult Post([FromBody] PromocionDto promocion)
        {
            try
            {
                var connectionString = _config.GetConnectionString("DefaultConnection")
                    ?? throw new InvalidOperationException("Cadena de conexión no configurada.");

                int newPromoId;

                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string insertPromo = @"
                        INSERT INTO promociones (
                            nombre, descripcion, tipo_promocion,
                            valor_descuento, es_porcentaje, duracion_meses,
                            fecha_inicio, fecha_fin, activo, ciudad_id
                        ) VALUES (
                            @nombre, @descripcion, @tipo_promocion,
                            @valor_descuento, @es_porcentaje, @duracion_meses,
                            @fecha_inicio, @fecha_fin, @activo, @ciudad_id
                        );
                        SELECT SCOPE_IDENTITY();";

                    using (var cmd = new SqlCommand(insertPromo, connection))
                    {
                        cmd.Parameters.AddWithValue("@nombre", promocion.nombre ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@descripcion", promocion.descripcion ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@tipo_promocion", promocion.tipo_promocion ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@valor_descuento", promocion.valor_descuento);
                        cmd.Parameters.AddWithValue("@es_porcentaje", promocion.es_porcentaje);
                        cmd.Parameters.AddWithValue("@duracion_meses", promocion.duracion_meses);
                        cmd.Parameters.AddWithValue("@fecha_inicio", promocion.fecha_inicio);
                        cmd.Parameters.AddWithValue("@fecha_fin", promocion.fecha_fin);
                        cmd.Parameters.AddWithValue("@activo", promocion.activo);
                        cmd.Parameters.AddWithValue("@ciudad_id", promocion.ciudad_id);

                        newPromoId = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    foreach (var coloniaId in promocion.colonias_id)
                    {
                        string insertRelacion = @"
                            INSERT INTO promocion_colonias (id_promocion, id_colonia)
                            VALUES (@promoId, @coloniaId);";

                        using (var cmdRelacion = new SqlCommand(insertRelacion, connection))
                        {
                            cmdRelacion.Parameters.AddWithValue("@promoId", newPromoId);
                            cmdRelacion.Parameters.AddWithValue("@coloniaId", coloniaId);
                            cmdRelacion.ExecuteNonQuery();
                        }
                    }
                }

                return Ok(new { success = true, message = "Promoción y colonias guardadas correctamente" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { success = false, message = "Error al guardar la promoción", error = ex.Message });
            }
        }

    }
}
