# MegaCable Frontend - Angular

Frontend desarrollado en Angular para la gestión de suscriptores de MegaCable, migrado desde `frontend-test.html`.

## 🚀 Características

- ✅ **Dashboard** con estadísticas en tiempo real
- ✅ **Gestión de Suscriptores** (CRUD completo)
- ✅ **Panel de Pruebas API** (migración de frontend-test.html)
- ✅ **Navegación moderna** con menús y footer
- ✅ **Validación de formularios** en tiempo real
- ✅ **Búsqueda por estados** con abreviaciones oficiales de México
- ✅ **Responsive design** con Bootstrap 5
- ✅ **Manejo de errores** robusto

## ⭐ **NUEVA ACTUALIZACIÓN**
**Búsqueda por Estados Corregida**: Se han actualizado todas las abreviaciones de estados mexicanos para que la búsqueda funcione correctamente. Ver [ESTADOS_ACTUALIZADOS.md](./ESTADOS_ACTUALIZADOS.md) para detalles completos.

## 📋 Requisitos Previos

- Node.js 18 o superior
- Angular CLI 17 o superior
- API de MegaCable ejecutándose en `http://localhost:5011`

## 🛠️ Instalación

1. **Navegar al directorio del frontend:**
   ```bash
   cd frontend
   ```

2. **Instalar dependencias:**
   ```bash
   npm install
   ```

3. **Instalar Angular CLI globalmente (si no está instalado):**
   ```bash
   npm install -g @angular/cli@17
   ```

## 🚀 Ejecución

1. **Asegurarse de que la API esté ejecutándose:**
   ```bash
   # En el directorio de la API (MegaCableApi)
   dotnet run
   ```

2. **Ejecutar el frontend:**
   ```bash
   # En el directorio frontend
   ng serve
   ```

3. **Abrir en el navegador:**
   ```
   http://localhost:4200
   ```

## 📁 Estructura del Proyecto

```
frontend/
├── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── dashboard/           # Panel principal
│   │   │   ├── suscriptores-lista/  # Lista de suscriptores
│   │   │   ├── suscriptor-form/     # Formulario crear/editar
│   │   │   └── test-api/            # Panel de pruebas (migrado)
│   │   ├── services/
│   │   │   └── suscriptor.service.ts # Comunicación con API
│   │   ├── models/
│   │   │   └── suscriptor.model.ts   # Interfaces TypeScript
│   │   ├── app.component.ts          # Componente principal
│   │   └── app.routes.ts             # Configuración de rutas
│   ├── assets/                       # Recursos estáticos
│   ├── index.html                    # Página principal
│   └── styles.css                    # Estilos globales
├── package.json                      # Dependencias del proyecto
├── angular.json                      # Configuración Angular CLI
└── tsconfig.json                     # Configuración TypeScript
```

## 🎯 Funcionalidades

### 1. Dashboard
- Estadísticas en tiempo real
- Acciones rápidas
- Estado de la API
- Información del sistema

### 2. Gestión de Suscriptores
- **Listar:** Tabla paginada con filtros
- **Crear:** Formulario con validaciones
- **Editar:** Actualización de datos
- **Eliminar:** Confirmación de eliminación
- **Buscar:** Búsqueda por múltiples campos

### 3. Panel de Pruebas API (Migrado)
- ✅ Verificación de estado de la API
- ✅ Carga de estadísticas
- ✅ Lista de suscriptores
- ✅ Formulario de creación con validaciones
- ✅ Generador de datos de prueba
- ✅ Historial de resultados

## 🌐 Endpoints Utilizados

La aplicación consume los siguientes endpoints de la API:

```typescript
GET    /api/suscriptores              // Lista paginada
GET    /api/suscriptores/{id}         // Suscriptor por ID
POST   /api/suscriptores              // Crear suscriptor
PUT    /api/suscriptores/{id}         // Actualizar suscriptor
DELETE /api/suscriptores/{id}         // Eliminar suscriptor
GET    /api/suscriptores/buscar       // Buscar suscriptores
GET    /api/suscriptores/verificar-correo // Verificar correo
GET    /api/suscriptores/estadisticas // Estadísticas
```

## 🎨 Tecnologías Utilizadas

- **Frontend:** Angular 17 (Standalone Components)
- **UI Framework:** Bootstrap 5.3
- **Icons:** Font Awesome 6.0
- **HTTP Client:** Angular HttpClient
- **Forms:** Angular Reactive Forms
- **Routing:** Angular Router
- **TypeScript:** Tipado estático

## 📝 Notas de Migración

### Desde frontend-test.html:
- ✅ **Estado de API:** Migrado con mejoras visuales
- ✅ **Estadísticas:** Integradas en Dashboard y Panel de Pruebas
- ✅ **Creación de Suscriptores:** Formulario mejorado con validaciones
- ✅ **Resultados:** Panel de historial de operaciones
- ✅ **Datos de Prueba:** Generador automático mantenido

### Mejoras Añadidas:
- 🔄 **Navegación:** Menú de navegación completo
- 📱 **Responsive:** Diseño adaptativo
- ⚡ **Performance:** Lazy loading de componentes
- 🛡️ **Validaciones:** Validaciones del lado del cliente
- 🎯 **UX/UI:** Interfaz moderna y amigable

## 🔧 Comandos Útiles

```bash
# Desarrollo
ng serve                 # Servidor de desarrollo
ng build                 # Build de producción
ng test                  # Ejecutar pruebas
ng lint                  # Linter de código

# Generar componentes (si necesitas agregar más)
ng generate component components/nuevo-componente
ng generate service services/nuevo-servicio
```

## 🧪 Pruebas de la Búsqueda por Estados

### Prueba 1: Filtro en Lista de Suscriptores
1. Ve a "Lista de Suscriptores" (`/suscriptores`)
2. En el filtro "Estado", selecciona "JAL - Jalisco"
3. Haz clic en "Buscar"
4. ✅ Debe mostrar solo suscriptores de Jalisco

### Prueba 2: Crear Suscriptor con Estado
1. Ve a "Crear Suscriptor" (`/suscriptores/crear`)
2. Llena el formulario y selecciona "CDMX - Ciudad de México"
3. Guarda el suscriptor
4. ✅ El estado debe guardarse correctamente

### Prueba 3: API Directa (Opcional)
```bash
# Probar búsqueda por estado desde terminal
curl "http://localhost:5011/api/suscriptores?estadosAbreviatura=JAL"
curl "http://localhost:5011/api/suscriptores?estadosAbreviatura=CDMX"
```

### Estados Disponibles para Pruebas
Los 32 estados de México están disponibles con sus abreviaciones oficiales:
- **AGS** (Aguascalientes), **BC** (Baja California), **CDMX** (Ciudad de México)
- **JAL** (Jalisco), **NL** (Nuevo León), **TAMS** (Tamaulipas)
- Ver lista completa en [ESTADOS_ACTUALIZADOS.md](./ESTADOS_ACTUALIZADOS.md)

## 🐛 Solución de Problemas

### Error de CORS:
Si encuentras errores de CORS, verifica que la API tenga configurado:
```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", builder =>
    {
        builder
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});
```

### API no disponible:
1. Verifica que la API esté ejecutándose en `http://localhost:5011`
2. Revisa la configuración en `suscriptor.service.ts`
3. Comprueba la conectividad desde el Panel de Pruebas

### Búsqueda por Estado no funciona:
1. ✅ **SOLUCIONADO**: Abreviaciones corregidas en v1.1
2. Verifica que la API tenga datos con estados válidos
3. Revisa que el backend use el campo `estados_abreviatura`

---

## 📞 Soporte

Para dudas o problemas, revisa:
1. Panel de Pruebas API en la aplicación
2. Consola del navegador (F12)
3. Logs de la API de MegaCable
