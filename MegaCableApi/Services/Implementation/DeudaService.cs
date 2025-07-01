using MegaCableApi.DTOs;
using MegaCableApi.Services.Interfaces;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace MegaCableApi.Services.Implementation
{
    public class DeudaService : IDeudaService
    {
        private readonly IConfiguration _config;

        public DeudaService(IConfiguration config)
        {
            _config = config;
        }

        public async Task<DeudaDto> CalcularDeuda(int suscriptorId)
        {
            var deuda = new DeudaDto
            {
                SuscriptorId = suscriptorId,
                FechaCalculo = DateTime.Now,
                FechaProximoPago = DateTime.Now.AddMonths(1)
            };

            string connectionString = _config.GetConnectionString("DefaultConnection")
                ?? throw new InvalidOperationException("La cadena de conexión no está configurada.");

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                await connection.OpenAsync();

                // 1. Obtener información del suscriptor
                var suscriptor = await GetSuscriptor(connection, suscriptorId);
                deuda.Nombre = suscriptor.nombre ?? "Sin nombre";
                deuda.Alias = suscriptor.alias;

                // 2. Calcular servicios y promociones
                await CalculateServicios(connection, suscriptorId, deuda);
                await CalculatePromociones(connection, suscriptorId, deuda);

                // 3. Calcular total
                deuda.Total = deuda.Servicios.Sum(s => s.Precio) - deuda.Promociones.Sum(p => p.Descuento);
            }

            return deuda;
        }

        private async Task<SuscriptoresDto> GetSuscriptor(SqlConnection connection, int suscriptorId)
        {
            string query = @"SELECT nombre, alias FROM suscriptores WHERE id = @Id";
            
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@Id", suscriptorId);
                
                using (var reader = await command.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        return new SuscriptoresDto
                        {
                            nombre = reader["nombre"]?.ToString(),
                            alias = reader["alias"]?.ToString()
                        };
                    }
                }
            }
            throw new Exception("Suscriptor no encontrado");
        }

        private async Task CalculateServicios(SqlConnection connection, int suscriptorId, DeudaDto deuda)
        {
            string query = @"
                SELECT 
                    s.nombre,
                    s.precio_base AS precio
                FROM contratos c
                JOIN (
                    SELECT 
                        contrato_id,
                        servicio_nombre AS nombre
                    FROM contratos_servicios
                    WHERE servicio_nombre IS NOT NULL
                ) cs ON c.id = cs.contrato_id
                JOIN servicios s ON cs.nombre = s.nombre
                WHERE c.suscriptor_id = @SuscriptorId
                AND s.activo = 1";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@SuscriptorId", suscriptorId);
                
                using (var reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        if (!string.IsNullOrEmpty(reader["nombre"].ToString()))
                        {
                            deuda.Servicios.Add(new ServicioDeudaDto
                            {
                                Nombre = reader["nombre"].ToString(),
                                Precio = reader["precio"] != DBNull.Value ? 
                                    Convert.ToDecimal(reader["precio"]) : 0
                            });
                        }
                    }
                }
            }
        }

        private async Task CalculatePromociones(SqlConnection connection, int suscriptorId, DeudaDto deuda)
        {
            string query = @"
                SELECT 
                    p.nombre,
                    ps.descuento_especifico AS descuento
                FROM contratos c
                JOIN contratos_servicios cs ON c.id = cs.contrato_id
                JOIN promociones_servicios ps ON cs.servicio_nombre = ps.servicio_nombre
                JOIN promociones p ON ps.promocion_id = p.id
                WHERE c.suscriptor_id = @SuscriptorId
                AND ps.activo = 1";

            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@SuscriptorId", suscriptorId);
                
                using (var reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        if (!string.IsNullOrEmpty(reader["nombre"].ToString()))
                        {
                            deuda.Promociones.Add(new PromocionDeudaDto
                            {
                                Nombre = reader["nombre"].ToString(),
                                Descuento = reader["descuento"] != DBNull.Value ? 
                                    Convert.ToDecimal(reader["descuento"]) : 0
                            });
                        }
                    }
                }
            }
        }
    }
}