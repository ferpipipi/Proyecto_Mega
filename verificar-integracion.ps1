# Script de Verificación de Integración - MegaCable Dashboard
# Ejecutar desde la raíz del proyecto

Write-Host "🔍 Verificando Integración de Dashboard MegaCable..." -ForegroundColor Cyan
Write-Host ""

# Verificar estructura de archivos
Write-Host "📁 Verificando estructura de archivos..." -ForegroundColor Yellow

$archivosRequeridos = @(
    "frontend\src\app\app.routes.ts",
    "frontend\src\app\components\proyecciones\proyecciones.component.ts",
    "frontend\src\app\services\proyeccion.service.ts",
    "frontend\src\app\components\dashboard\dashboard.component.ts"
)

foreach ($archivo in $archivosRequeridos) {
    if (Test-Path $archivo) {
        Write-Host "✅ $archivo" -ForegroundColor Green
    } else {
        Write-Host "❌ $archivo - NO ENCONTRADO" -ForegroundColor Red
    }
}

Write-Host ""

# Verificar puertos
Write-Host "🌐 Verificando puertos..." -ForegroundColor Yellow

$puerto4200 = netstat -ano | findstr ":4200.*LISTENING"
$puerto5011 = netstat -ano | findstr ":5011.*LISTENING"

if ($puerto4200) {
    Write-Host "✅ Frontend corriendo en puerto 4200" -ForegroundColor Green
} else {
    Write-Host "❌ Frontend NO está corriendo en puerto 4200" -ForegroundColor Red
    Write-Host "   Ejecutar: cd frontend && ng serve --port 4200" -ForegroundColor Gray
}

if ($puerto5011) {
    Write-Host "✅ API corriendo en puerto 5011" -ForegroundColor Green
} else {
    Write-Host "❌ API NO está corriendo en puerto 5011" -ForegroundColor Red
    Write-Host "   Iniciar la API backend primero" -ForegroundColor Gray
}

Write-Host ""

# URLs de verificación
Write-Host "🔗 URLs para verificar:" -ForegroundColor Yellow
Write-Host "   Dashboard:    http://localhost:4200" -ForegroundColor Cyan
Write-Host "   Proyecciones: http://localhost:4200/proyecciones" -ForegroundColor Cyan
Write-Host "   API Test:     http://localhost:5011/api/Proyeccion/contrato/CTR-2025-001/validar" -ForegroundColor Cyan

Write-Host ""

# Verificar contenido de archivos clave
Write-Host "📋 Verificando configuración..." -ForegroundColor Yellow

if (Test-Path "frontend\src\app\services\proyeccion.service.ts") {
    $contenidoServicio = Get-Content "frontend\src\app\services\proyeccion.service.ts" -Raw
    if ($contenidoServicio -match "localhost:5011") {
        Write-Host "✅ Servicio configurado para puerto 5011" -ForegroundColor Green
    } else {
        Write-Host "❌ Servicio NO configurado correctamente" -ForegroundColor Red
    }
}

if (Test-Path "frontend\src\app\app.routes.ts") {
    $contenidoRutas = Get-Content "frontend\src\app\app.routes.ts" -Raw
    if ($contenidoRutas -match "proyecciones") {
        Write-Host "✅ Ruta de proyecciones configurada" -ForegroundColor Green
    } else {
        Write-Host "❌ Ruta de proyecciones NO configurada" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "🎉 Verificación completada!" -ForegroundColor Green
Write-Host ""
Write-Host "Para iniciar la aplicación:" -ForegroundColor White
Write-Host "1. cd frontend" -ForegroundColor Gray
Write-Host "2. ng serve --port 4200" -ForegroundColor Gray
Write-Host "3. Abrir http://localhost:4200" -ForegroundColor Gray
