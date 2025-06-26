// Importa el DbContext definido en tu proyecto
using megaAPI.Data;

// Importa clases para definir documentación OpenAPI (Swagger)
using Microsoft.OpenApi.Models;

// Importa clases de Entity Framework Core para trabajar con bases de datos
using Microsoft.EntityFrameworkCore;

// Crea el constructor de la aplicación Web
var builder = WebApplication.CreateBuilder(args);

// Agrega soporte para explorar los endpoints de la API (requerido por Swagger)
builder.Services.AddEndpointsApiExplorer();

// Configura Swagger/OpenAPI con detalles personalizados para la documentación
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Contenido API",          // Título visible en Swagger UI
        Version = "v1",                   // Versión del API
        Description = "Documentación de la API"  // Descripción visible
    });
});

// (Este es redundante con SwaggerGen y puede eliminarse si no usas Microsoft.AspNetCore.OpenApi)
builder.Services.AddOpenApi();

// Agrega soporte para controladores (API REST con clases Controller)
builder.Services.AddControllers();

// Obtiene desde la configuración (appsettings.json o env vars) la lista de orígenes permitidos para CORS
var origenesPermitidos = builder.Configuration.GetValue<string>("OrigenesPermitidos")!.Split(",");

// Configura CORS para permitir llamadas desde los orígenes especificados
builder.Services.AddCors(opciones =>
{
    opciones.AddDefaultPolicy(politica =>
    {
        politica.WithOrigins(origenesPermitidos) // Dominios que pueden consumir la API
                .AllowAnyHeader()                // Permite cualquier header en la solicitud
                .AllowAnyMethod();               // Permite cualquier verbo HTTP (GET, POST, PUT, etc.)
    });
});

// Registra el DbContext de Entity Framework y configura la conexión a SQL Server
builder.Services.AddDbContext<megaContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("HubConnection"))); // Lee la cadena de conexión "HubConnection" de appsettings.json

// Construye la aplicación con todos los servicios configurados
var app = builder.Build();

// Configura Swagger y su interfaz gráfica SOLO en entorno de desarrollo
if (app.Environment.IsDevelopment())
{
    app.UseSwagger(); // Genera el archivo swagger.json
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Contenido API v1"); // Ruta del documento JSON
        c.RoutePrefix = ""; // Muestra Swagger UI en la raíz del sitio (ej: http://localhost:5000/)
    });
}

// Redirige automáticamente las solicitudes HTTP a HTTPS
app.UseHttpsRedirection();
// Habilita middleware para manejar autorización (requerido si usas [Authorize])
app.UseAuthorization();
// Mapea los endpoints de los controllers (habilita las rutas definidas en los controladores)
app.MapControllers();
// Inicia la aplicación
app.Run();
