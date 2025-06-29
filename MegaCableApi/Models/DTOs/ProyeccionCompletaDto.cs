namespace MegaCableApi.Models.DTOs;

/// <summary>
/// DTO para representar una proyección completa con todos los datos detallados
/// </summary>
public class ProyeccionCompletaDto
{
  /// <summary>
  /// Información general de la proyección
  /// </summary>
  public InformacionGeneralDto InformacionGeneral { get; set; } = new();

  /// <summary>
  /// Lista de proyecciones de corte
  /// </summary>
  public List<ProyeccionCorteDto> ProyeccionesCorte { get; set; } = new();

  /// <summary>
  /// Resumen ejecutivo asociado
  /// </summary>
  public ResumenEjecutivoDto ResumenEjecutivo { get; set; } = new();

  /// <summary>
  /// Métricas de rendimiento
  /// </summary>
  public MetricasRendimientoDto MetricasRendimiento { get; set; } = new();

  /// <summary>
  /// Parámetros de configuración utilizados
  /// </summary>
  public ParametrosConfiguracionDto ParametrosConfiguracion { get; set; } = new();

  /// <summary>
  /// Alertas y recomendaciones
  /// </summary>
  public List<AlertaDto> Alertas { get; set; } = new();

  /// <summary>
  /// Histórico de cambios
  /// </summary>
  public List<HistoricoCambioDto> HistoricoCambios { get; set; } = new();
}

/// <summary>
/// DTO para información general de la proyección
/// </summary>
public class InformacionGeneralDto
{
  public int ProyeccionId { get; set; }
  public string Nombre { get; set; } = string.Empty;
  public string Descripcion { get; set; } = string.Empty;
  public DateTime FechaInicio { get; set; }
  public DateTime FechaFin { get; set; }
  public string Estado { get; set; } = string.Empty;
  public string UsuarioCreador { get; set; } = string.Empty;
  public DateTime FechaCreacion { get; set; }
  public DateTime? FechaUltimaActualizacion { get; set; }
}

/// <summary>
/// DTO para métricas de rendimiento
/// </summary>
public class MetricasRendimientoDto
{
  public double TasaExito { get; set; }
  public double TiempoPromedioEjecucion { get; set; }
  public int TotalProcesados { get; set; }
  public int TotalExitosos { get; set; }
  public int TotalFallidos { get; set; }
  public double PorcentajeCompletitud { get; set; }
  public decimal CostoPromedio { get; set; }
  public decimal RetornoInversion { get; set; }
}

/// <summary>
/// DTO para parámetros de configuración
/// </summary>
public class ParametrosConfiguracionDto
{
  public string AlgoritmoUtilizado { get; set; } = string.Empty;
  public double UmbralEfectividad { get; set; }
  public int DiasAdelanto { get; set; }
  public bool IncluirFestivos { get; set; }
  public List<string> RegionesIncluidas { get; set; } = new();
  public List<string> TiposCorteIncluidos { get; set; } = new();
  public Dictionary<string, object> ParametrosAdicionales { get; set; } = new();
}

/// <summary>
/// DTO para alertas del sistema
/// </summary>
public class AlertaDto
{
  public int Id { get; set; }
  public string Tipo { get; set; } = string.Empty; // Warning, Error, Info
  public string Mensaje { get; set; } = string.Empty;
  public string Detalle { get; set; } = string.Empty;
  public DateTime FechaGeneracion { get; set; }
  public bool Activa { get; set; }
  public string? AccionRecomendada { get; set; }
}

/// <summary>
/// DTO para histórico de cambios
/// </summary>
public class HistoricoCambioDto
{
  public int Id { get; set; }
  public DateTime FechaCambio { get; set; }
  public string Usuario { get; set; } = string.Empty;
  public string TipoCambio { get; set; } = string.Empty;
  public string DescripcionCambio { get; set; } = string.Empty;
  public string? ValorAnterior { get; set; }
  public string? ValorNuevo { get; set; }
}
