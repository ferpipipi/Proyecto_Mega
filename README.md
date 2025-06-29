# 📊 MegaCable API - Proyecciones de Contratos

## 🚀 Estado Actual

✅ **API FUNCIONANDO CORRECTAMENTE**
- Compilación exitosa ✅
- Servidor ejecutándose en: `http://localhost:5011`
- Swagger UI disponible en: `http://localhost:5011/swagger`
- Usando servicio MOCK (simulado) para pruebas 🎭

## 🔧 Configuración Actual

### Servicios Configurados
- **IProyeccionContratoService**: Usando implementación `ProyeccionContratoServiceMock`
- **IProyeccionService**: Implementación para proyecciones generales
- **Swagger**: Documentación interactiva habilitada en desarrollo

### Base de Datos
- Actualmente configurada para usar **tempdb** (base de datos temporal)
- Servicio mock activo para evitar problemas de conexión
- Para cambiar a base de datos real, ver sección "Cambio a Producción"

## 📋 Endpoints Disponibles

### 1. Validar Contrato
```http
GET /api/Proyeccion/contrato/{numeroContrato}/validar
```

**Ejemplo:**
```powershell
Invoke-RestMethod -Uri "http://localhost:5011/api/Proyeccion/contrato/CTR-2025-001/validar" -Method GET
```

**Respuesta:**
```json
{
  "numeroContrato": "CTR-2025-001",
  "esValido": true,
  "mensaje": "✅ Contrato válido y activo",
  "fechaValidacion": "2025-06-28T23:34:22.6554404-06:00"
}
```

### 2. Generar Proyección de Contrato
```http
GET /api/Proyeccion/contrato/{numeroContrato}?mesesFuturos={meses}
```

**Ejemplo:**
```powershell
Invoke-RestMethod -Uri "http://localhost:5011/api/Proyeccion/contrato/CTR-2025-001?mesesFuturos=6" -Method GET
```

**Respuesta:** Objeto completo con proyecciones mensuales y resumen ejecutivo.

### 3. Proyecciones Múltiples
```http
POST /api/Proyeccion/contratos/multiple
```

**Ejemplo:**
```powershell
$body = @'
[
  {
    "numeroContrato": "CTR-2025-001",
    "mesesFuturos": 3
  },
  {
    "numeroContrato": "CTR-2025-002",
    "mesesFuturos": 6
  }
]
'@

Invoke-RestMethod -Uri "http://localhost:5011/api/Proyeccion/contratos/multiple" -Method POST -Body $body -ContentType "application/json"
```

## 🎭 Contratos de Prueba (Mock)

Los siguientes contratos están configurados como **válidos** en el servicio mock:
- `CTR-2025-001`
- `CTR-2025-002`
- `CTR-2025-003`
- `CTR-2024-001`
- `CTR-2024-002`
- `CON-2025-001`

Cualquier otro número de contrato retornará como **inválido**.

## 📊 Estructura de Respuesta

### ProyeccionContratoDDto
```json
{
  "numeroContrato": "CTR-2025-001",
  "mesesFuturos": 6,
  "proyeccionesMensuales": [
    {
      "fechaProyeccion": "2025-06-01T00:00:00",
      "mesNombre": "Junio 2025",
      "subtotalServicios": 1485.00,
      "descuentosPromociones": 148.50,
      "impuestos": 213.84,
      "totalProyectado": 1550.34,
      "promocionesActivas": "Descuento Lealtad (-$148.50)",
      "promocionesVencen": "",
      "notas": "✅ Con descuentos activos",
      "tieneAlertas": false,
      "porcentajeDescuento": 10.00
    }
  ],
  "resumenEjecutivo": {
    "mesesProyectados": 6,
    "pagoMinimo": 1092.02,
    "pagoMaximo": 1550.34,
    "pagoPromedio": 1307.61,
    "totalPeriodo": 7845.66,
    "ahorrosTotales": 751.50,
    "variacionMaxMin": 458.32,
    "porcentajeAhorroTotal": 8.74
  },
  "fechaGeneracion": "2025-06-28T23:34:42.8629121-06:00",
  "exitoso": true,
  "mensaje": "✅ Proyección simulada generada exitosamente para 6 meses"
}
```

## 🔄 Cambio a Producción

Para cambiar del servicio mock al servicio real que usa la base de datos:

1. **Actualizar Program.cs:**
```csharp
// Comentar esta línea:
// builder.Services.AddScoped<IProyeccionContratoService, ProyeccionContratoServiceMock>();

// Descomentar esta línea:
builder.Services.AddScoped<IProyeccionContratoService, ProyeccionContratoService>();
```

2. **Actualizar appsettings.json:**
```json
{
  "DatabaseConfig": {
    "ConnectionString": "Server=TU_SERVIDOR;Database=MegaCableDb;Trusted_Connection=true;TrustServerCertificate=true;"
  }
}
```

3. **Recompilar y ejecutar:**
```powershell
dotnet build
dotnet run
```

## 🛠️ Comandos Útiles

### Compilar
```powershell
cd "x:\IVANDALIGARCIA\Escritorio\PLATZI\MEGA_CABLE_CURSOS\MegaCableApi"
dotnet build
```

### Ejecutar
```powershell
cd "x:\IVANDALIGARCIA\Escritorio\PLATZI\MEGA_CABLE_CURSOS\MegaCableApi\MegaCableApi"
dotnet run
```

### Detener procesos bloqueados
```powershell
Get-Process -Name "MegaCableApi" -ErrorAction SilentlyContinue | Stop-Process -Force
```

## 📝 Notas Técnicas

- ✅ Arquitectura limpia implementada con separación de responsabilidades
- ✅ Inyección de dependencias configurada correctamente
- ✅ Manejo de errores implementado
- ✅ Swagger UI para documentación interactiva
- ✅ Logging configurado
- ✅ DTOs bien estructurados
- ✅ Servicios mock para pruebas independientes de BD

## 🎯 Próximos Pasos Recomendados

1. **Configurar la base de datos real** cuando esté disponible
2. **Agregar autenticación** si es necesario
3. **Implementar cache** para mejorar rendimiento
4. **Agregar pruebas unitarias** e integración
5. **Configurar CI/CD** para despliegues automáticos

---

**¡La API está lista para usar! 🚀**
