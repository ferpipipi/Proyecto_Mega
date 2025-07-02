#!/bin/bash

echo "🚀 Configurando MegaCable Frontend Angular..."
echo "============================================="

# Verificar si Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no está instalado. Por favor instala Node.js 18+ antes de continuar."
    exit 1
fi

echo "✅ Node.js versión: $(node --version)"

# Verificar si npm está disponible
if ! command -v npm &> /dev/null; then
    echo "❌ npm no está disponible."
    exit 1
fi

echo "✅ npm versión: $(npm --version)"

# Instalar Angular CLI si no está instalado
if ! command -v ng &> /dev/null; then
    echo "📦 Instalando Angular CLI..."
    npm install -g @angular/cli@17
else
    echo "✅ Angular CLI versión: $(ng version --json | grep -o '"version":"[^"]*' | grep -o '[^"]*$')"
fi

echo ""
echo "📦 Instalando dependencias del proyecto..."
npm install

echo ""
echo "🔧 Verificando configuración..."

# Crear archivo de configuración de ambiente si no existe
if [ ! -f "src/environments/environment.ts" ]; then
    mkdir -p src/environments
    cat > src/environments/environment.ts << EOF
export const environment = {
  production: false,
  apiUrl: 'http://localhost:5011/api'
};
EOF
    echo "✅ Archivo de configuración de ambiente creado"
fi

echo ""
echo "🎯 Configuración completada!"
echo ""
echo "Para iniciar el proyecto:"
echo "  1. Asegúrate de que la API esté ejecutándose en http://localhost:5011"
echo "  2. Ejecuta: ng serve"
echo "  3. Abre http://localhost:4200 en tu navegador"
echo ""
echo "Características disponibles:"
echo "  ✅ Dashboard con estadísticas"
echo "  ✅ Lista de suscriptores con filtros y paginación"
echo "  ✅ Formulario de creación/edición de suscriptores"
echo "  ✅ Panel de pruebas API (migrado de frontend-test.html)"
echo "  ✅ Navegación completa con menús y footer"
echo "  ✅ Validaciones en tiempo real"
echo "  ✅ Diseño responsive con Bootstrap 5"
echo ""
echo "🚀 ¡Listo para usar!"
