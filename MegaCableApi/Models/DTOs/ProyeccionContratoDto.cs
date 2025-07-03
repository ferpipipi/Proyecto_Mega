namespace MegaCableApi.Models.DTOs;

/// <summary>
/// DTO para la proyección de cortes futuros de un contrato
/// </summary>
public class ProyeccionContratoDDto
{
  /// <summary>
  /// Información del contrato
  /// </summary>
  public string NumeroContrato { get; set; } = string.Empty;

  /// <summary>
  /// Número de meses proyectados
  /// </summary>
  public int MesesFuturos { get; set; }

  /// <summary>
  /// Proyecciones mensuales
  /// </summary>
  public List<ProyeccionMensualDto> ProyeccionesMensuales { get; set; } = new();

  /// <summary>
  /// Resumen ejecutivo de la proyección
  /// </summary>
  public ResumenEjecutivoContratoDto ResumenEjecutivo { get; set; } = new();

  /// <summary>
  /// Fecha de generación de la proyección
  /// </summary>
  public DateTime FechaGeneracion { get; set; }

  /// <summary>
  /// Estado de la consulta
  /// </summary>
  public bool Exitoso { get; set; }

  /// <summary>
  /// Mensaje informativo
  /// </summary>
  public string Mensaje { get; set; } = string.Empty;
}

/// <summary>
/// DTO para cada mes de la proyección
/// </summary>
public class ProyeccionMensualDto
{
  /// <summary>
  /// Fecha de la proyección (primer día del mes)
  /// </summary>
  public DateTime FechaProyeccion { get; set; }

  /// <summary>
  /// Nombre del mes y año (ej: "Enero 2025")
  /// </summary>
  public string MesNombre { get; set; } = string.Empty;

  /// <summary>
  /// Subtotal de servicios activos
  /// </summary>
  public decimal SubtotalServicios { get; set; }

  /// <summary>
  /// Total de descuentos por promociones
  /// </summary>
  public decimal DescuentosPromociones { get; set; }

  /// <summary>
  /// Impuestos calculados
  /// </summary>
  public decimal Impuestos { get; set; }

  /// <summary>
  /// Total proyectado a pagar
  /// </summary>
  public decimal TotalProyectado { get; set; }

  /// <summary>
  /// Promociones activas en ese mes
  /// </summary>
  public string PromocionesActivas { get; set; } = string.Empty;

  /// <summary>
  /// Promociones que vencen en ese mes
  /// </summary>
  public string PromocionesVencen { get; set; } = string.Empty;

  /// <summary>
  /// Notas explicativas del mes
  /// </summary>
  public string Notas { get; set; } = string.Empty;

  /// <summary>
  /// Indica si hay alertas en este mes
  /// </summary>
  public bool TieneAlertas => !string.IsNullOrEmpty(PromocionesVencen);

  /// <summary>
  /// Porcentaje de descuento aplicado
  /// </summary>
  public decimal PorcentajeDescuento => SubtotalServicios > 0 ? (DescuentosPromociones / SubtotalServicios) * 100 : 0;
}

/// <summary>
/// DTO para el resumen ejecutivo del contrato
/// </summary>
public class ResumenEjecutivoContratoDto
{
  /// <summary>
  /// Número de meses proyectados
  /// </summary>
  public int MesesProyectados { get; set; }

  /// <summary>
  /// Pago mínimo en la proyección
  /// </summary>
  public decimal PagoMinimo { get; set; }

  /// <summary>
  /// Pago máximo en la proyección
  /// </summary>
  public decimal PagoMaximo { get; set; }

  /// <summary>
  /// Pago promedio mensual
  /// </summary>
  public decimal PagoPromedio { get; set; }

  /// <summary>
  /// Total acumulado del período proyectado
  /// </summary>
  public decimal TotalPeriodo { get; set; }

  /// <summary>
  /// Total de ahorros por promociones
  /// </summary>
  public decimal AhorrosTotales { get; set; }

  /// <summary>
  /// Variación entre el mes más caro y más barato
  /// </summary>
  public decimal VariacionMaxMin => PagoMaximo - PagoMinimo;

  /// <summary>
  /// Porcentaje de ahorro total
  /// </summary>
  public decimal PorcentajeAhorroTotal => (TotalPeriodo + AhorrosTotales) > 0 ?
      (AhorrosTotales / (TotalPeriodo + AhorrosTotales)) * 100 : 0;
}

/// <summary>
/// DTO para la solicitud de proyección
/// </summary>
public class SolicitudProyeccionContratoDto
{
  /// <summary>
  /// Número de contrato a proyectar
  /// </summary>
  public string NumeroContrato { get; set; } = string.Empty;

  /// <summary>
  /// Número de meses a proyectar (por defecto 6)
  /// </summary>
  public int MesesFuturos { get; set; } = 6;
}
