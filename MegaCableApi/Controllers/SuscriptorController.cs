// Controllers/SuscriptoresController.cs
using Microsoft.AspNetCore.Mvc;
using MegaCableApi.DTOs;
using MegaCableApi.Entities;
using System.Data.SqlClient;
using Microsoft.Data.SqlClient; // Paquete más moderno y mantenido

namespace MegaCableApi.Controllers {
    [ApiController]
    [Route("api/[controller]")] // La ruta será /api/suscriptores
    public class SuscriptoresController : ControllerBase {
        private readonly IConfiguration _config;

        public SuscriptoresController(IConfiguration config) {
            _config = config;
        }

        // GET: api/suscriptores
        [HttpGet]
        public IActionResult GetAllSuscriptores()
{
    var suscriptores = new List<SuscriptoresDto>();
    string connectionString = _config.GetConnectionString("DefaultConnection") 
        ?? throw new InvalidOperationException("La cadena de conexión no está configurada.");

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                // Consulta para obtener todos los registros
                string query = @"SELECT 
                        id,
                        nombre,
                        alias,
                        correo,
                        celular,
                        ciudad_id,
                        colonia_id,
                        estados_abreviatura,
                        tipo_suscriptor_codigo
                    FROM suscriptores";

                SqlCommand command = new SqlCommand(query, connection);
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        suscriptores.Add(new SuscriptoresDto
                        {
                            id = reader["id"] as int? ?? 0, // Manejo seguro de nulls
                            nombre = reader["nombre"]?.ToString(),
                            alias = reader["alias"]?.ToString(),
                            correo = reader["correo"]?.ToString(),
                            celular = reader["celular"]?.ToString(),
                            ciudad_id = reader["ciudad_id"] as int?,
                            colonia_id = reader["colonia_id"] as int?,
                            estados_abreviatura = reader["estados_abreviatura"]?.ToString(),
                            tipo_suscriptor_codigo = reader["tipo_suscriptor_codigo"]?.ToString()
                            
                        });
                    }
                }
            }
            return Ok(new
            {
                success = true,
                count = suscriptores.Count,
                data = suscriptores
            });
        }

        // POST: api/suscriptores
        [HttpPost]
        public IActionResult Post([FromBody] SuscriptoresDto suscriptorDto) {
            string connectionString = _config.GetConnectionString("DefaultConnection") 
            ?? throw new InvalidOperationException("La cadena de conexión no está configurada.");
    
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO suscriptores (nombre, correo, ...) VALUES (@Nombre, @Correo, ...)";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@Nombre", suscriptorDto.nombre);
                command.Parameters.AddWithValue("@Correo", suscriptorDto.correo);
                command.Parameters.AddWithValue("@Alias", suscriptorDto.alias);
                command.Parameters.AddWithValue("@Celular", suscriptorDto.celular);
                command.Parameters.AddWithValue("@CiudadId", suscriptorDto.ciudad_id ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@ColoniaId", suscriptorDto.colonia_id ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@EstadosAbreviatura", suscriptorDto.estados_abreviatura ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@TipoSuscriptorCodigo", suscriptorDto.tipo_suscriptor_codigo ?? (object)DBNull.Value);
            

                connection.Open();
                command.ExecuteNonQuery();
            }

            return Ok(new { success = true, message = "Suscriptor creado correctamente" });
        }
    }
}