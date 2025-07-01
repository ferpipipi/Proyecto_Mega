# Plantillas Frontend para MegaCable API

Este directorio contiene archivos de ejemplo y plantillas para ayudar en el desarrollo de la aplicación Angular.

## 📁 Estructura Creada

### Core (Núcleo)
- **`models/`**: Modelos TypeScript que representan las entidades del sistema
  - `contrato.model.ts`: Modelos relacionados con contratos
  - `proyeccion.model.ts`: Modelos para proyecciones financieras
  - `common.model.ts`: Modelos comunes y utilidades

- **`services/`**: Servicios para comunicación con la API
  - `contrato.service.ts`: Servicio para gestión de contratos
  - `proyeccion.service.ts`: Servicio para proyecciones

- **`guards/`**: Guards de Angular para proteger rutas
  - `auth.guard.ts`: Guard de autenticación

- **`interceptors/`**: Interceptores HTTP
  - `error.interceptor.ts`: Manejo global de errores

### Shared (Compartido)
- **`pipes/`**: Pipes personalizados para formateo
  - `currency.pipe.ts`: Formateo de moneda
  - `date-format.pipe.ts`: Formateo de fechas

- **`utils/`**: Utilidades y helpers
  - `format.utils.ts`: Utilidades de formateo
  - `validation.utils.ts`: Utilidades de validación

### Features (Características)
- **`contratos/pages/`**: Páginas de contratos
  - `contrato-busqueda.component.*`: Componente de búsqueda de contratos

- **`proyecciones/pages/`**: Páginas de proyecciones
  - `proyeccion-individual.component.ts`: Componente para proyecciones individuales

### Environments (Entornos)
- `environment.ts`: Configuración de desarrollo
- `environment.prod.ts`: Configuración de producción

### Assets/Styles (Estilos)
- `variables.css`: Variables CSS y temas
- `utilities.css`: Clases utilitarias
- `components.css`: Estilos de componentes reutilizables

## 🚀 Cómo Usar las Plantillas

### 1. Modelos
Los modelos definen la estructura de datos:

```typescript
import { Contrato, ValidacionContratoRequest } from '../core/models/contrato.model';
```

### 2. Servicios
Los servicios encapsulan la lógica de comunicación con la API:

```typescript
constructor(private contratoService: ContratoService) {}

// Validar contrato
this.contratoService.validarContrato(numeroContrato).subscribe(response => {
  console.log(response);
});
```

### 3. Utilidades
Las utilidades proporcionan funciones comunes:

```typescript
import { FormatUtils } from '../shared/utils/format.utils';

// Formatear moneda
const formatted = FormatUtils.formatCurrency(1234.56); // "$1,234.56"
```

### 4. Estilos
Usar las variables CSS y clases utilitarias:

```css
/* Usando variables */
.my-component {
  color: var(--primary-color);
  padding: var(--spacing-md);
}
```

```html
<!-- Usando clases utilitarias -->
<div class="d-flex justify-center p-3 shadow rounded">
  <button class="btn btn-primary">Buscar</button>
</div>
```

## 📋 Tareas Pendientes

Para completar la implementación:

1. **Instalar Angular**: `ng new frontend-app`
2. **Configurar dependencias**: HttpClient, ReactiveFormsModule, etc.
3. **Implementar routing**: Configurar rutas de la aplicación
4. **Añadir tests**: Pruebas unitarias y de integración
5. **Configurar build**: Scripts de construcción y despliegue

## 🔧 Configuración Recomendada

### package.json (dependencias principales)
```json
{
  "@angular/core": "^17.0.0",
  "@angular/common": "^17.0.0",
  "@angular/router": "^17.0.0",
  "rxjs": "^7.0.0"
}
```

### angular.json (configuración de estilos)
```json
{
  "styles": [
    "src/assets/styles/variables.css",
    "src/assets/styles/components.css",
    "src/assets/styles/utilities.css",
    "src/styles.css"
  ]
}
```

## 📖 Notas Importantes

- Los archivos TypeScript muestran errores porque Angular no está instalado
- Las plantillas siguen las mejores prácticas de Angular y arquitectura escalable
- Los estilos CSS están diseñados para ser reutilizables y mantenibles
- Los servicios están preparados para trabajar con la API real de MegaCable

## 🎯 Próximos Pasos

1. Inicializar proyecto Angular real
2. Copiar plantillas a proyecto inicializado
3. Configurar módulos y routing
4. Implementar componentes completos
5. Añadir validaciones y manejo de errores
6. Realizar pruebas de integración con la API
