# Script de configuración para MegaCable Frontend Angular
# Para ejecutar: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# Luego: .\setup.ps1

Write-Host "🚀 Configurando MegaCable Frontend Angular..." -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# Verificar si Node.js está instalado
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js versión: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js no está instalado. Por favor instala Node.js 18+ antes de continuar." -ForegroundColor Red
    exit 1
}

# Verificar si npm está disponible
try {
    $npmVersion = npm --version
    Write-Host "✅ npm versión: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm no está disponible." -ForegroundColor Red
    exit 1
}

# Verificar/Instalar Angular CLI
try {
    $ngVersion = ng version 2>$null
    if ($ngVersion) {
        Write-Host "✅ Angular CLI ya está instalado" -ForegroundColor Green
    }
} catch {
    Write-Host "📦 Instalando Angular CLI..." -ForegroundColor Yellow
    npm install -g @angular/cli@17
}

Write-Host ""
Write-Host "📦 Instalando dependencias del proyecto..." -ForegroundColor Yellow
npm install

Write-Host ""
Write-Host "🔧 Verificando configuración..." -ForegroundColor Yellow

# Crear archivo de configuración de ambiente si no existe
$envPath = "src\environments"
$envFile = "$envPath\environment.ts"

if (!(Test-Path $envPath)) {
    New-Item -ItemType Directory -Path $envPath -Force | Out-Null
}

if (!(Test-Path $envFile)) {
    $envContent = @"
export const environment = {
  production: false,
  apiUrl: 'http://localhost:5011/api'
};
"@
    Set-Content -Path $envFile -Value $envContent
    Write-Host "✅ Archivo de configuración de ambiente creado" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎯 Configuración completada!" -ForegroundColor Green
Write-Host ""
Write-Host "Para iniciar el proyecto:" -ForegroundColor Cyan
Write-Host "  1. Asegúrate de que la API esté ejecutándose en http://localhost:5011" -ForegroundColor White
Write-Host "  2. Ejecuta: ng serve" -ForegroundColor White
Write-Host "  3. Abre http://localhost:4200 en tu navegador" -ForegroundColor White
Write-Host ""
Write-Host "Características disponibles:" -ForegroundColor Cyan
Write-Host "  ✅ Dashboard con estadísticas" -ForegroundColor White
Write-Host "  ✅ Lista de suscriptores con filtros y paginación" -ForegroundColor White
Write-Host "  ✅ Formulario de creación/edición de suscriptores" -ForegroundColor White
Write-Host "  ✅ Panel de pruebas API (migrado de frontend-test.html)" -ForegroundColor White
Write-Host "  ✅ Navegación completa con menús y footer" -ForegroundColor White
Write-Host "  ✅ Validaciones en tiempo real" -ForegroundColor White
Write-Host "  ✅ Diseño responsive con Bootstrap 5" -ForegroundColor White
Write-Host ""
Write-Host "🚀 ¡Listo para usar!" -ForegroundColor Green

# Preguntar si quiere iniciar el servidor de desarrollo
$respuesta = Read-Host "¿Deseas iniciar el servidor de desarrollo ahora? (y/n)"
if ($respuesta -eq "y" -or $respuesta -eq "Y" -or $respuesta -eq "yes") {
    Write-Host ""
    Write-Host "🌐 Iniciando servidor de desarrollo..." -ForegroundColor Yellow
    ng serve --open
}
