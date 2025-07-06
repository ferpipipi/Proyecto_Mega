using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace MegaCableApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ColoniasController : ControllerBase
    {
        private readonly IConfiguration _config;

        public ColoniasController(IConfiguration config)
        {
            _config = config;
        }

        [HttpGet]
        public IActionResult Get()
        {
            var colonias = new List<object>();
            var connectionString = _config.GetConnectionString("DefaultConnection");

            using (var connection = new SqlConnection(connectionString))
            {
                string query = "SELECT id, nombre FROM colonias";
                var command = new SqlCommand(query, connection);
                connection.Open();
                var reader = command.ExecuteReader();

                while (reader.Read())
                {
                    colonias.Add(new {
                        id = (int)reader["id"],
                        nombre = reader["nombre"].ToString()
                    });
                }
            }

            return Ok(colonias);
        }


        [HttpPost]
        public IActionResult Post([FromBody] dynamic body)
        {
            string nombre = body.nombre;
            string connectionString = _config.GetConnectionString("DefaultConnection");

            using (var connection = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO colonias (nombre, ciudad_id, abrevCiudad) VALUES (@nombre, 1, '')";
                var command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@nombre", nombre);
                // ⚠️ ciudad_id HARDCODEADO a 1 por ahora (luego podemos elegir ciudad)
                connection.Open();
                command.ExecuteNonQuery();
            }

            return Ok(new { success = true, message = "Colonia agregada" });
        }
    }
}
