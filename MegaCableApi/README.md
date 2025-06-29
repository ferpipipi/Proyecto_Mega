# MegaCable API

Una API REST desarrollada con ASP.NET Core que incluye documentación automática con Swagger.

## Características

- ✅ ASP.NET Core 8.0
- ✅ Swagger/OpenAPI para documentación automática
- ✅ Controladores API RESTful
- ✅ Páginas Razor integradas
- ✅ Configuración para desarrollo y producción

## Requisitos

- .NET 8.0 SDK
- Visual Studio 2022 o Visual Studio Code

## Instalación

1. Clona el repositorio:
```bash
git clone <url-del-repositorio>
cd MegaCableApi
```

2. Restaura las dependencias:
```bash
dotnet restore
```

3. Ejecuta la aplicación:
```bash
dotnet run
```

## Uso

### URLs principales:
- **Aplicación:** http://localhost:5011
- **Swagger UI:** http://localhost:5011/swagger
- **API Docs JSON:** http://localhost:5011/swagger/v1/swagger.json

### Endpoints disponibles:
- `GET /api/WeatherForecast` - Obtiene pronóstico del clima para 5 días
- `GET /api/WeatherForecast/{days}` - Obtiene pronóstico para un día específico

## Estructura del proyecto

```
├── Controllers/
│   └── WeatherForecastController.cs
├── Pages/
│   ├── Shared/
│   ├── Index.cshtml
│   ├── Privacy.cshtml
│   └── Error.cshtml
├── Properties/
│   └── launchSettings.json
├── wwwroot/
├── Program.cs
├── appsettings.json
└── MegaCableApi.csproj
```

## Tecnologías utilizadas

- **ASP.NET Core 8.0** - Framework web
- **Swashbuckle.AspNetCore** - Documentación API con Swagger
- **Bootstrap 5** - Framework CSS
- **jQuery** - Biblioteca JavaScript

## Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT.
