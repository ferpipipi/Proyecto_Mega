#!/usr/bin/env pwsh
# Script de prueba para validar la API con base de datos real

Write-Host "🚀 Iniciando pruebas de validación de la API MegaCable" -ForegroundColor Green
Write-Host "=======================================================" -ForegroundColor Green

$API_BASE = "http://localhost:5011/api/Proyeccion"

function Test-ApiEndpoint {
    param(
        [string]$Url,
        [string]$Description,
        [string]$Method = "GET",
        [string]$Body = $null
    )
    
    Write-Host "`n🔍 Probando: $Description" -ForegroundColor Yellow
    Write-Host "URL: $Url" -ForegroundColor Gray
    
    try {
        $headers = @{
            "Content-Type" = "application/json"
        }
        
        if ($Body) {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Body $Body -Headers $headers
        } else {
            $response = Invoke-RestMethod -Uri $Url -Method $Method -Headers $headers
        }
        
        Write-Host "✅ Exitoso" -ForegroundColor Green
        Write-Host "Respuesta:" -ForegroundColor Cyan
        $response | ConvertTo-Json -Depth 10 | Write-Host
        return $true
    } catch {
        Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.Response) {
            Write-Host "Código de estado: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
        }
        return $false
    }
}

# Prueba 1: Validar contrato que existe y está activo
Write-Host "`n📋 PRUEBA 1: Validar contrato activo (CTR-2025-001)" -ForegroundColor Magenta
Test-ApiEndpoint -Url "$API_BASE/contrato/CTR-2025-001/validar" -Description "Validar CTR-2025-001 (debe ser válido)"

# Prueba 2: Validar contrato que existe pero está suspendido
Write-Host "`n📋 PRUEBA 2: Validar contrato suspendido (CTR-2025-003)" -ForegroundColor Magenta
Test-ApiEndpoint -Url "$API_BASE/contrato/CTR-2025-003/validar" -Description "Validar CTR-2025-003 (debe ser inválido - suspendido)"

# Prueba 3: Validar contrato que no existe
Write-Host "`n📋 PRUEBA 3: Validar contrato inexistente (CTR-2025-999)" -ForegroundColor Magenta
Test-ApiEndpoint -Url "$API_BASE/contrato/CTR-2025-999/validar" -Description "Validar CTR-2025-999 (debe ser inválido - no existe)"

# Prueba 4: Generar proyección para contrato válido
Write-Host "`n📋 PRUEBA 4: Generar proyección para contrato válido" -ForegroundColor Magenta
Test-ApiEndpoint -Url "$API_BASE/contrato/CTR-2025-001?mesesFuturos=3" -Description "Proyección CTR-2025-001 por 3 meses"

# Prueba 5: Generar proyección para contrato inválido
Write-Host "`n📋 PRUEBA 5: Generar proyección para contrato inválido" -ForegroundColor Magenta
Test-ApiEndpoint -Url "$API_BASE/contrato/CTR-2025-999?mesesFuturos=3" -Description "Proyección CTR-2025-999 (debe fallar)"

Write-Host "`n🎉 Pruebas completadas" -ForegroundColor Green
Write-Host "=====================" -ForegroundColor Green

Write-Host "`n📊 RESUMEN DE CONTRATOS EN LA BASE DE DATOS:" -ForegroundColor Cyan
Write-Host "✅ CTR-2025-001 - Activo (Juan Pérez García)" -ForegroundColor Green
Write-Host "✅ CTR-2025-002 - Activo (María González López)" -ForegroundColor Green
Write-Host "⏸️  CTR-2025-003 - Suspendido (Carlos Rodríguez Sánchez)" -ForegroundColor Yellow
Write-Host "✅ CTR-2024-001 - Activo (Ana Martínez Flores)" -ForegroundColor Green
Write-Host "❌ CTR-2024-002 - Inactivo (Roberto Silva Castro)" -ForegroundColor Red
