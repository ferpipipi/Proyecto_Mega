namespace MegaCableApi.Models.DTOs;

/// <summary>
/// DTO para representar el resumen ejecutivo de proyecciones
/// </summary>
public class ResumenEjecutivoDto
{
  /// <summary>
  /// Período del resumen
  /// </summary>
  public string Periodo { get; set; } = string.Empty;

  /// <summary>
  /// Año del resumen
  /// </summary>
  public int Año { get; set; }

  /// <summary>
  /// Mes del resumen (opcional)
  /// </summary>
  public int? Mes { get; set; }

  /// <summary>
  /// Total de clientes proyectados
  /// </summary>
  public int TotalClientesProyectados { get; set; }

  /// <summary>
  /// Monto total proyectado
  /// </summary>
  public decimal MontoTotalProyectado { get; set; }

  /// <summary>
  /// Promedio de efectividad
  /// </summary>
  public double PromedioEfectividad { get; set; }

  /// <summary>
  /// Número total de proyecciones
  /// </summary>
  public int TotalProyecciones { get; set; }

  /// <summary>
  /// Distribución por región
  /// </summary>
  public List<RegionResumenDto> DistribucionPorRegion { get; set; } = new();

  /// <summary>
  /// Distribución por tipo de corte
  /// </summary>
  public List<TipoCorteResumenDto> DistribucionPorTipo { get; set; } = new();

  /// <summary>
  /// Tendencia mensual (si aplica)
  /// </summary>
  public List<TendenciaMensualDto> TendenciaMensual { get; set; } = new();

  /// <summary>
  /// Fecha de generación del resumen
  /// </summary>
  public DateTime FechaGeneracion { get; set; }
}

/// <summary>
/// DTO para resumen por región
/// </summary>
public class RegionResumenDto
{
  public string Region { get; set; } = string.Empty;
  public int Clientes { get; set; }
  public decimal Monto { get; set; }
  public double Porcentaje { get; set; }
}

/// <summary>
/// DTO para resumen por tipo de corte
/// </summary>
public class TipoCorteResumenDto
{
  public string TipoCorte { get; set; } = string.Empty;
  public int Clientes { get; set; }
  public decimal Monto { get; set; }
  public double Porcentaje { get; set; }
}

/// <summary>
/// DTO para tendencia mensual
/// </summary>
public class TendenciaMensualDto
{
  public int Mes { get; set; }
  public string NombreMes { get; set; } = string.Empty;
  public int Clientes { get; set; }
  public decimal Monto { get; set; }
  public double Efectividad { get; set; }
}
