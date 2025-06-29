namespace MegaCableApi.Configuration;

/// <summary>
/// Configuración de la base de datos
/// </summary>
public class DatabaseConfig
{
  /// <summary>
  /// Cadena de conexión principal
  /// </summary>
  public string ConnectionString { get; set; } = string.Empty;

  /// <summary>
  /// Cadena de conexión de solo lectura
  /// </summary>
  public string ReadOnlyConnectionString { get; set; } = string.Empty;

  /// <summary>
  /// Timeout de comando en segundos
  /// </summary>
  public int CommandTimeout { get; set; } = 30;

  /// <summary>
  /// Número máximo de conexiones en el pool
  /// </summary>
  public int MaxPoolSize { get; set; } = 100;

  /// <summary>
  /// Número mínimo de conexiones en el pool
  /// </summary>
  public int MinPoolSize { get; set; } = 5;

  /// <summary>
  /// Habilita el logging de consultas SQL
  /// </summary>
  public bool EnableSqlLogging { get; set; } = false;

  /// <summary>
  /// Configuración de retry para operaciones de base de datos
  /// </summary>
  public RetryConfig RetryConfig { get; set; } = new();

  /// <summary>
  /// Configuración de caché
  /// </summary>
  public CacheConfig CacheConfig { get; set; } = new();
}

/// <summary>
/// Configuración de reintentos
/// </summary>
public class RetryConfig
{
  /// <summary>
  /// Número máximo de reintentos
  /// </summary>
  public int MaxRetries { get; set; } = 3;

  /// <summary>
  /// Delay base en milisegundos entre reintentos
  /// </summary>
  public int BaseDelayMs { get; set; } = 1000;

  /// <summary>
  /// Factor de multiplicación para backoff exponencial
  /// </summary>
  public double BackoffMultiplier { get; set; } = 2.0;

  /// <summary>
  /// Máximo delay permitido en milisegundos
  /// </summary>
  public int MaxDelayMs { get; set; } = 30000;
}

/// <summary>
/// Configuración de caché
/// </summary>
public class CacheConfig
{
  /// <summary>
  /// Habilita el caché
  /// </summary>
  public bool EnableCache { get; set; } = true;

  /// <summary>
  /// Tiempo de expiración por defecto en minutos
  /// </summary>
  public int DefaultExpirationMinutes { get; set; } = 30;

  /// <summary>
  /// Tamaño máximo del caché en MB
  /// </summary>
  public int MaxCacheSizeMB { get; set; } = 100;

  /// <summary>
  /// Configuraciones específicas por tipo de datos
  /// </summary>
  public Dictionary<string, int> SpecificExpirations { get; set; } = new()
    {
        { "Proyecciones", 15 },
        { "ResumenEjecutivo", 60 },
        { "Configuracion", 120 }
    };
}

/// <summary>
/// Métodos de extensión para DatabaseConfig
/// </summary>
public static class DatabaseConfigExtensions
{
  /// <summary>
  /// Valida la configuración de la base de datos
  /// </summary>
  /// <param name="config">Configuración a validar</param>
  /// <returns>Lista de errores de validación</returns>
  public static List<string> Validate(this DatabaseConfig config)
  {
    var errors = new List<string>();

    if (string.IsNullOrWhiteSpace(config.ConnectionString))
    {
      errors.Add("ConnectionString es requerido");
    }

    if (config.CommandTimeout <= 0)
    {
      errors.Add("CommandTimeout debe ser mayor a 0");
    }

    if (config.MaxPoolSize <= 0)
    {
      errors.Add("MaxPoolSize debe ser mayor a 0");
    }

    if (config.MinPoolSize < 0)
    {
      errors.Add("MinPoolSize no puede ser negativo");
    }

    if (config.MinPoolSize >= config.MaxPoolSize)
    {
      errors.Add("MinPoolSize debe ser menor que MaxPoolSize");
    }

    if (config.RetryConfig.MaxRetries < 0)
    {
      errors.Add("MaxRetries no puede ser negativo");
    }

    if (config.RetryConfig.BaseDelayMs <= 0)
    {
      errors.Add("BaseDelayMs debe ser mayor a 0");
    }

    if (config.RetryConfig.BackoffMultiplier <= 1.0)
    {
      errors.Add("BackoffMultiplier debe ser mayor a 1.0");
    }

    if (config.CacheConfig.DefaultExpirationMinutes <= 0)
    {
      errors.Add("DefaultExpirationMinutes debe ser mayor a 0");
    }

    if (config.CacheConfig.MaxCacheSizeMB <= 0)
    {
      errors.Add("MaxCacheSizeMB debe ser mayor a 0");
    }

    return errors;
  }

  /// <summary>
  /// Obtiene la cadena de conexión con parámetros adicionales
  /// </summary>
  /// <param name="config">Configuración de la base de datos</param>
  /// <param name="additionalParams">Parámetros adicionales</param>
  /// <returns>Cadena de conexión completa</returns>
  public static string GetConnectionStringWithParams(this DatabaseConfig config, Dictionary<string, string>? additionalParams = null)
  {
    var connectionString = config.ConnectionString;

    if (additionalParams != null && additionalParams.Any())
    {
      var separator = connectionString.Contains(';') ? ";" : "";
      var additionalParamsString = string.Join(";", additionalParams.Select(kv => $"{kv.Key}={kv.Value}"));
      connectionString = $"{connectionString}{separator}{additionalParamsString}";
    }

    return connectionString;
  }
}
