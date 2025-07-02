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
  /// Obtiene una lista paginada de suscriptores con filtros opcionales
  /// </summary>
  /// <param name="filtros">Filtros de búsqueda y paginación</param>
  /// <returns>Lista paginada de suscriptores</returns>
  [HttpGet]
  public async Task<ActionResult<RespuestaPaginadaSuscriptoresDto>> ObtenerSuscriptores(
    [FromQuery] string? nombre = null,
    [FromQuery] string? correo = null,
    [FromQuery] string? celular = null,
    [FromQuery] int? ciudadId = null,
    [FromQuery] int? coloniaId = null,
    [FromQuery] string? estadosAbreviatura = null,
    [FromQuery] string? tipoSuscriptorCodigo = null,
    [FromQuery] int pagina = 1,
    [FromQuery] int tamanoPagina = 10)
  {
    try
    {
      // Construir el DTO manualmente para evitar problemas de model binding
      var filtros = new FiltrosSuscriptorDto
      {
        Nombre = nombre,
        Correo = correo,
        Celular = celular,
        CiudadId = ciudadId,
        ColoniaId = coloniaId,
        EstadosAbreviatura = estadosAbreviatura,
        TipoSuscriptorCodigo = tipoSuscriptorCodigo,
        Pagina = pagina,
        TamanoPagina = tamanoPagina
      };

      // Logging para debuggear filtros
      _logger.LogInformation("=== FILTROS RECIBIDOS (MANUAL) ===");
      _logger.LogInformation("Nombre: {Nombre}", filtros.Nombre ?? "null");
      _logger.LogInformation("Correo: {Correo}", filtros.Correo ?? "null");
      _logger.LogInformation("EstadosAbreviatura: {Estado}", filtros.EstadosAbreviatura ?? "null");
      _logger.LogInformation("EstadosAbreviatura Length: {Length}", filtros.EstadosAbreviatura?.Length ?? 0);
      _logger.LogInformation("CiudadId: {CiudadId}", filtros.CiudadId?.ToString() ?? "null");
      _logger.LogInformation("ColoniaId: {ColoniaId}", filtros.ColoniaId?.ToString() ?? "null");
      _logger.LogInformation("TipoSuscriptorCodigo: {Tipo}", filtros.TipoSuscriptorCodigo ?? "null");
      _logger.LogInformation("Pagina: {Pagina}", filtros.Pagina);
      _logger.LogInformation("TamanoPagina: {TamanoPagina}", filtros.TamanoPagina);
      _logger.LogInformation("========================");

      if (filtros.TamanoPagina > 100)
      {
        return BadRequest("El tamaño de página no puede ser mayor a 100");
      }

      if (filtros.Pagina < 1)
      {
        return BadRequest("La página debe ser mayor a 0");
      }

      var resultado = await _suscriptorService.ObtenerSuscriptoresAsync(filtros);

      // TEMPORAL: Agregar info de debug en la respuesta
      var respuestaConDebug = new
      {
        resultado.Suscriptores,
        resultado.TotalRegistros,
        resultado.PaginaActual,
        resultado.TotalPaginas,
        resultado.TamanoPagina,
        DEBUG = new
        {
          EstadosAbreviaturaRecibido = estadosAbreviatura ?? "NULL",
          EstadosAbreviaturaLength = estadosAbreviatura?.Length ?? 0,
          NombreRecibido = nombre ?? "NULL"
        }
      };

      return Ok(respuestaConDebug);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener suscriptores");
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Obtiene un suscriptor específico por su ID
  /// </summary>
  /// <param name="id">ID del suscriptor</param>
  /// <returns>Datos del suscriptor</returns>
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
      _logger.LogInformation("Iniciando creación de suscriptor: {Nombre}, {Correo}", suscriptor.Nombre, suscriptor.Correo);

      if (string.IsNullOrWhiteSpace(suscriptor.Nombre))
      {
        _logger.LogWarning("Intento de crear suscriptor sin nombre");
        return BadRequest("El nombre es requerido");
      }

      if (suscriptor.Nombre.Length > 100)
      {
        _logger.LogWarning("Intento de crear suscriptor con nombre muy largo: {Longitud}", suscriptor.Nombre.Length);
        return BadRequest("El nombre no puede exceder 100 caracteres");
      }

      // Validar correo (ahora obligatorio)
      if (string.IsNullOrWhiteSpace(suscriptor.Correo))
      {
        _logger.LogWarning("Intento de crear suscriptor sin correo");
        return BadRequest("El correo es requerido");
      }

      if (suscriptor.Correo.Length > 50)
      {
        _logger.LogWarning("Correo muy largo: {Longitud}", suscriptor.Correo.Length);
        return BadRequest("El correo no puede exceder 50 caracteres");
      }

      // Validar ciudad_id y colonia_id (obligatorios)
      if (suscriptor.CiudadId <= 0)
      {
        _logger.LogWarning("Ciudad ID inválido: {CiudadId}", suscriptor.CiudadId);
        return BadRequest("El ID de ciudad es requerido y debe ser mayor a 0");
      }

      if (suscriptor.ColoniaId <= 0)
      {
        _logger.LogWarning("Colonia ID inválido: {ColoniaId}", suscriptor.ColoniaId);
        return BadRequest("El ID de colonia es requerido y debe ser mayor a 0");
      }

      // Validar correo
      _logger.LogInformation("Validando correo: {Correo}", suscriptor.Correo);

      if (!IsValidEmail(suscriptor.Correo))
      {
        _logger.LogWarning("Formato de correo inválido: {Correo}", suscriptor.Correo);
        return BadRequest("El formato del correo electrónico no es válido");
      }

      // Verificar que el correo no exista
      _logger.LogInformation("Verificando si el correo ya existe");
      var existeCorreo = await _suscriptorService.ExisteCorreoAsync(suscriptor.Correo);
      if (existeCorreo)
      {
        _logger.LogWarning("Intento de crear suscriptor con correo duplicado: {Correo}", suscriptor.Correo);
        return Conflict("Ya existe un suscriptor con este correo electrónico");
      }

      _logger.LogInformation("Llamando al servicio para crear suscriptor");
      var nuevoSuscriptor = await _suscriptorService.CrearSuscriptorAsync(suscriptor);

      _logger.LogInformation("Suscriptor creado exitosamente con ID: {Id}", nuevoSuscriptor.Id);
      return CreatedAtAction(nameof(ObtenerSuscriptor), new { id = nuevoSuscriptor.Id }, nuevoSuscriptor);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al crear suscriptor: {Message}", ex.Message);
      return StatusCode(500, $"Error interno del servidor: {ex.Message}");
    }
  }

  /// <summary>
  /// Actualiza un suscriptor existente
  /// </summary>
  /// <param name="id">ID del suscriptor a actualizar</param>
  /// <param name="suscriptor">Datos actualizados del suscriptor</param>
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

      // Validaciones
      if (!string.IsNullOrWhiteSpace(suscriptor.Nombre) && suscriptor.Nombre.Length > 255)
      {
        return BadRequest("El nombre no puede exceder 255 caracteres");
      }

      if (!string.IsNullOrWhiteSpace(suscriptor.Correo))
      {
        if (!IsValidEmail(suscriptor.Correo))
        {
          return BadRequest("El formato del correo electrónico no es válido");
        }

        // Verificar que el correo no exista en otro suscriptor
        var existeCorreo = await _suscriptorService.ExisteCorreoAsync(suscriptor.Correo, id);
        if (existeCorreo)
        {
          return Conflict("Ya existe otro suscriptor con este correo electrónico");
        }
      }

      var suscriptorActualizado = await _suscriptorService.ActualizarSuscriptorAsync(id, suscriptor);

      if (suscriptorActualizado == null)
      {
        return NotFound($"Suscriptor con ID {id} no encontrado");
      }

      return Ok(suscriptorActualizado);
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
  /// <returns>Resultado de la operación</returns>
  [HttpDelete("{id:int}")]
  public async Task<ActionResult> EliminarSuscriptor(int id)
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

      return Ok(new { mensaje = "Suscriptor eliminado exitosamente", id });
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al eliminar suscriptor {Id}", id);
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Busca suscriptores por término general
  /// </summary>
  /// <param name="termino">Término de búsqueda</param>
  /// <returns>Lista de suscriptores que coinciden con el término</returns>
  [HttpGet("buscar")]
  public async Task<ActionResult<List<SuscriptorDto>>> BuscarSuscriptores([FromQuery] string termino)
  {
    try
    {
      if (string.IsNullOrWhiteSpace(termino))
      {
        return BadRequest("El término de búsqueda es requerido");
      }

      if (termino.Length < 2)
      {
        return BadRequest("El término de búsqueda debe tener al menos 2 caracteres");
      }

      var suscriptores = await _suscriptorService.BuscarSuscriptoresAsync(termino);
      return Ok(suscriptores);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al buscar suscriptores con término {Termino}", termino);
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Verifica si un correo electrónico ya existe
  /// </summary>
  /// <param name="correo">Correo electrónico a verificar</param>
  /// <param name="excluirId">ID a excluir de la verificación (opcional)</param>
  /// <returns>Resultado de la verificación</returns>
  [HttpGet("verificar-correo")]
  public async Task<ActionResult<object>> VerificarCorreo([FromQuery] string correo, [FromQuery] int? excluirId = null)
  {
    try
    {
      if (string.IsNullOrWhiteSpace(correo))
      {
        return BadRequest("El correo electrónico es requerido");
      }

      if (!IsValidEmail(correo))
      {
        return BadRequest("El formato del correo electrónico no es válido");
      }

      var existe = await _suscriptorService.ExisteCorreoAsync(correo, excluirId);

      return Ok(new
      {
        correo,
        existe,
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
  /// Obtiene estadísticas básicas de suscriptores
  /// </summary>
  /// <returns>Estadísticas de suscriptores</returns>
  [HttpGet("estadisticas")]
  public async Task<ActionResult<object>> ObtenerEstadisticas()
  {
    try
    {
      var filtros = new FiltrosSuscriptorDto { Pagina = 1, TamanoPagina = 1 };
      var resultado = await _suscriptorService.ObtenerSuscriptoresAsync(filtros);

      return Ok(new
      {
        totalSuscriptores = resultado.TotalRegistros,
        fechaConsulta = DateTime.Now
      });
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener estadísticas de suscriptores");
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Endpoint temporal para probar la conexión y diagnóstico
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

      return Ok(new
      {
        mensaje = "Suscriptor creado exitosamente",
        suscriptor = resultado
      });
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error en test de conexión: {Message}", ex.Message);
      _logger.LogError("Stack trace: {StackTrace}", ex.StackTrace);

      return Ok(new
      {
        error = ex.Message,
        tipo = ex.GetType().Name,
        stackTrace = ex.StackTrace
      });
    }
  }

  /// <summary>
  /// Endpoint básico de prueba para diagnosticar problemas
  /// </summary>
  [HttpGet("test-basico")]
  public ActionResult TestBasico()
  {
    try
    {
      _logger.LogInformation("=== TEST BÁSICO INICIADO ===");

      return Ok(new
      {
        mensaje = "Endpoint básico funcionando",
        timestamp = DateTime.Now,
        controladorActivo = true
      });
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error en test básico: {Message}", ex.Message);
      return Ok(new
      {
        error = ex.Message,
        tipo = ex.GetType().Name,
        timestamp = DateTime.Now
      });
    }
  }

  /// <summary>
  /// Método de debug para ver qué parámetros se están recibiendo
  /// </summary>
  [HttpGet("debug-filtros")]
  public ActionResult<object> DebugFiltros([FromQuery] FiltrosSuscriptorDto filtros)
  {
    return Ok(new
    {
      Recibido = new
      {
        Nombre = filtros.Nombre ?? "NULL",
        Correo = filtros.Correo ?? "NULL",
        Celular = filtros.Celular ?? "NULL",
        EstadosAbreviatura = filtros.EstadosAbreviatura ?? "NULL",
        EstadosAbreviaturaEsNull = filtros.EstadosAbreviatura == null,
        EstadosAbreviaturaEsVacio = string.IsNullOrWhiteSpace(filtros.EstadosAbreviatura),
        CiudadId = filtros.CiudadId?.ToString() ?? "NULL",
        ColoniaId = filtros.ColoniaId?.ToString() ?? "NULL",
        TipoSuscriptorCodigo = filtros.TipoSuscriptorCodigo ?? "NULL",
        Pagina = filtros.Pagina,
        TamanoPagina = filtros.TamanoPagina
      }
    });
  }

  /// <summary>
  /// Obtiene la lista de tipos de suscriptor válidos
  /// </summary>
  /// <returns>Lista de tipos de suscriptor válidos</returns>
  [HttpGet("tipos-validos")]
  public async Task<ActionResult<string[]>> ObtenerTiposSuscriptorValidos()
  {
    try
    {
      var tipos = await _suscriptorService.ObtenerTiposSuscriptorValidosAsync();
      return Ok(tipos);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener tipos de suscriptor válidos");
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Obtiene la lista detallada de tipos de suscriptor válidos
  /// </summary>
  /// <returns>Lista detallada de tipos de suscriptor</returns>
  [HttpGet("tipos-detallados")]
  public async Task<ActionResult<List<TipoSuscriptorDto>>> ObtenerTiposSuscriptorDetallados()
  {
    try
    {
      var tipos = await _suscriptorService.ObtenerTiposSuscriptorDetalladosAsync();
      return Ok(tipos);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener tipos de suscriptor detallados");
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// ENDPOINT TEMPORAL - Debug parámetros de filtro
  /// </summary>
  [HttpGet("debug")]
  public ActionResult<object> DebugParametros([FromQuery] FiltrosSuscriptorDto filtros)
  {
    return Ok(new
    {
      EstadosAbreviatura = filtros.EstadosAbreviatura ?? "NULL",
      EstadosAbreviaturaLength = filtros.EstadosAbreviatura?.Length ?? 0,
      Nombre = filtros.Nombre ?? "NULL",
      Correo = filtros.Correo ?? "NULL",
      Celular = filtros.Celular ?? "NULL",
      CiudadId = filtros.CiudadId?.ToString() ?? "NULL",
      ColoniaId = filtros.ColoniaId?.ToString() ?? "NULL",
      TipoSuscriptorCodigo = filtros.TipoSuscriptorCodigo ?? "NULL",
      Pagina = filtros.Pagina,
      TamanoPagina = filtros.TamanoPagina
    });
  }

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
