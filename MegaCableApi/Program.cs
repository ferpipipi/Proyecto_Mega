using MegaCableApi.Services.Interfaces;
using MegaCableApi.Services.Implementation;
using MegaCableApi.Configuration;

namespace MegaCableApi;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.
        builder.Services.AddRazorPages();
        builder.Services.AddControllers();

        // Configure database settings
        builder.Services.Configure<DatabaseConfig>(
            builder.Configuration.GetSection("DatabaseConfig"));

        // Register application services
        builder.Services.AddScoped<IProyeccionService, ProyeccionService>();
        // Usar servicio simulado temporalmente hasta configurar la base de datos real
        builder.Services.AddScoped<IProyeccionContratoService, ProyeccionContratoServiceMock>();
        // Para usar el servicio real con base de datos, descomenta la siguiente línea:
        // builder.Services.AddScoped<IProyeccionContratoService, ProyeccionContratoService>();
        builder.Services.AddScoped<IDeudaService, DeudaService>();

        // Add API explorer and Swagger services
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen(c =>
        {
            c.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
            {
                Title = "MegaCable API",
                Version = "v1",
                Description = "API para gestión de proyecciones de corte de MegaCable",
                Contact = new Microsoft.OpenApi.Models.OpenApiContact
                {
                    Name = "Equipo de Desarrollo MegaCable",
                    Email = "desarrollo@megacable.com"
                }
            });

            // Include XML comments if available
            var xmlFile = $"{System.Reflection.Assembly.GetExecutingAssembly().GetName().Name}.xml";
            var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
            if (File.Exists(xmlPath))
            {
                c.IncludeXmlComments(xmlPath);
            }
        });


        // Configure CORS para permitir peticiones desde el frontend
        builder.Services.AddCors(options =>
        {
            options.AddPolicy("PermitirAngular", policy =>
            {
                    policy.WithOrigins("http://localhost:4200") // Cambia esto por la URL de tu frontend
                    .AllowAnyMethod()
                    .AllowAnyHeader();
            });
        });
        

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        if (!app.Environment.IsDevelopment())
        {
            app.UseExceptionHandler("/Error");
            // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
            app.UseHsts();
        }
        else
        {
            // Enable Swagger in development environment
            app.UseSwagger();
            app.UseSwaggerUI();
        }

        app.UseHttpsRedirection();
        app.UseStaticFiles();

        // Usar CORS
        app.UseRouting();
        app.UseCors("PermitirAngular");
        app.UseAuthorization();

        app.MapRazorPages();
        app.MapControllers();

        app.Run();
    }
}

