using MegaCableApi.Models.DTOs;

namespace MegaCableApi.Services.Interfaces;

/// <summary>
/// Interfaz para el servicio de proyecciones
/// </summary>
public interface IProyeccionService
{
  /// <summary>
  /// Obtiene las proyecciones de corte para un período específico
  /// </summary>
  /// <param name="fechaInicio">Fecha de inicio del período</param>
  /// <param name="fechaFin">Fecha de fin del período</param>
  /// <returns>Lista de proyecciones de corte</returns>
  Task<IEnumerable<ProyeccionCorteDto>> GetProyeccionesCorteAsync(DateTime fechaInicio, DateTime fechaFin);

  /// <summary>
  /// Obtiene el resumen ejecutivo de proyecciones
  /// </summary>
  /// <param name="año">Año para el resumen</param>
  /// <param name="mes">Mes para el resumen (opcional)</param>
  /// <returns>Resumen ejecutivo</returns>
  Task<ResumenEjecutivoDto> GetResumenEjecutivoAsync(int año, int? mes = null);

  /// <summary>
  /// Obtiene la proyección completa incluyendo todos los datos
  /// </summary>
  /// <param name="fechaInicio">Fecha de inicio</param>
  /// <param name="fechaFin">Fecha de fin</param>
  /// <returns>Proyección completa</returns>
  Task<ProyeccionCompletaDto> GetProyeccionCompletaAsync(DateTime fechaInicio, DateTime fechaFin);

  /// <summary>
  /// Genera nuevas proyecciones basadas en parámetros específicos
  /// </summary>
  /// <param name="parametros">Parámetros para generar la proyección</param>
  /// <returns>Proyección generada</returns>
  Task<ProyeccionCompletaDto> GenerarProyeccionAsync(ProyeccionCompletaDto parametros);

  /// <summary>
  /// Obtiene una proyección específica por ID
  /// </summary>
  /// <param name="id">ID de la proyección</param>
  /// <returns>Proyección encontrada</returns>
  Task<ProyeccionCorteDto?> GetProyeccionByIdAsync(int id);

  /// <summary>
  /// Actualiza una proyección existente
  /// </summary>
  /// <param name="id">ID de la proyección</param>
  /// <param name="proyeccion">Datos actualizados</param>
  /// <returns>Proyección actualizada</returns>
  Task<ProyeccionCorteDto?> UpdateProyeccionAsync(int id, ProyeccionCorteDto proyeccion);

  /// <summary>
  /// Elimina una proyección
  /// </summary>
  /// <param name="id">ID de la proyección</param>
  /// <returns>True si se eliminó correctamente</returns>
  Task<bool> DeleteProyeccionAsync(int id);

  /// <summary>
  /// Valida los parámetros de una proyección
  /// </summary>
  /// <param name="parametros">Parámetros a validar</param>
  /// <returns>Lista de errores de validación</returns>
  Task<IEnumerable<string>> ValidarParametrosAsync(ParametrosConfiguracionDto parametros);
}
