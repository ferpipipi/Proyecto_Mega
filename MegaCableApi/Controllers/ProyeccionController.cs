using Microsoft.AspNetCore.Mvc;
using MegaCableApi.Models.DTOs;
using MegaCableApi.Services.Interfaces;

namespace MegaCableApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProyeccionController : ControllerBase
{
  private readonly IProyeccionService _proyeccionService;
  private readonly IProyeccionContratoService _proyeccionContratoService;
  private readonly ILogger<ProyeccionController> _logger;

  public ProyeccionController(
      IProyeccionService proyeccionService,
      IProyeccionContratoService proyeccionContratoService,
      ILogger<ProyeccionController> logger)
  {
    _proyeccionService = proyeccionService;
    _proyeccionContratoService = proyeccionContratoService;
    _logger = logger;
  }

  /// <summary>
  /// Obtiene las proyecciones de corte para un período específico
  /// </summary>
  /// <param name="fechaInicio">Fecha de inicio del período</param>
  /// <param name="fechaFin">Fecha de fin del período</param>
  /// <returns>Lista de proyecciones de corte</returns>
  [HttpGet("cortes")]
  public async Task<ActionResult<IEnumerable<ProyeccionCorteDto>>> GetProyeccionesCorte(
      [FromQuery] DateTime fechaInicio,
      [FromQuery] DateTime fechaFin)
  {
    try
    {
      var proyecciones = await _proyeccionService.GetProyeccionesCorteAsync(fechaInicio, fechaFin);
      return Ok(proyecciones);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener proyecciones de corte");
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Obtiene el resumen ejecutivo de proyecciones
  /// </summary>
  /// <param name="año">Año para el resumen</param>
  /// <param name="mes">Mes para el resumen (opcional)</param>
  /// <returns>Resumen ejecutivo</returns>
  [HttpGet("resumen-ejecutivo")]
  public async Task<ActionResult<ResumenEjecutivoDto>> GetResumenEjecutivo(
      [FromQuery] int año,
      [FromQuery] int? mes = null)
  {
    try
    {
      var resumen = await _proyeccionService.GetResumenEjecutivoAsync(año, mes);
      return Ok(resumen);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener resumen ejecutivo");
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Obtiene la proyección completa incluyendo todos los datos
  /// </summary>
  /// <param name="fechaInicio">Fecha de inicio</param>
  /// <param name="fechaFin">Fecha de fin</param>
  /// <returns>Proyección completa</returns>
  [HttpGet("completa")]
  public async Task<ActionResult<ProyeccionCompletaDto>> GetProyeccionCompleta(
      [FromQuery] DateTime fechaInicio,
      [FromQuery] DateTime fechaFin)
  {
    try
    {
      var proyeccionCompleta = await _proyeccionService.GetProyeccionCompletaAsync(fechaInicio, fechaFin);
      return Ok(proyeccionCompleta);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener proyección completa");
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Genera nuevas proyecciones basadas en parámetros específicos
  /// </summary>
  /// <param name="parametros">Parámetros para generar la proyección</param>
  /// <returns>Proyección generada</returns>
  [HttpPost("generar")]
  public async Task<ActionResult<ProyeccionCompletaDto>> GenerarProyeccion(
      [FromBody] ProyeccionCompletaDto parametros)
  {
    try
    {
      var proyeccionGenerada = await _proyeccionService.GenerarProyeccionAsync(parametros);
      return Ok(proyeccionGenerada);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al generar proyección");
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Genera proyección de cortes futuros para un contrato específico usando stored procedure
  /// </summary>
  /// <param name="numeroContrato">Número del contrato (ej: CTR-2025-001)</param>
  /// <param name="mesesFuturos">Número de meses a proyectar (por defecto 6)</param>
  /// <returns>Proyección detallada del contrato</returns>
  [HttpGet("contrato/{numeroContrato}")]
  public async Task<ActionResult<ProyeccionContratoDDto>> GetProyeccionContrato(
      string numeroContrato,
      [FromQuery] int mesesFuturos = 6)
  {
    try
    {
      if (string.IsNullOrWhiteSpace(numeroContrato))
      {
        return BadRequest("El número de contrato es requerido");
      }

      if (mesesFuturos < 1 || mesesFuturos > 24)
      {
        return BadRequest("Los meses futuros deben estar entre 1 y 24");
      }

      var proyeccion = await _proyeccionContratoService.GenerarProyeccionContratoAsync(numeroContrato, mesesFuturos);

      if (!proyeccion.Exitoso)
      {
        if (proyeccion.Mensaje.Contains("no encontrado"))
        {
          return NotFound(proyeccion.Mensaje);
        }
        return StatusCode(500, proyeccion.Mensaje);
      }

      return Ok(proyeccion);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener proyección del contrato {NumeroContrato}", numeroContrato);
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Valida si un contrato existe y está activo
  /// </summary>
  /// <param name="numeroContrato">Número del contrato a validar</param>
  /// <returns>Estado de validación del contrato</returns>
  [HttpGet("contrato/{numeroContrato}/validar")]
  public async Task<ActionResult<object>> ValidarContrato(string numeroContrato)
  {
    try
    {
      if (string.IsNullOrWhiteSpace(numeroContrato))
      {
        return BadRequest("El número de contrato es requerido");
      }

      var esValido = await _proyeccionContratoService.ValidarContratoAsync(numeroContrato);

      return Ok(new
      {
        numeroContrato,
        esValido,
        mensaje = esValido ? "✅ Contrato válido y activo" : "❌ Contrato no encontrado o inactivo",
        fechaValidacion = DateTime.Now
      });
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al validar contrato {NumeroContrato}", numeroContrato);
      return StatusCode(500, "Error interno del servidor");
    }
  }

  /// <summary>
  /// Genera proyecciones para múltiples contratos
  /// </summary>
  /// <param name="solicitudes">Lista de contratos con sus parámetros de proyección</param>
  /// <returns>Lista de proyecciones generadas</returns>
  [HttpPost("contratos/multiple")]
  public async Task<ActionResult<List<ProyeccionContratoDDto>>> GenerarProyeccionesMultiples(
      [FromBody] List<SolicitudProyeccionContratoDto> solicitudes)
  {
    try
    {
      if (solicitudes == null || !solicitudes.Any())
      {
        return BadRequest("Debe proporcionar al menos una solicitud de proyección");
      }

      if (solicitudes.Count > 50)
      {
        return BadRequest("No se pueden procesar más de 50 contratos a la vez");
      }

      // Validar solicitudes
      foreach (var solicitud in solicitudes)
      {
        if (string.IsNullOrWhiteSpace(solicitud.NumeroContrato))
        {
          return BadRequest($"Número de contrato requerido en todas las solicitudes");
        }

        if (solicitud.MesesFuturos < 1 || solicitud.MesesFuturos > 24)
        {
          return BadRequest($"Meses futuros para contrato {solicitud.NumeroContrato} debe estar entre 1 y 24");
        }
      }

      var proyecciones = await _proyeccionContratoService.GenerarProyeccionesMultiplesAsync(solicitudes);

      return Ok(proyecciones);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al generar proyecciones múltiples");
      return StatusCode(500, "Error interno del servidor");
    }
  }
}
