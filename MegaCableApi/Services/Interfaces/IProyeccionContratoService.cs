using MegaCableApi.Models.DTOs;

namespace MegaCableApi.Services.Interfaces;

/// <summary>
/// Interfaz para el servicio de proyecciones de contratos
/// </summary>
public interface IProyeccionContratoService
{
  /// <summary>
  /// Genera proyección de cortes futuros para un contrato específico
  /// </summary>
  /// <param name="numeroContrato">Número del contrato</param>
  /// <param name="mesesFuturos">Número de meses a proyectar</param>
  /// <returns>Proyección completa del contrato</returns>
  Task<ProyeccionContratoDDto> GenerarProyeccionContratoAsync(string numeroContrato, int mesesFuturos = 6);

  /// <summary>
  /// Valida si un contrato existe y está activo
  /// </summary>
  /// <param name="numeroContrato">Número del contrato</param>
  /// <returns>True si el contrato es válido</returns>
  Task<bool> ValidarContratoAsync(string numeroContrato);

  /// <summary>
  /// Obtiene múltiples proyecciones de contratos
  /// </summary>
  /// <param name="solicitudes">Lista de solicitudes de proyección</param>
  /// <returns>Lista de proyecciones</returns>
  Task<List<ProyeccionContratoDDto>> GenerarProyeccionesMultiplesAsync(List<SolicitudProyeccionContratoDto> solicitudes);
}
