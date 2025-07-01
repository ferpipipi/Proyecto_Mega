using MegaCableApi.Models.DTOs;

namespace MegaCableApi.Services.Interfaces;

/// <summary>
/// Interfaz del servicio para gestión de suscriptores
/// </summary>
public interface ISuscriptorService
{
    /// <summary>
    /// Obtiene todos los suscriptores con filtros y paginación
    /// </summary>
    Task<RespuestaPaginadaSuscriptoresDto> ObtenerSuscriptoresAsync(FiltrosSuscriptorDto filtros);
    
    /// <summary>
    /// Obtiene un suscriptor por su ID
    /// </summary>
    Task<SuscriptorDto?> ObtenerSuscriptorPorIdAsync(int id);
    
    /// <summary>
    /// Crea un nuevo suscriptor
    /// </summary>
    Task<SuscriptorDto> CrearSuscriptorAsync(CrearSuscriptorDto suscriptor);
    
    /// <summary>
    /// Actualiza un suscriptor existente
    /// </summary>
    Task<SuscriptorDto?> ActualizarSuscriptorAsync(int id, ActualizarSuscriptorDto suscriptor);
    
    /// <summary>
    /// Elimina un suscriptor
    /// </summary>
    Task<bool> EliminarSuscriptorAsync(int id);
    
    /// <summary>
    /// Verifica si existe un suscriptor con el correo especificado
    /// </summary>
    Task<bool> ExisteCorreoAsync(string correo, int? excluirId = null);
    
    /// <summary>
    /// Busca suscriptores por término de búsqueda general
    /// </summary>
    Task<List<SuscriptorDto>> BuscarSuscriptoresAsync(string termino);
}
