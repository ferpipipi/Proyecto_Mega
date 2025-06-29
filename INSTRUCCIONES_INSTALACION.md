# 🚀 Instrucciones para Ejecutar MegaCable API

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

### ✅ Software Necesario:
- **Git** - [Descargar aquí](https://git-scm.com/downloads)
- **.NET 8.0 SDK** - [Descargar aquí](https://dotnet.microsoft.com/download/dotnet/8.0)
- **Visual Studio Code** (recomendado) - [Descargar aquí](https://code.visualstudio.com/)
- **Postman** (opcional, para probar la API) - [Descargar aquí](https://www.postman.com/downloads/)

### 🔍 Verificar Instalaciones:
Abre una terminal (PowerShell en Windows) y ejecuta:
```powershell
git --version
dotnet --version
```

Si ves las versiones, todo está correcto. ✅

---

## 📥 Paso 1: Descargar el Proyecto

### Opción A: Clonar con Git (Recomendado)
```powershell
# Crear una carpeta para el proyecto
mkdir MegaCableAPI
cd MegaCableAPI

# Clonar el repositorio
git clone https://github.com/ferpipipi/Proyecto_Mega.git

# Entrar al directorio del proyecto
cd Proyecto_Mega

# Cambiar a la rama ApiFull (donde está el código completo)
git checkout ApiFull
```

### Opción B: Descargar ZIP
1. Ve a: https://github.com/ferpipipi/Proyecto_Mega
2. Selecciona la rama **ApiFull**
3. Haz clic en **Code** → **Download ZIP**
4. Extrae el archivo en tu computadora

---

## ⚙️ Paso 2: Configurar el Proyecto

### 🔧 Navegar al Directorio Correcto
```powershell
cd MegaCableApi
```

### 📦 Restaurar Dependencias
```powershell
dotnet restore
```

### 🔨 Compilar el Proyecto
```powershell
dotnet build
```

Si todo está correcto, verás un mensaje de **"Compilación realizada correctamente"**. ✅

---

## 🚀 Paso 3: Ejecutar la API

### ▶️ Ejecutar en Modo Desarrollo
```powershell
cd MegaCableApi
dotnet run
```

### 🌐 Verificar que Funciona
La API se ejecutará en: **http://localhost:5011**

Verás un mensaje como:
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5011
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

---

## 📖 Paso 4: Acceder a la Documentación

### 🔍 Swagger UI (Documentación Interactiva)
Abre tu navegador y ve a: **http://localhost:5011/swagger**

Aquí podrás:
- ✅ Ver todos los endpoints disponibles
- ✅ Probar la API directamente desde el navegador
- ✅ Ver ejemplos de request/response

---

## 🧪 Paso 5: Probar los Endpoints

### 🎭 Contratos de Prueba Disponibles (Servicio Mock)
La API usa datos simulados. Estos contratos están configurados como **válidos**:
- `CTR-2025-001`
- `CTR-2025-002`
- `CTR-2025-003`
- `CTR-2024-001`
- `CTR-2024-002`
- `CON-2025-001`

### 🔧 Endpoints Principales

#### 1. Validar Contrato
```http
GET http://localhost:5011/api/Proyeccion/contrato/CTR-2025-001/validar
```

#### 2. Generar Proyección (6 meses)
```http
GET http://localhost:5011/api/Proyeccion/contrato/CTR-2025-001?mesesFuturos=6
```

#### 3. Proyecciones Múltiples
```http
POST http://localhost:5011/api/Proyeccion/contratos/multiple
Content-Type: application/json

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
```

### 💻 Ejemplos con PowerShell
```powershell
# Validar contrato
Invoke-RestMethod -Uri "http://localhost:5011/api/Proyeccion/contrato/CTR-2025-001/validar" -Method GET

# Generar proyección
Invoke-RestMethod -Uri "http://localhost:5011/api/Proyeccion/contrato/CTR-2025-001?mesesFuturos=6" -Method GET
```

---

## 🛠️ Comandos Útiles

### 🔄 Actualizar el Código
```powershell
git pull origin ApiFull
dotnet build
```

### 🛑 Detener la API
Presiona **Ctrl + C** en la terminal donde está ejecutándose.

### 🧹 Limpiar y Recompilar
```powershell
dotnet clean
dotnet build
```

### 🔧 Si hay Procesos Bloqueados
```powershell
Get-Process -Name "MegaCableApi" -ErrorAction SilentlyContinue | Stop-Process -Force
```

---

## 🗄️ Configuración de Base de Datos (Opcional)

### 🎭 Modo Actual: Servicio Mock
La API está configurada para usar **datos simulados**, así que funciona sin base de datos.

### 🔄 Para Cambiar a Base de Datos Real:
1. Edita `Program.cs`:
   ```csharp
   // Comentar esta línea:
   // builder.Services.AddScoped<IProyeccionContratoService, ProyeccionContratoServiceMock>();
   
   // Descomentar esta línea:
   builder.Services.AddScoped<IProyeccionContratoService, ProyeccionContratoService>();
   ```

2. Actualiza `appsettings.json`:
   ```json
   {
     "DatabaseConfig": {
       "ConnectionString": "Server=TU_SERVIDOR;Database=MegaCableDb;Trusted_Connection=true;TrustServerCertificate=true;"
     }
   }
   ```

3. Recompila: `dotnet build`

---

## ❓ Solución de Problemas Comunes

### 🚫 Error de Puerto Ocupado
```
Error: Address already in use
```
**Solución:** Cambia el puerto en `Properties/launchSettings.json` o detén el proceso que usa el puerto.

### 🚫 Error de Compilación
```
Error: Could not find project or directory
```
**Solución:** Asegúrate de estar en el directorio `MegaCableApi` (donde está el archivo `.csproj`).

### 🚫 Error de Dependencias
```
Error: Package not found
```
**Solución:** Ejecuta `dotnet restore` nuevamente.

---

## 📞 Soporte

### 📧 Contacto
- **Desarrollador:** [Tu nombre]
- **Email:** [tu-email@empresa.com]
- **Repositorio:** https://github.com/ferpipipi/Proyecto_Mega

### 📚 Recursos Adicionales
- **Documentación .NET:** https://docs.microsoft.com/dotnet/
- **ASP.NET Core:** https://docs.microsoft.com/aspnet/core/
- **Swagger:** http://localhost:5011/swagger (cuando la API esté ejecutándose)

---

## ✅ Lista de Verificación Rápida

- [ ] Git instalado
- [ ] .NET 8.0 SDK instalado
- [ ] Proyecto clonado/descargado
- [ ] Dependencias restauradas (`dotnet restore`)
- [ ] Proyecto compilado (`dotnet build`)
- [ ] API ejecutándose (`dotnet run`)
- [ ] Swagger accesible en http://localhost:5011/swagger
- [ ] Endpoints probados con contratos de prueba

**¡Cuando todos los elementos estén marcados, la API estará funcionando correctamente! 🎉**
