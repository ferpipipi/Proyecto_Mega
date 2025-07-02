namespace MegaCableApi.Models.DTOs;

/// <summary>
/// DTO para representar un suscriptor
/// </summary>
public class SuscriptorDto
{
  public int Id { get; set; }
  public string Nombre { get; set; } = string.Empty;
  public string? Alias { get; set; }
  public string? Correo { get; set; }
  public string? Celular { get; set; }
  public int? CiudadId { get; set; }
  public int? ColoniaId { get; set; }
  public string? EstadosAbreviatura { get; set; }
  public string? TipoSuscriptorCodigo { get; set; }
}

/// <summary>
/// DTO para crear un nuevo suscriptor
/// </summary>
public class CrearSuscriptorDto
{
  public string Nombre { get; set; } = string.Empty;
  public string? Alias { get; set; }
  public string Correo { get; set; } = string.Empty;
  public string? Celular { get; set; }
  public int CiudadId { get; set; }
  public int ColoniaId { get; set; }
  public string? EstadosAbreviatura { get; set; }
  public string? TipoSuscriptorCodigo { get; set; }
}

/// <summary>
/// DTO para actualizar un suscriptor existente
/// </summary>
public class ActualizarSuscriptorDto
{
  public string? Nombre { get; set; }
  public string? Alias { get; set; }
  public string? Correo { get; set; }
  public string? Celular { get; set; }
  public int? CiudadId { get; set; }
  public int? ColoniaId { get; set; }
  public string? EstadosAbreviatura { get; set; }
  public string? TipoSuscriptorCodigo { get; set; }
}

/// <summary>
/// DTO para filtros de búsqueda de suscriptores
/// </summary>
public class FiltrosSuscriptorDto
{
  public string? Nombre { get; set; }
  public string? Correo { get; set; }
  public string? Celular { get; set; }
  public int? CiudadId { get; set; }
  public int? ColoniaId { get; set; }

  [Microsoft.AspNetCore.Mvc.FromQuery(Name = "estadosAbreviatura")]
  public string? EstadosAbreviatura { get; set; }

  public string? TipoSuscriptorCodigo { get; set; }
  public int Pagina { get; set; } = 1;
  public int TamanoPagina { get; set; } = 10;
}

/// <summary>
/// DTO para respuesta paginada de suscriptores
/// </summary>
public class RespuestaPaginadaSuscriptoresDto
{
  public List<SuscriptorDto> Suscriptores { get; set; } = new();
  public int TotalRegistros { get; set; }
  public int PaginaActual { get; set; }
  public int TotalPaginas { get; set; }
  public int TamanoPagina { get; set; }
}

/// <summary>
/// DTO para estadísticas de suscriptores
/// </summary>
public class EstadisticasSuscriptoresDto
{
  public int TotalSuscriptores { get; set; }
  public DateTime FechaConsulta { get; set; }
}

/// <summary>
/// DTO para tipos de suscriptor
/// </summary>
public class TipoSuscriptorDto
{
  public string Codigo { get; set; } = string.Empty;
  public string Descripcion { get; set; } = string.Empty;
  public string Categoria { get; set; } = string.Empty;
  public bool Activo { get; set; } = true;
}
