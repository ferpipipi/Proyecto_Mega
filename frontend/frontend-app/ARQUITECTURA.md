# 🏗️ Arquitectura del Frontend Angular - MegaCable API

## 📁 Estructura de Carpetas Escalable

### 🎯 **Principios de Organización**
- **Feature-Based**: Organizado por funcionalidades de negocio
- **Lazy Loading**: Módulos cargados bajo demanda
- **Separation of Concerns**: Separación clara de responsabilidades
- **Reusabilidad**: Componentes y servicios reutilizables
- **Escalabilidad**: Estructura que soporta crecimiento

---

## 📂 **Estructura Detallada**

```
src/
├── app/
│   ├── core/                     # ⚡ Servicios singleton y configuración global
│   │   ├── services/             # Servicios únicos (AuthService, ConfigService)
│   │   ├── guards/               # Guards de rutas (AuthGuard, RoleGuard)
│   │   ├── interceptors/         # HTTP Interceptors (Auth, Error, Loading)
│   │   └── models/               # Interfaces y modelos de dominio
│   │
│   ├── shared/                   # 🔄 Componentes y utilidades compartidas
│   │   ├── components/           # Componentes UI reutilizables
│   │   │   ├── loading-spinner/
│   │   │   ├── confirmation-dialog/
│   │   │   ├── data-table/
│   │   │   └── notification/
│   │   ├── directives/           # Directivas personalizadas
│   │   ├── pipes/                # Pipes personalizados (currency, date)
│   │   └── utils/                # Funciones de utilidad
│   │
│   ├── features/                 # 🚀 Módulos de funcionalidades
│   │   ├── contratos/            # Gestión de contratos
│   │   │   ├── components/       # Componentes específicos de contratos
│   │   │   │   ├── contrato-card/
│   │   │   │   ├── contrato-form/
│   │   │   │   └── contrato-list/
│   │   │   ├── pages/            # Páginas/vistas principales
│   │   │   │   ├── contratos-list/
│   │   │   │   ├── contrato-detail/
│   │   │   │   └── contrato-create/
│   │   │   ├── services/         # Servicios específicos del módulo
│   │   │   │   └── contratos.service.ts
│   │   │   └── contratos.module.ts
│   │   │
│   │   ├── proyecciones/         # Módulo de proyecciones
│   │   │   ├── components/
│   │   │   │   ├── proyeccion-chart/
│   │   │   │   ├── proyeccion-summary/
│   │   │   │   └── proyeccion-table/
│   │   │   ├── pages/
│   │   │   │   ├── proyecciones-dashboard/
│   │   │   │   ├── proyeccion-detail/
│   │   │   │   └── proyeccion-create/
│   │   │   └── proyecciones.module.ts
│   │   │
│   │   └── dashboard/            # Dashboard principal
│   │       ├── components/
│   │       │   ├── stats-card/
│   │       │   ├── revenue-chart/
│   │       │   └── activity-feed/
│   │       ├── pages/
│   │       │   └── dashboard-main/
│   │       └── dashboard.module.ts
│   │
│   ├── layout/                   # 🏠 Componentes de layout
│   │   ├── components/
│   │   │   ├── header/
│   │   │   ├── sidebar/
│   │   │   ├── footer/
│   │   │   └── breadcrumb/
│   │   └── layout.module.ts
│   │
│   ├── app-routing.module.ts     # Rutas principales
│   ├── app.component.ts          # Componente raíz
│   └── app.module.ts             # Módulo raíz
│
├── assets/                       # 📦 Recursos estáticos
│   ├── images/                   # Imágenes y logos
│   ├── icons/                    # Iconos SVG
│   └── styles/                   # Estilos globales SCSS
│       ├── _variables.scss
│       ├── _mixins.scss
│       └── _themes.scss
│
└── environments/                 # ⚙️ Configuración por ambiente
    ├── environment.ts
    └── environment.prod.ts
```

---

## 🔧 **Configuración de Módulos**

### **Core Module** (Singleton)
- Servicios únicos de la aplicación
- Configuración global
- Guards y interceptors
- Se importa solo en AppModule

### **Shared Module** 
- Componentes reutilizables
- Pipes y directivas comunes
- Se importa en feature modules

### **Feature Modules**
- Funcionalidades específicas
- Lazy loading habilitado
- Encapsulación de responsabilidades

---

## 📋 **Convenciones de Nomenclatura**

### **Archivos**
- `kebab-case` para nombres de archivos
- Sufijos descriptivos: `.component.ts`, `.service.ts`, `.module.ts`

### **Clases**
- `PascalCase` para clases
- Sufijos descriptivos: `Component`, `Service`, `Module`

### **Interfaces**
- Prefijo `I` opcional: `IContrato` o `Contrato`
- Sufijo descriptivo según contexto: `DTO`, `Model`, `Response`

---

## 🚀 **Beneficios de esta Arquitectura**

### ✅ **Escalabilidad**
- Fácil agregar nuevas features sin afectar existentes
- Lazy loading mejora performance inicial
- Separación clara facilita el mantenimiento

### ✅ **Reutilización**
- Componentes shared reutilizables
- Servicios core singleton
- Pipes y directivas comunes

### ✅ **Mantenibilidad**
- Estructura predecible
- Responsabilidades bien definidas
- Fácil localizar y modificar código

### ✅ **Testing**
- Módulos independientes facilitan testing
- Componentes aislados
- Servicios mockeable

### ✅ **Performance**
- Lazy loading de módulos
- Tree shaking automático
- Optimización de bundles

---

## 🔄 **Flujo de Desarrollo**

1. **Nueva Feature**: Crear módulo en `/features/`
2. **Componente Reutilizable**: Agregar en `/shared/components/`
3. **Servicio Global**: Agregar en `/core/services/`
4. **Layout Update**: Modificar en `/layout/components/`
5. **Assets**: Agregar en `/assets/` correspondiente

---

## 📚 **Próximos Pasos**

1. Configurar routing con lazy loading
2. Implementar servicios de API
3. Crear componentes base reutilizables
4. Configurar testing con Jasmine/Karma
5. Implementar PWA capabilities
6. Configurar CI/CD pipeline

---

**🎯 Esta estructura está diseñada para soportar un crecimiento significativo del proyecto manteniendo la calidad del código y la velocidad de desarrollo.**
