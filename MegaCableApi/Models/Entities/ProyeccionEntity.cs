using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MegaCableApi.Models.Entities;

/// <summary>
/// Entidad para representar una proyección en la base de datos
/// </summary>
[Table("Proyecciones")]
public class ProyeccionEntity
{
  /// <summary>
  /// Identificador único de la proyección
  /// </summary>
  [Key]
  [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
  public int Id { get; set; }

  /// <summary>
  /// Fecha de la proyección
  /// </summary>
  [Required]
  public DateTime Fecha { get; set; }

  /// <summary>
  /// Región geográfica
  /// </summary>
  [Required]
  [MaxLength(100)]
  public string Region { get; set; } = string.Empty;

  /// <summary>
  /// Número total de clientes proyectados para corte
  /// </summary>
  [Required]
  public int ClientesProyectados { get; set; }

  /// <summary>
  /// Monto total proyectado en cortes
  /// </summary>
  [Required]
  [Column(TypeName = "decimal(18,2)")]
  public decimal MontoProyectado { get; set; }

  /// <summary>
  /// Porcentaje de efectividad esperado
  /// </summary>
  [Required]
  public double PorcentajeEfectividad { get; set; }

  /// <summary>
  /// Tipo de corte (Residencial, Comercial, Corporativo)
  /// </summary>
  [Required]
  [MaxLength(50)]
  public string TipoCorte { get; set; } = string.Empty;

  /// <summary>
  /// Estado de la proyección (Pendiente, En Proceso, Completado)
  /// </summary>
  [Required]
  [MaxLength(50)]
  public string Estado { get; set; } = string.Empty;

  /// <summary>
  /// Observaciones adicionales
  /// </summary>
  [MaxLength(1000)]
  public string? Observaciones { get; set; }

  /// <summary>
  /// Fecha de creación de la proyección
  /// </summary>
  [Required]
  public DateTime FechaCreacion { get; set; }

  /// <summary>
  /// Fecha de última actualización
  /// </summary>
  public DateTime? FechaActualizacion { get; set; }

  /// <summary>
  /// Usuario que creó la proyección
  /// </summary>
  [Required]
  [MaxLength(100)]
  public string UsuarioCreacion { get; set; } = string.Empty;

  /// <summary>
  /// Usuario que realizó la última actualización
  /// </summary>
  [MaxLength(100)]
  public string? UsuarioActualizacion { get; set; }

  /// <summary>
  /// Indica si el registro está activo
  /// </summary>
  [Required]
  public bool Activo { get; set; } = true;

  /// <summary>
  /// Versión para control de concurrencia optimista
  /// </summary>
  [Timestamp]
  public byte[]? Version { get; set; }
}

/// <summary>
/// Entidad para representar configuraciones de proyección
/// </summary>
[Table("ConfiguracionesProyeccion")]
public class ConfiguracionProyeccionEntity
{
  /// <summary>
  /// Identificador único de la configuración
  /// </summary>
  [Key]
  [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
  public int Id { get; set; }

  /// <summary>
  /// Nombre de la configuración
  /// </summary>
  [Required]
  [MaxLength(200)]
  public string Nombre { get; set; } = string.Empty;

  /// <summary>
  /// Descripción de la configuración
  /// </summary>
  [MaxLength(500)]
  public string? Descripcion { get; set; }

  /// <summary>
  /// Algoritmo utilizado
  /// </summary>
  [Required]
  [MaxLength(100)]
  public string AlgoritmoUtilizado { get; set; } = string.Empty;

  /// <summary>
  /// Umbral de efectividad
  /// </summary>
  [Required]
  public double UmbralEfectividad { get; set; }

  /// <summary>
  /// Días de adelanto para la proyección
  /// </summary>
  [Required]
  public int DiasAdelanto { get; set; }

  /// <summary>
  /// Indica si incluye días festivos
  /// </summary>
  [Required]
  public bool IncluirFestivos { get; set; }

  /// <summary>
  /// Regiones incluidas (separadas por comas)
  /// </summary>
  [Required]
  [MaxLength(500)]
  public string RegionesIncluidas { get; set; } = string.Empty;

  /// <summary>
  /// Tipos de corte incluidos (separados por comas)
  /// </summary>
  [Required]
  [MaxLength(200)]
  public string TiposCorteIncluidos { get; set; } = string.Empty;

  /// <summary>
  /// Parámetros adicionales en formato JSON
  /// </summary>
  [Column(TypeName = "nvarchar(max)")]
  public string? ParametrosAdicionales { get; set; }

  /// <summary>
  /// Fecha de creación
  /// </summary>
  [Required]
  public DateTime FechaCreacion { get; set; }

  /// <summary>
  /// Usuario que creó la configuración
  /// </summary>
  [Required]
  [MaxLength(100)]
  public string UsuarioCreacion { get; set; } = string.Empty;

  /// <summary>
  /// Indica si la configuración está activa
  /// </summary>
  [Required]
  public bool Activa { get; set; } = true;

  /// <summary>
  /// Indica si es la configuración por defecto
  /// </summary>
  [Required]
  public bool EsDefault { get; set; } = false;
}
