using System.Data;
using Microsoft.Data.SqlClient;
using MegaCableApi.Models.DTOs;
using MegaCableApi.Services.Interfaces;

namespace MegaCableApi.Services.Implementation;

/// <summary>
/// Implementación del servicio para gestión de suscriptores
/// </summary>
public class SuscriptorService : ISuscriptorService
{
  private readonly string _connectionString;
  private readonly ILogger<SuscriptorService> _logger;

  public SuscriptorService(IConfiguration configuration, ILogger<SuscriptorService> logger)
  {
    _connectionString = configuration["DatabaseConfig:ConnectionString"] ??
        throw new ArgumentNullException(nameof(configuration), "Connection string is required");
    _logger = logger;
  }

  public async Task<RespuestaPaginadaSuscriptoresDto> ObtenerSuscriptoresAsync(FiltrosSuscriptorDto filtros)
  {
    try
    {
      using var connection = new SqlConnection(_connectionString);
      await connection.OpenAsync();

      // Construir query con filtros
      var whereConditions = new List<string>();
      var parameters = new List<SqlParameter>();

      if (!string.IsNullOrWhiteSpace(filtros.Nombre))
      {
        whereConditions.Add("nombre LIKE @Nombre");
        parameters.Add(new SqlParameter("@Nombre", $"%{filtros.Nombre}%"));
      }

      if (!string.IsNullOrWhiteSpace(filtros.Correo))
      {
        whereConditions.Add("correo LIKE @Correo");
        parameters.Add(new SqlParameter("@Correo", $"%{filtros.Correo}%"));
      }

      if (!string.IsNullOrWhiteSpace(filtros.Celular))
      {
        whereConditions.Add("celular LIKE @Celular");
        parameters.Add(new SqlParameter("@Celular", $"%{filtros.Celular}%"));
      }

      if (filtros.CiudadId.HasValue)
      {
        whereConditions.Add("ciudad_id = @CiudadId");
        parameters.Add(new SqlParameter("@CiudadId", filtros.CiudadId.Value));
      }

      if (filtros.ColoniaId.HasValue)
      {
        whereConditions.Add("colonia_id = @ColoniaId");
        parameters.Add(new SqlParameter("@ColoniaId", filtros.ColoniaId.Value));
      }

      _logger.LogInformation("🔍 SERVICIO DEBUG: EstadosAbreviatura = '{Valor}', IsNull = {IsNull}, IsWhiteSpace = {IsWhiteSpace}",
        filtros.EstadosAbreviatura ?? "NULL",
        filtros.EstadosAbreviatura == null,
        string.IsNullOrWhiteSpace(filtros.EstadosAbreviatura));

      if (!string.IsNullOrWhiteSpace(filtros.EstadosAbreviatura))
      {
        _logger.LogInformation("✅ SERVICIO: Aplicando filtro por estado: '{Estado}' (Length: {Length})",
          filtros.EstadosAbreviatura, filtros.EstadosAbreviatura.Length);
        // Usar TRIM para manejar espacios en campos CHAR y comparación exacta
        whereConditions.Add("TRIM(estados_abreviatura) = @EstadosAbreviatura");
        parameters.Add(new SqlParameter("@EstadosAbreviatura", filtros.EstadosAbreviatura.Trim().ToUpper()));
        _logger.LogInformation("✅ SERVICIO: Parámetro agregado - @EstadosAbreviatura = '{Valor}' (con TRIM)", filtros.EstadosAbreviatura.Trim().ToUpper());
      }
      else
      {
        _logger.LogInformation("❌ SERVICIO: No se aplica filtro por estado (valor null o vacío). Valor recibido: '{Valor}'",
          filtros.EstadosAbreviatura ?? "NULL");
      }

      if (!string.IsNullOrWhiteSpace(filtros.TipoSuscriptorCodigo))
      {
        whereConditions.Add("tipo_suscriptor_codigo = @TipoSuscriptorCodigo");
        parameters.Add(new SqlParameter("@TipoSuscriptorCodigo", filtros.TipoSuscriptorCodigo));
      }

      var whereClause = whereConditions.Any() ? "WHERE " + string.Join(" AND ", whereConditions) : "";

      _logger.LogInformation("SERVICIO: Consulta SQL construida - WHERE clause: '{WhereClause}'", whereClause);
      _logger.LogInformation("SERVICIO: Total de parámetros: {TotalParametros}", parameters.Count);
      foreach (var param in parameters)
      {
        _logger.LogInformation("SERVICIO: Parámetro - {Nombre} = '{Valor}'", param.ParameterName, param.Value);
      }

      // Query para contar total de registros
      var countQuery = $"SELECT COUNT(*) FROM suscriptores {whereClause}";
      _logger.LogInformation("SERVICIO: Query de conteo: {CountQuery}", countQuery);
      var countCommand = new SqlCommand(countQuery, connection);
      countCommand.Parameters.AddRange(parameters.ToArray());
      var countResult = await countCommand.ExecuteScalarAsync();
      var totalRegistros = countResult != null ? (int)countResult : 0;

      // Query para obtener datos paginados
      var offset = (filtros.Pagina - 1) * filtros.TamanoPagina;
      var dataQuery = $@"
                SELECT id, nombre, alias, correo, celular, ciudad_id, colonia_id, 
                       estados_abreviatura, tipo_suscriptor_codigo
                FROM suscriptores 
                {whereClause}
                ORDER BY id 
                OFFSET @Offset ROWS 
                FETCH NEXT @TamanoPagina ROWS ONLY";

      var dataCommand = new SqlCommand(dataQuery, connection);
      dataCommand.Parameters.AddRange(parameters.Select(p => new SqlParameter(p.ParameterName, p.Value)).ToArray());
      dataCommand.Parameters.Add(new SqlParameter("@Offset", offset));
      dataCommand.Parameters.Add(new SqlParameter("@TamanoPagina", filtros.TamanoPagina));

      var suscriptores = new List<SuscriptorDto>();
      using var reader = await dataCommand.ExecuteReaderAsync();

      while (await reader.ReadAsync())
      {
        suscriptores.Add(MapearSuscriptor(reader));
      }

      var totalPaginas = (int)Math.Ceiling((double)totalRegistros / filtros.TamanoPagina);

      return new RespuestaPaginadaSuscriptoresDto
      {
        Suscriptores = suscriptores,
        TotalRegistros = totalRegistros,
        PaginaActual = filtros.Pagina,
        TotalPaginas = totalPaginas,
        TamanoPagina = filtros.TamanoPagina
      };
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener suscriptores");
      throw;
    }
  }

  public async Task<SuscriptorDto?> ObtenerSuscriptorPorIdAsync(int id)
  {
    try
    {
      using var connection = new SqlConnection(_connectionString);
      await connection.OpenAsync();

      var query = @"
                SELECT id, nombre, alias, correo, celular, ciudad_id, colonia_id, 
                       estados_abreviatura, tipo_suscriptor_codigo
                FROM suscriptores 
                WHERE id = @Id";

      using var command = new SqlCommand(query, connection);
      command.Parameters.Add(new SqlParameter("@Id", id));

      using var reader = await command.ExecuteReaderAsync();

      if (await reader.ReadAsync())
      {
        return MapearSuscriptor(reader);
      }

      return null;
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener suscriptor por ID {Id}", id);
      throw;
    }
  }

  public async Task<SuscriptorDto> CrearSuscriptorAsync(CrearSuscriptorDto suscriptor)
  {
    try
    {
      _logger.LogInformation("Iniciando creación de suscriptor: {Nombre}", suscriptor.Nombre);

      // Validar tipo de suscriptor
      ValidarTipoSuscriptor(suscriptor.TipoSuscriptorCodigo);

      using var connection = new SqlConnection(_connectionString);
      await connection.OpenAsync();

      _logger.LogInformation("Conexión a base de datos establecida");

      var query = @"
                INSERT INTO suscriptores (nombre, alias, correo, celular, ciudad_id, colonia_id, 
                                        estados_abreviatura, tipo_suscriptor_codigo)
                VALUES (@Nombre, @Alias, @Correo, @Celular, @CiudadId, @ColoniaId, 
                        @EstadosAbreviatura, @TipoSuscriptorCodigo);
                SELECT SCOPE_IDENTITY();";

      using var command = new SqlCommand(query, connection);
      command.Parameters.Add(new SqlParameter("@Nombre", suscriptor.Nombre));
      command.Parameters.Add(new SqlParameter("@Alias", (object?)suscriptor.Alias ?? DBNull.Value));
      command.Parameters.Add(new SqlParameter("@Correo", (object?)suscriptor.Correo ?? DBNull.Value));
      command.Parameters.Add(new SqlParameter("@Celular", (object?)suscriptor.Celular ?? DBNull.Value));
      // CiudadId y ColoniaId son campos requeridos, no enviar DBNull
      command.Parameters.Add(new SqlParameter("@CiudadId", suscriptor.CiudadId));
      command.Parameters.Add(new SqlParameter("@ColoniaId", suscriptor.ColoniaId));
      command.Parameters.Add(new SqlParameter("@EstadosAbreviatura", (object?)suscriptor.EstadosAbreviatura ?? DBNull.Value));
      command.Parameters.Add(new SqlParameter("@TipoSuscriptorCodigo",
        !string.IsNullOrWhiteSpace(suscriptor.TipoSuscriptorCodigo) ?
        suscriptor.TipoSuscriptorCodigo.ToUpper() : DBNull.Value));

      _logger.LogInformation("Parámetros SQL: Nombre={Nombre}, CiudadId={CiudadId}, ColoniaId={ColoniaId}, Correo={Correo}, TipoSuscriptor={TipoSuscriptor}",
                           suscriptor.Nombre, suscriptor.CiudadId, suscriptor.ColoniaId, suscriptor.Correo, suscriptor.TipoSuscriptorCodigo);

      _logger.LogInformation("Ejecutando query de inserción");
      var result = await command.ExecuteScalarAsync();
      var nuevoId = result != null ? Convert.ToInt32(result) : throw new InvalidOperationException("No se pudo obtener el ID del nuevo suscriptor");

      _logger.LogInformation("Suscriptor creado con ID: {Id}", nuevoId);

      return new SuscriptorDto
      {
        Id = nuevoId,
        Nombre = suscriptor.Nombre,
        Alias = suscriptor.Alias,
        Correo = suscriptor.Correo,
        Celular = suscriptor.Celular,
        CiudadId = suscriptor.CiudadId,
        ColoniaId = suscriptor.ColoniaId,
        EstadosAbreviatura = suscriptor.EstadosAbreviatura,
        TipoSuscriptorCodigo = suscriptor.TipoSuscriptorCodigo
      };
    }
    catch (SqlException sqlEx)
    {
      _logger.LogError(sqlEx, "Error de SQL al crear suscriptor: {Message}", sqlEx.Message);
      throw new InvalidOperationException($"Error en la base de datos: {sqlEx.Message}", sqlEx);
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error general al crear suscriptor: {Message}", ex.Message);
      throw;
    }
  }

  public async Task<SuscriptorDto?> ActualizarSuscriptorAsync(int id, ActualizarSuscriptorDto suscriptor)
  {
    try
    {
      // Validar tipo de suscriptor si se está actualizando
      ValidarTipoSuscriptor(suscriptor.TipoSuscriptorCodigo);

      using var connection = new SqlConnection(_connectionString);
      await connection.OpenAsync();

      // Construir query dinámico con solo los campos que se van a actualizar
      var setClauses = new List<string>();
      var parameters = new List<SqlParameter> { new("@Id", id) };

      if (!string.IsNullOrWhiteSpace(suscriptor.Nombre))
      {
        setClauses.Add("nombre = @Nombre");
        parameters.Add(new SqlParameter("@Nombre", suscriptor.Nombre));
      }

      if (suscriptor.Alias != null)
      {
        setClauses.Add("alias = @Alias");
        parameters.Add(new SqlParameter("@Alias", (object?)suscriptor.Alias ?? DBNull.Value));
      }

      if (suscriptor.Correo != null)
      {
        setClauses.Add("correo = @Correo");
        parameters.Add(new SqlParameter("@Correo", (object?)suscriptor.Correo ?? DBNull.Value));
      }

      if (suscriptor.Celular != null)
      {
        setClauses.Add("celular = @Celular");
        parameters.Add(new SqlParameter("@Celular", (object?)suscriptor.Celular ?? DBNull.Value));
      }

      if (suscriptor.CiudadId.HasValue)
      {
        setClauses.Add("ciudad_id = @CiudadId");
        parameters.Add(new SqlParameter("@CiudadId", (object?)suscriptor.CiudadId ?? DBNull.Value));
      }

      if (suscriptor.ColoniaId.HasValue)
      {
        setClauses.Add("colonia_id = @ColoniaId");
        parameters.Add(new SqlParameter("@ColoniaId", (object?)suscriptor.ColoniaId ?? DBNull.Value));
      }

      if (suscriptor.EstadosAbreviatura != null)
      {
        setClauses.Add("estados_abreviatura = @EstadosAbreviatura");
        parameters.Add(new SqlParameter("@EstadosAbreviatura", (object?)suscriptor.EstadosAbreviatura ?? DBNull.Value));
      }

      if (suscriptor.TipoSuscriptorCodigo != null)
      {
        setClauses.Add("tipo_suscriptor_codigo = @TipoSuscriptorCodigo");
        parameters.Add(new SqlParameter("@TipoSuscriptorCodigo",
          !string.IsNullOrWhiteSpace(suscriptor.TipoSuscriptorCodigo) ?
          suscriptor.TipoSuscriptorCodigo.ToUpper() : DBNull.Value));
      }

      if (!setClauses.Any())
      {
        // No hay campos para actualizar, retornar el suscriptor actual
        return await ObtenerSuscriptorPorIdAsync(id);
      }

      var query = $"UPDATE suscriptores SET {string.Join(", ", setClauses)} WHERE id = @Id";

      using var command = new SqlCommand(query, connection);
      command.Parameters.AddRange(parameters.ToArray());

      var filasAfectadas = await command.ExecuteNonQueryAsync();

      if (filasAfectadas > 0)
      {
        return await ObtenerSuscriptorPorIdAsync(id);
      }

      return null;
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al actualizar suscriptor {Id}", id);
      throw;
    }
  }

  public async Task<bool> EliminarSuscriptorAsync(int id)
  {
    try
    {
      using var connection = new SqlConnection(_connectionString);
      await connection.OpenAsync();

      var query = "DELETE FROM suscriptores WHERE id = @Id";

      using var command = new SqlCommand(query, connection);
      command.Parameters.Add(new SqlParameter("@Id", id));

      var filasAfectadas = await command.ExecuteNonQueryAsync();
      return filasAfectadas > 0;
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al eliminar suscriptor {Id}", id);
      throw;
    }
  }

  public async Task<bool> ExisteCorreoAsync(string correo, int? excluirId = null)
  {
    try
    {
      using var connection = new SqlConnection(_connectionString);
      await connection.OpenAsync();

      var query = "SELECT COUNT(*) FROM suscriptores WHERE correo = @Correo";
      var parameters = new List<SqlParameter> { new("@Correo", correo) };

      if (excluirId.HasValue)
      {
        query += " AND id != @ExcluirId";
        parameters.Add(new SqlParameter("@ExcluirId", excluirId.Value));
      }

      using var command = new SqlCommand(query, connection);
      command.Parameters.AddRange(parameters.ToArray());

      var result = await command.ExecuteScalarAsync();
      var count = result != null ? (int)result : 0;
      return count > 0;
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al verificar existencia de correo {Correo}", correo);
      throw;
    }
  }

  public async Task<List<SuscriptorDto>> BuscarSuscriptoresAsync(string termino)
  {
    try
    {
      using var connection = new SqlConnection(_connectionString);
      await connection.OpenAsync();

      var query = @"
                SELECT TOP 20 id, nombre, alias, correo, celular, ciudad_id, colonia_id, 
                       estados_abreviatura, tipo_suscriptor_codigo
                FROM suscriptores 
                WHERE nombre LIKE @Termino 
                   OR alias LIKE @Termino 
                   OR correo LIKE @Termino 
                   OR celular LIKE @Termino
                ORDER BY nombre";

      using var command = new SqlCommand(query, connection);
      command.Parameters.Add(new SqlParameter("@Termino", $"%{termino}%"));

      var suscriptores = new List<SuscriptorDto>();
      using var reader = await command.ExecuteReaderAsync();

      while (await reader.ReadAsync())
      {
        suscriptores.Add(MapearSuscriptor(reader));
      }

      return suscriptores;
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al buscar suscriptores con término {Termino}", termino);
      throw;
    }
  }

  public async Task<SuscriptorDto?> BuscarSuscriptorAsync(string termino)
  {
    try
    {
      using var connection = new SqlConnection(_connectionString);
      await connection.OpenAsync();

      var query = @"
                SELECT TOP 1 id, nombre, alias, correo, celular, ciudad_id, colonia_id, 
                       estados_abreviatura, tipo_suscriptor_codigo
                FROM suscriptores 
                WHERE nombre LIKE @Termino 
                   OR alias LIKE @Termino 
                   OR correo LIKE @Termino
                   OR celular LIKE @Termino
                ORDER BY nombre";

      using var command = new SqlCommand(query, connection);
      command.Parameters.Add(new SqlParameter("@Termino", $"%{termino}%"));

      using var reader = await command.ExecuteReaderAsync();

      if (await reader.ReadAsync())
      {
        return MapearSuscriptor(reader);
      }

      return null;
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al buscar suscriptor con término {Termino}", termino);
      throw;
    }
  }

  public async Task<EstadisticasSuscriptoresDto> ObtenerEstadisticasAsync()
  {
    try
    {
      using var connection = new SqlConnection(_connectionString);
      await connection.OpenAsync();

      var query = "SELECT COUNT(*) FROM suscriptores";
      using var command = new SqlCommand(query, connection);

      var resultado = await command.ExecuteScalarAsync();
      var total = resultado != null ? Convert.ToInt32(resultado) : 0;

      return new EstadisticasSuscriptoresDto
      {
        TotalSuscriptores = total,
        FechaConsulta = DateTime.Now
      };
    }
    catch (Exception ex)
    {
      _logger.LogError(ex, "Error al obtener estadísticas de suscriptores");
      throw;
    }
  }

  /// <summary>
  /// Obtiene la lista de tipos de suscriptor válidos
  /// </summary>
  /// <returns>Lista de tipos de suscriptor válidos</returns>
  public Task<string[]> ObtenerTiposSuscriptorValidosAsync()
  {
    return Task.FromResult(ObtenerTiposSuscriptorValidos());
  }

  /// <summary>
  /// Obtiene la lista detallada de tipos de suscriptor válidos
  /// </summary>
  /// <returns>Lista detallada de tipos de suscriptor</returns>
  public Task<List<TipoSuscriptorDto>> ObtenerTiposSuscriptorDetalladosAsync()
  {
    var tipos = new List<TipoSuscriptorDto>
    {
      new() { Codigo = "RES", Descripcion = "Residencial", Categoria = "Personal", Activo = true },
      new() { Codigo = "EMP", Descripcion = "Empresa", Categoria = "Comercial", Activo = true },
      new() { Codigo = "EMPL", Descripcion = "Empleado", Categoria = "Personal", Activo = true },
      new() { Codigo = "AC", Descripcion = "Asociación Civil", Categoria = "Institucional", Activo = true },
      new() { Codigo = "GOB", Descripcion = "Gobierno", Categoria = "Institucional", Activo = true },
      new() { Codigo = "ESC", Descripcion = "Escuela", Categoria = "Educativo", Activo = true },
      new() { Codigo = "CARIDAD", Descripcion = "Caridad", Categoria = "Social", Activo = true },
      new() { Codigo = "INTERNO", Descripcion = "Interno", Categoria = "Empresa", Activo = true },
      new() { Codigo = "COMERCIAL", Descripcion = "Comercial", Categoria = "Comercial", Activo = true },
      new() { Codigo = "INDUSTRIAL", Descripcion = "Industrial", Categoria = "Comercial", Activo = true },
      new() { Codigo = "PUBLICO", Descripcion = "Sector Público", Categoria = "Institucional", Activo = true },
      new() { Codigo = "EDUCATIVO", Descripcion = "Educativo", Categoria = "Educativo", Activo = true },
      new() { Codigo = "SALUD", Descripcion = "Sector Salud", Categoria = "Institucional", Activo = true },
      new() { Codigo = "ONG", Descripcion = "Organización No Gubernamental", Categoria = "Social", Activo = true },
      new() { Codigo = "TEMPORAL", Descripcion = "Suscriptor Temporal", Categoria = "Especial", Activo = true },
      new() { Codigo = "PREMIUM", Descripcion = "Suscriptor Premium", Categoria = "Especial", Activo = true },
      new() { Codigo = "CORPORATIVO", Descripcion = "Corporativo", Categoria = "Comercial", Activo = true }
    };

    return Task.FromResult(tipos);
  }

  private static SuscriptorDto MapearSuscriptor(SqlDataReader reader)
  {
    return new SuscriptorDto
    {
      Id = reader.GetInt32("id"),
      Nombre = reader.GetString("nombre"),
      Alias = reader.IsDBNull("alias") ? null : reader.GetString("alias"),
      Correo = reader.IsDBNull("correo") ? null : reader.GetString("correo"),
      Celular = reader.IsDBNull("celular") ? null : reader.GetString("celular"),
      CiudadId = reader.IsDBNull("ciudad_id") ? null : reader.GetInt32("ciudad_id"),
      ColoniaId = reader.IsDBNull("colonia_id") ? null : reader.GetInt32("colonia_id"),
      EstadosAbreviatura = reader.IsDBNull("estados_abreviatura") ? null : reader.GetString("estados_abreviatura"),
      TipoSuscriptorCodigo = reader.IsDBNull("tipo_suscriptor_codigo") ? null : reader.GetString("tipo_suscriptor_codigo")
    };
  }

  /// <summary>
  /// Obtiene los tipos de suscriptor válidos
  /// </summary>
  private static string[] ObtenerTiposSuscriptorValidos()
  {
    return new[] {
      "RES",        // Residencial
      "EMP",        // Empresa
      "EMPL",       // Empleado
      "AC",         // Asociación Civil
      "GOB",        // Gobierno
      "ESC",        // Escuela
      "CARIDAD",    // Caridad
      "INTERNO",    // Interno
      "COMERCIAL",  // Comercial
      "INDUSTRIAL", // Industrial
      "PUBLICO",    // Sector Público
      "EDUCATIVO",  // Educativo
      "SALUD",      // Sector Salud
      "ONG",        // Organización No Gubernamental
      "TEMPORAL",   // Suscriptor Temporal
      "PREMIUM",    // Suscriptor Premium
      "CORPORATIVO" // Corporativo
    };
  }

  /// <summary>
  /// Valida que el tipo de suscriptor sea válido
  /// </summary>
  private static void ValidarTipoSuscriptor(string? tipoSuscriptor)
  {
    if (!string.IsNullOrWhiteSpace(tipoSuscriptor))
    {
      var tiposValidos = ObtenerTiposSuscriptorValidos();
      if (!tiposValidos.Contains(tipoSuscriptor.ToUpper()))
      {
        throw new ArgumentException($"Tipo de suscriptor '{tipoSuscriptor}' no válido. Tipos permitidos: {string.Join(", ", tiposValidos)}");
      }
    }
  }
}
