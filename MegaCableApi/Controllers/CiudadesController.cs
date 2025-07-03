using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace MegaCableApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CiudadesController : ControllerBase
    {
        private readonly IConfiguration _config;

        public CiudadesController(IConfiguration config)
        {
            _config = config;
        }

        [HttpGet]
public IActionResult Get()
{
    var ciudades = new List<object>();
    var connectionString = _config.GetConnectionString("DefaultConnection");

    using (var connection = new SqlConnection(connectionString))
    {
        string query = "SELECT id, nombre FROM ciudades";
        var command = new SqlCommand(query, connection);
        connection.Open();
        var reader = command.ExecuteReader();

        while (reader.Read())
        {
            ciudades.Add(new {
                id = (int)reader["id"],
                nombre = reader["nombre"].ToString()
            });
        }
    }

    return Ok(ciudades);
}

        [HttpPost]
        public IActionResult Post([FromBody] dynamic body)
        {
            string nombre = body.nombre;
            string connectionString = _config.GetConnectionString("DefaultConnection");

            using (var connection = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO ciudades (nombre, estados_abreviatura) VALUES (@nombre, '')";
                var command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@nombre", nombre);
                connection.Open();
                command.ExecuteNonQuery();
            }

            return Ok(new { success = true, message = "Ciudad agregada" });
        }
    }
}
