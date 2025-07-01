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
      var contadorMeses = 0;
      while (await reader.ReadAsync())
      {
        contadorMeses++;
        _logger.LogInformation("Procesando mes {Contador}: {Mes}", contadorMeses, reader["MES"]);

        try
        {
          var proyeccionMensual = new ProyeccionMensualDto
          {
            MesNombre = reader["MES"].ToString() ?? "",
            SubtotalServicios = ParseDecimalFromCurrency(reader["PRECIO BASE CONTRATO"].ToString()),
            DescuentosPromociones = ParseDecimalFromCurrency(reader["DESCUENTOS PROMOCIONES"].ToString()),
            Impuestos = 0, // Los impuestos están incluidos en el precio base
            TotalProyectado = ParseDecimalFromCurrency(reader["TOTAL A PAGAR"].ToString()),
            PromocionesActivas = reader["PROMOCIONES ACTIVAS"].ToString() ?? "",
            PromocionesVencen = reader["PROMOCIONES QUE VENCEN"].ToString() ?? "",
            Notas = reader["NOTAS"].ToString() ?? ""
          };

          // Calcular fecha de proyección basada en el nombre del mes
          proyeccionMensual.FechaProyeccion = ParsearFechaMes(proyeccionMensual.MesNombre);

          proyeccion.ProyeccionesMensuales.Add(proyeccionMensual);
          _logger.LogInformation("Mes {Mes} procesado exitosamente", proyeccionMensual.MesNombre);
        }
        catch (Exception ex)
        {
          _logger.LogError(ex, "Error al procesar mes {Contador}", contadorMeses);
          throw;
        }
      }

      _logger.LogInformation("Total de meses procesados: {Total}", contadorMeses);

      // Leer resumen ejecutivo (segundo ResultSet)
      _logger.LogInformation("Intentando leer segundo ResultSet (resumen ejecutivo)");
      if (await reader.NextResultAsync())
      {
        _logger.LogInformation("Segundo ResultSet disponible");
        if (await reader.ReadAsync())
        {
          _logger.LogInformation("Leyendo datos del resumen ejecutivo");
          try
          {
            proyeccion.ResumenEjecutivo = new ResumenEjecutivoContratoDto
            {
              MesesProyectados = Convert.ToInt32(reader["meses_proyectados"]),
              PagoMinimo = ParseDecimalFromCurrency(reader["pago_minimo_proyectado"].ToString()),
              PagoMaximo = ParseDecimalFromCurrency(reader["pago_maximo_proyectado"].ToString()),
              PagoPromedio = ParseDecimalFromCurrency(reader["pago_promedio"].ToString()),
              TotalPeriodo = ParseDecimalFromCurrency(reader["total_periodo_completo"].ToString()),
              AhorrosTotales = ParseDecimalFromCurrency(reader["ahorros_totales_promociones"].ToString())
            };
            _logger.LogInformation("Resumen ejecutivo procesado exitosamente");
          }
          catch (Exception ex)
          {
            _logger.LogError(ex, "Error al procesar resumen ejecutivo");
            throw;
          }
        }
        else
        {
          _logger.LogWarning("No se pudieron leer datos del segundo ResultSet");
        }
      }
      else
      {
        _logger.LogWarning("No se encontró segundo ResultSet");
      }

      // Opcional: Leer tercer ResultSet (información del contrato) si existe
      try
      {
        if (await reader.NextResultAsync())
        {
          _logger.LogInformation("Tercer ResultSet disponible (información del contrato)");
          // Aquí podríamos leer información adicional del contrato si fuera necesario
        }
      }
      catch (Exception ex)
      {
        _logger.LogWarning(ex, "No se pudo leer tercer ResultSet opcional");
        // No es crítico, continúa
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

  /// <summary>
  /// Parsea valores monetarios que vienen como "$123.45" a decimal
  /// </summary>
  private decimal ParseDecimalFromCurrency(string? currencyValue)
  {
    try
    {
      if (string.IsNullOrEmpty(currencyValue))
        return 0;

      // Remover el símbolo $ y espacios
      var cleanValue = currencyValue.Replace("$", "").Trim();

      if (decimal.TryParse(cleanValue, out decimal result))
        return result;

      return 0;
    }
    catch
    {
      return 0;
    }
  }
}
