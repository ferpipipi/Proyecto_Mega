namespace MegaCableApi.Models.DTOs;

/// <summary>
/// DTO para representar datos de proyección de corte
/// </summary>
public class ProyeccionCorteDto
{
  /// <summary>
  /// Identificador único de la proyección
  /// </summary>
  public int Id { get; set; }

  /// <summary>
  /// Fecha de la proyección
  /// </summary>
  public DateTime Fecha { get; set; }

  /// <summary>
  /// Región geográfica
  /// </summary>
  public string Region { get; set; } = string.Empty;

  /// <summary>
  /// Número total de clientes proyectados para corte
  /// </summary>
  public int ClientesProyectados { get; set; }

  /// <summary>
  /// Monto total proyectado en cortes
  /// </summary>
  public decimal MontoProyectado { get; set; }

  /// <summary>
  /// Porcentaje de efectividad esperado
  /// </summary>
  public double PorcentajeEfectividad { get; set; }

  /// <summary>
  /// Tipo de corte (Residencial, Comercial, Corporativo)
  /// </summary>
  public string TipoCorte { get; set; } = string.Empty;

  /// <summary>
  /// Estado de la proyección (Pendiente, En Proceso, Completado)
  /// </summary>
  public string Estado { get; set; } = string.Empty;

  /// <summary>
  /// Observaciones adicionales
  /// </summary>
  public string? Observaciones { get; set; }

  /// <summary>
  /// Fecha de creación de la proyección
  /// </summary>
  public DateTime FechaCreacion { get; set; }
}
