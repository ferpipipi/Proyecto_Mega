using Microsoft.Data.SqlClient;
using MegaCableApi.Models.DTOs;
using MegaCableApi.Services.Interfaces;
using MegaCableApi.Configuration;
using Microsoft.Extensions.Options;
using System.Data;

namespace MegaCableApi.Services.Implementation;

/// <summary>
/// Implementación del servicio de proyecciones de contratos
/// </summary>
public class ProyeccionContratoService : IProyeccionContratoService
{
  private readonly DatabaseConfig _dbConfig;
  private readonly ILogger<ProyeccionContratoService> _logger;

  public ProyeccionContratoService(
      IOptions<DatabaseConfig> dbConfig,
      ILogger<ProyeccionContratoService> logger)
  {
    _dbConfig = dbConfig.Value;
    _logger = logger;
  }

  public async Task<ProyeccionContratoDDto> GenerarProyeccionContratoAsync(string numeroContrato, int mesesFuturos = 6)
  {
    _logger.LogInformation("Generando proyección para contrato {NumeroContrato} por {MesesFuturos} meses",
        numeroContrato, mesesFuturos);

    var proyeccion = new ProyeccionContratoDDto
    {
      NumeroContrato = numeroContrato,
      MesesFuturos = mesesFuturos,
      FechaGeneracion = DateTime.Now
    };

    try
    {
      using var connection = new SqlConnection(_dbConfig.ConnectionString);
      await connection.OpenAsync();

      // Ejecutar el stored procedure
      using var command = new SqlCommand("sp_proyeccion_cortes_futuros", connection)
      {
        CommandType = CommandType.StoredProcedure,
        CommandTimeout = _dbConfig.CommandTimeout
      };

      command.Parameters.AddWithValue("@numero_contrato", numeroContrato);
      command.Parameters.AddWithValue("@meses_futuros", mesesFuturos);

      using var reader = await command.ExecuteReaderAsync();

      // Leer proyecciones mensuales (primer ResultSet)
      while (await reader.ReadAsync())
      {
        var proyeccionMensual = new ProyeccionMensualDto
        {
          MesNombre = reader["MES"].ToString() ?? "",
          SubtotalServicios = Convert.ToDecimal(reader["SERVICIOS"]),
          DescuentosPromociones = Convert.ToDecimal(reader["DESCUENTOS"]),
          Impuestos = Convert.ToDecimal(reader["IMPUESTOS"]),
          TotalProyectado = Convert.ToDecimal(reader["TOTAL A PAGAR"]),
          PromocionesActivas = reader["PROMOCIONES ACTIVAS"].ToString() ?? "",
          PromocionesVencen = reader["PROMOCIONES QUE VENCEN"].ToString() ?? "",
          Notas = reader["NOTAS"].ToString() ?? ""
        };

        // Calcular fecha de proyección basada en el nombre del mes
        proyeccionMensual.FechaProyeccion = ParsearFechaMes(proyeccionMensual.MesNombre);

        proyeccion.ProyeccionesMensuales.Add(proyeccionMensual);
      }

      // Leer resumen ejecutivo (segundo ResultSet)
      if (await reader.NextResultAsync() && await reader.ReadAsync())
      {
        proyeccion.ResumenEjecutivo = new ResumenEjecutivoContratoDto
        {
          MesesProyectados = Convert.ToInt32(reader["meses_proyectados"]),
          PagoMinimo = Convert.ToDecimal(reader["pago_minimo"]),
          PagoMaximo = Convert.ToDecimal(reader["pago_maximo"]),
          PagoPromedio = Convert.ToDecimal(reader["pago_promedio"]),
          TotalPeriodo = Convert.ToDecimal(reader["total_6_meses"]),
          AhorrosTotales = Convert.ToDecimal(reader["ahorros_totales"])
        };
      }

      proyeccion.Exitoso = true;
      proyeccion.Mensaje = $"✅ Proyección generada exitosamente para {proyeccion.ProyeccionesMensuales.Count} meses";

      _logger.LogInformation("Proyección generada exitosamente para contrato {NumeroContrato}", numeroContrato);
    }
    catch (SqlException sqlEx)
    {
      _logger.LogError(sqlEx, "Error de base de datos al generar proyección para contrato {NumeroContrato}", numeroContrato);

      proyeccion.Exitoso = false;
      proyeccion.Mensaje = sqlEx.Message.Contains("ERROR: Contrato no encontrado")
          ? $"❌ Contrato no encontrado: {numeroContrato}"
          : "❌ Error de base de datos al generar la proyección";
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error general al generar proyección para contrato {NumeroContrato}", numeroContrato);

      proyeccion.Exitoso = false;
      proyeccion.Mensaje = "❌ Error interno del servidor";
    }

    return proyeccion;
  }

  public async Task<bool> ValidarContratoAsync(string numeroContrato)
  {
    try
    {
      using var connection = new SqlConnection(_dbConfig.ConnectionString);
      await connection.OpenAsync();

      using var command = new SqlCommand(
          "SELECT COUNT(1) FROM contratos WHERE numero_contrato = @numero_contrato AND estado = 'activo'",
          connection);

      command.Parameters.AddWithValue("@numero_contrato", numeroContrato);

      var result = await command.ExecuteScalarAsync();
      return Convert.ToInt32(result) > 0;
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al validar contrato {NumeroContrato}", numeroContrato);
      return false;
    }
  }

  public async Task<List<ProyeccionContratoDDto>> GenerarProyeccionesMultiplesAsync(List<SolicitudProyeccionContratoDto> solicitudes)
  {
    _logger.LogInformation("Generando {Count} proyecciones múltiples", solicitudes.Count);

    var proyecciones = new List<ProyeccionContratoDDto>();

    foreach (var solicitud in solicitudes)
    {
      var proyeccion = await GenerarProyeccionContratoAsync(solicitud.NumeroContrato, solicitud.MesesFuturos);
      proyecciones.Add(proyeccion);
    }

    return proyecciones;
  }

  /// <summary>
  /// Parsea el nombre del mes (ej: "Enero 2025") a una fecha
  /// </summary>
  private DateTime ParsearFechaMes(string mesNombre)
  {
    try
    {
      var partes = mesNombre.Split(' ');
      if (partes.Length != 2) return DateTime.Now;

      var nombreMes = partes[0];
      var año = int.Parse(partes[1]);

      var meses = new Dictionary<string, int>
            {
                {"Enero", 1}, {"Febrero", 2}, {"Marzo", 3}, {"Abril", 4},
                {"Mayo", 5}, {"Junio", 6}, {"Julio", 7}, {"Agosto", 8},
                {"Septiembre", 9}, {"Octubre", 10}, {"Noviembre", 11}, {"Diciembre", 12}
            };

      if (meses.TryGetValue(nombreMes, out int mes))
      {
        return new DateTime(año, mes, 1);
      }

      return DateTime.Now;
    }
    catch
    {
      return DateTime.Now;
    }
  }
}
