using Microsoft.AspNetCore.Mvc;
using MegaCableApi.Models.DTOs;
using MegaCableApi.Services.Interfaces;

namespace MegaCableApi.Controllers;

/// <summary>
/// Controlador para gestión de suscriptores
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class SuscriptoresController : ControllerBase
{
  private readonly ISuscriptorService _suscriptorService;
  private readonly ILogger<SuscriptoresController> _logger;

  public SuscriptoresController(
      ISuscriptorService suscriptorService,
      ILogger<SuscriptoresController> logger)
  {
    _suscriptorService = suscriptorService;
    _logger = logger;
  }

  /// <summary>
  /// Obtiene estadísticas de suscriptores
  /// </summary>
  /// <returns>Estadísticas de suscriptores</returns>
  [HttpGet("estadisticas")]
  public async Task<ActionResult<EstadisticasSuscriptoresDto>> ObtenerEstadisticas()
  {
    try
    {
      var estadisticas = await _suscriptorService.ObtenerEstadisticasAsync();
      return Ok(estadisticas);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener estadísticas");
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Obtiene todos los suscriptores con filtros y paginación
  /// </summary>
  /// <param name="nombre">Filtro por nombre</param>
  /// <param name="correo">Filtro por correo</param>
  /// <param name="pagina">Página actual (default: 1)</param>
  /// <param name="tamanoPagina">Tamaño de página (default: 10)</param>
  /// <returns>Lista paginada de suscriptores</returns>
  [HttpGet]
  public async Task<ActionResult<RespuestaPaginadaSuscriptoresDto>> ObtenerSuscriptores(
      [FromQuery] string? nombre = null,
      [FromQuery] string? correo = null,
      [FromQuery] int pagina = 1,
      [FromQuery] int tamanoPagina = 10)
  {
    try
    {
      var filtros = new FiltrosSuscriptorDto
      {
        Nombre = nombre,
        Correo = correo,
        Pagina = pagina,
        TamanoPagina = tamanoPagina
      };

      var resultado = await _suscriptorService.ObtenerSuscriptoresAsync(filtros);
      return Ok(resultado);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener suscriptores");
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Obtiene un suscriptor por su ID
  /// </summary>
  /// <param name="id">ID del suscriptor</param>
  /// <returns>Suscriptor encontrado</returns>
  [HttpGet("{id:int}")]
  public async Task<ActionResult<SuscriptorDto>> ObtenerSuscriptor(int id)
  {
    try
    {
      if (id <= 0)
      {
        return BadRequest("El ID debe ser mayor a 0");
      }

      var suscriptor = await _suscriptorService.ObtenerSuscriptorPorIdAsync(id);

      if (suscriptor == null)
      {
        return NotFound($"Suscriptor con ID {id} no encontrado");
      }

      return Ok(suscriptor);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener suscriptor {Id}", id);
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Crea un nuevo suscriptor
  /// </summary>
  /// <param name="suscriptor">Datos del suscriptor a crear</param>
  /// <returns>Suscriptor creado</returns>
  [HttpPost]
  public async Task<ActionResult<SuscriptorDto>> CrearSuscriptor([FromBody] CrearSuscriptorDto suscriptor)
  {
    try
    {
      _logger.LogInformation("Iniciando creación de suscriptor: {Nombre}", suscriptor.Nombre);

      // Validaciones básicas
      if (string.IsNullOrWhiteSpace(suscriptor.Nombre))
      {
        return BadRequest("El nombre es requerido");
      }

      if (suscriptor.Nombre.Length > 100)
      {
        return BadRequest("El nombre no puede exceder 100 caracteres");
      }

      // Validar campos obligatorios según la base de datos
      if (suscriptor.CiudadId == null || suscriptor.CiudadId <= 0)
      {
        return BadRequest("El ID de ciudad es requerido");
      }

      if (suscriptor.ColoniaId == null || suscriptor.ColoniaId <= 0)
      {
        return BadRequest("El ID de colonia es requerido");
      }

      // Validar correo si se proporciona
      if (!string.IsNullOrWhiteSpace(suscriptor.Correo))
      {
        if (!IsValidEmail(suscriptor.Correo))
        {
          return BadRequest("El formato del correo electrónico no es válido");
        }

        if (suscriptor.Correo.Length > 50)
        {
          return BadRequest("El correo no puede exceder 50 caracteres");
        }

        // Verificar que el correo no exista
        var existeCorreo = await _suscriptorService.ExisteCorreoAsync(suscriptor.Correo);
        if (existeCorreo)
        {
          return Conflict("Ya existe un suscriptor con este correo electrónico");
        }
      }

      var nuevoSuscriptor = await _suscriptorService.CrearSuscriptorAsync(suscriptor);
      return CreatedAtAction(nameof(ObtenerSuscriptor), new { id = nuevoSuscriptor.Id }, nuevoSuscriptor);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al crear suscriptor: {Message}", ex.Message);
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Busca suscriptores por término de búsqueda
  /// </summary>
  /// <param name="termino">Término a buscar en nombre, alias o correo</param>
  /// <returns>Primer suscriptor encontrado</returns>
  [HttpGet("buscar")]
  public async Task<ActionResult<SuscriptorDto>> BuscarSuscriptor([FromQuery] string termino)
  {
    try
    {
      if (string.IsNullOrWhiteSpace(termino))
      {
        return BadRequest("El término de búsqueda es requerido");
      }

      var resultado = await _suscriptorService.BuscarSuscriptorAsync(termino);

      if (resultado == null)
      {
        return NotFound($"No se encontró ningún suscriptor con el término '{termino}'");
      }

      return Ok(resultado);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al buscar suscriptor con término {Termino}", termino);
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Verifica si un correo electrónico ya existe
  /// </summary>
  /// <param name="correo">Correo electrónico a verificar</param>
  /// <returns>Información sobre la existencia del correo</returns>
  [HttpGet("verificar-correo")]
  public async Task<ActionResult<object>> VerificarCorreo([FromQuery] string correo)
  {
    try
    {
      if (string.IsNullOrWhiteSpace(correo))
      {
        return BadRequest("El correo es requerido");
      }

      if (!IsValidEmail(correo))
      {
        return BadRequest("El formato del correo electrónico no es válido");
      }

      var existe = await _suscriptorService.ExisteCorreoAsync(correo);

      return Ok(new
      {
        correo = correo,
        existe = existe,
        mensaje = existe ? "El correo ya está registrado" : "El correo está disponible"
      });
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al verificar correo {Correo}", correo);
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Actualiza un suscriptor existente
  /// </summary>
  /// <param name="id">ID del suscriptor a actualizar</param>
  /// <param name="suscriptor">Datos a actualizar</param>
  /// <returns>Suscriptor actualizado</returns>
  [HttpPut("{id:int}")]
  public async Task<ActionResult<SuscriptorDto>> ActualizarSuscriptor(int id, [FromBody] ActualizarSuscriptorDto suscriptor)
  {
    try
    {
      if (id <= 0)
      {
        return BadRequest("El ID debe ser mayor a 0");
      }

      // Validar correo si se está actualizando
      if (!string.IsNullOrWhiteSpace(suscriptor.Correo))
      {
        if (!IsValidEmail(suscriptor.Correo))
        {
          return BadRequest("El formato del correo electrónico no es válido");
        }
      }

      var resultado = await _suscriptorService.ActualizarSuscriptorAsync(id, suscriptor);

      if (resultado == null)
      {
        return NotFound($"Suscriptor con ID {id} no encontrado");
      }

      return Ok(resultado);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al actualizar suscriptor {Id}", id);
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Elimina un suscriptor
  /// </summary>
  /// <param name="id">ID del suscriptor a eliminar</param>
  /// <returns>Confirmación de eliminación</returns>
  [HttpDelete("{id:int}")]
  public async Task<ActionResult<object>> EliminarSuscriptor(int id)
  {
    try
    {
      if (id <= 0)
      {
        return BadRequest("El ID debe ser mayor a 0");
      }

      var eliminado = await _suscriptorService.EliminarSuscriptorAsync(id);

      if (!eliminado)
      {
        return NotFound($"Suscriptor con ID {id} no encontrado");
      }

      return Ok(new { mensaje = "Suscriptor eliminado exitosamente", id = id });
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al eliminar suscriptor {Id}", id);
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Endpoint temporal para diagnóstico
  /// </summary>
  [HttpPost("test-conexion")]
  public async Task<ActionResult> TestConexion([FromBody] CrearSuscriptorDto suscriptor)
  {
    try
    {
      _logger.LogInformation("=== INICIANDO TEST DE CONEXIÓN ===");
      _logger.LogInformation("Datos recibidos: {Datos}", System.Text.Json.JsonSerializer.Serialize(suscriptor));
      
      // Probar conexión básica
      var stats = await _suscriptorService.ObtenerEstadisticasAsync();
      _logger.LogInformation("Conexión exitosa - Total suscriptores: {Total}", stats.TotalSuscriptores);
      
      // Establecer valores por defecto para campos obligatorios si no se proporcionan
      if (suscriptor.CiudadId == null)
      {
        suscriptor.CiudadId = 121; // Valor por defecto
        _logger.LogInformation("CiudadId no proporcionado, usando valor por defecto: 121");
      }
      
      if (suscriptor.ColoniaId == null)
      {
        suscriptor.ColoniaId = 1; // Valor por defecto
        _logger.LogInformation("ColoniaId no proporcionado, usando valor por defecto: 1");
      }
      
      // Probar verificación de correo
      if (!string.IsNullOrWhiteSpace(suscriptor.Correo))
      {
        var existeCorreo = await _suscriptorService.ExisteCorreoAsync(suscriptor.Correo);
        _logger.LogInformation("Verificación de correo '{Correo}': {Existe}", suscriptor.Correo, existeCorreo);
        
        if (existeCorreo)
        {
          return Ok(new { mensaje = "Correo ya existe", correo = suscriptor.Correo });
        }
      }
      
      // Si llegamos aquí, intentar crear el suscriptor
      _logger.LogInformation("Intentando crear suscriptor...");
      var resultado = await _suscriptorService.CrearSuscriptorAsync(suscriptor);
      _logger.LogInformation("Suscriptor creado exitosamente con ID: {Id}", resultado.Id);
      
      return Ok(new { 
        mensaje = "Suscriptor creado exitosamente",
        suscriptor = resultado 
      });
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error en test de conexión: {Message}", ex.Message);
      _logger.LogError("Stack trace: {StackTrace}", ex.StackTrace);
      
      return Ok(new { 
        error = ex.Message,
        tipo = ex.GetType().Name,
        stackTrace = ex.StackTrace
      });
    }
  }

  /// <summary>
  /// Valida el formato de un correo electrónico
  /// </summary>
  private static bool IsValidEmail(string email)
  {
    try
    {
      var addr = new System.Net.Mail.MailAddress(email);
      return addr.Address == email;
    }
    catch
    {
      return false;
    }
  }
}
