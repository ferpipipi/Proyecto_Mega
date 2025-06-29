using MegaCableApi.Models.DTOs;
using MegaCableApi.Services.Interfaces;

namespace MegaCableApi.Services.Implementation;

/// <summary>
/// Implementación simulada del servicio de proyecciones de contratos para pruebas
/// </summary>
public class ProyeccionContratoServiceMock : IProyeccionContratoService
{
    private readonly ILogger<ProyeccionContratoServiceMock> _logger;

    public ProyeccionContratoServiceMock(ILogger<ProyeccionContratoServiceMock> logger)
    {
        _logger = logger;
    }

    public async Task<ProyeccionContratoDDto> GenerarProyeccionContratoAsync(string numeroContrato, int mesesFuturos = 6)
    {
        _logger.LogInformation("Generando proyección SIMULADA para contrato {NumeroContrato} por {MesesFuturos} meses",
            numeroContrato, mesesFuturos);

        await Task.Delay(100); // Simular operación asíncrona

        var proyeccion = new ProyeccionContratoDDto
        {
            NumeroContrato = numeroContrato,
            MesesFuturos = mesesFuturos,
            FechaGeneracion = DateTime.Now,
            Exitoso = true,
            Mensaje = $"✅ Proyección simulada generada exitosamente para {mesesFuturos} meses"
        };

        // Simular datos como si fueran del stored procedure
        var random = new Random();
        var fechaBase = DateTime.Now;

        for (int i = 0; i < mesesFuturos; i++)
        {
            var fechaProyeccion = fechaBase.AddMonths(i);
            var subtotal = 1200.00m + random.Next(-200, 300);
            var descuentos = subtotal * 0.10m; // 10% de descuento
            var impuestos = (subtotal - descuentos) * 0.16m; // 16% IVA
            var total = subtotal - descuentos + impuestos;

            var proyeccionMensual = new ProyeccionMensualDto
            {
                FechaProyeccion = new DateTime(fechaProyeccion.Year, fechaProyeccion.Month, 1),
                MesNombre = $"{GetNombreMes(fechaProyeccion.Month)} {fechaProyeccion.Year}",
                SubtotalServicios = subtotal,
                DescuentosPromociones = descuentos,
                Impuestos = impuestos,
                TotalProyectado = total,
                PromocionesActivas = i % 3 == 0 ? "Descuento Lealtad (-$" + descuentos.ToString("F2") + ")" : "Sin promociones",
                PromocionesVencen = i == 2 ? "Promo Verano (vence 15/" + fechaProyeccion.Month + ")" : "",
                Notas = i % 3 == 0 ? "✅ Con descuentos activos" : "📋 Precio estándar sin promociones"
            };

            proyeccion.ProyeccionesMensuales.Add(proyeccionMensual);
        }

        // Calcular resumen ejecutivo
        var totales = proyeccion.ProyeccionesMensuales;
        proyeccion.ResumenEjecutivo = new ResumenEjecutivoContratoDto
        {
            MesesProyectados = mesesFuturos,
            PagoMinimo = totales.Min(p => p.TotalProyectado),
            PagoMaximo = totales.Max(p => p.TotalProyectado),
            PagoPromedio = totales.Average(p => p.TotalProyectado),
            TotalPeriodo = totales.Sum(p => p.TotalProyectado),
            AhorrosTotales = totales.Sum(p => p.DescuentosPromociones)
        };

        return proyeccion;
    }

    public async Task<bool> ValidarContratoAsync(string numeroContrato)
    {
        _logger.LogInformation("Validando contrato SIMULADO {NumeroContrato}", numeroContrato);

        await Task.Delay(50);

        // Simular algunos contratos válidos
        var contratosValidos = new[] {
            "CTR-2025-001", "CTR-2025-002", "CTR-2025-003",
            "CTR-2024-001", "CTR-2024-002", "CON-2025-001"
        };

        return contratosValidos.Contains(numeroContrato, StringComparer.OrdinalIgnoreCase);
    }

    public async Task<List<ProyeccionContratoDDto>> GenerarProyeccionesMultiplesAsync(List<SolicitudProyeccionContratoDto> solicitudes)
    {
        _logger.LogInformation("Generando {Count} proyecciones múltiples SIMULADAS", solicitudes.Count);

        var proyecciones = new List<ProyeccionContratoDDto>();

        foreach (var solicitud in solicitudes)
        {
            var proyeccion = await GenerarProyeccionContratoAsync(solicitud.NumeroContrato, solicitud.MesesFuturos);
            proyecciones.Add(proyeccion);
        }

        return proyecciones;
    }

    private string GetNombreMes(int mes)
    {
        return mes switch
        {
            1 => "Enero",
            2 => "Febrero",
            3 => "Marzo",
            4 => "Abril",
            5 => "Mayo",
            6 => "Junio",
            7 => "Julio",
            8 => "Agosto",
            9 => "Septiembre",
            10 => "Octubre",
            11 => "Noviembre",
            12 => "Diciembre",
            _ => "Mes"
        };
    }
}
