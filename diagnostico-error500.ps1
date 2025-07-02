# Prueba simple para diagnosticar el error 500
$baseUrl = "http://localhost:5011/api/suscriptores"

Write-Host "Diagnosticando el error 500..." -ForegroundColor Yellow

# Verificar conectividad
Write-Host "1. Verificando conectividad..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/estadisticas" -Method GET -UseBasicParsing
    Write-Host "✅ API responde con código: $($response.StatusCode)" -ForegroundColor Green
    
    $stats = $response.Content | ConvertFrom-Json
    Write-Host "Total suscriptores: $($stats.totalSuscriptores)" -ForegroundColor Green
} catch {
    Write-Host "❌ Error de conectividad: $($_.Exception.Message)" -ForegroundColor Red
    exit
}

# Probar creación con datos mínimos
Write-Host "`n2. Probando creación con datos mínimos..." -ForegroundColor Cyan
$timestamp = [int][double]::Parse((Get-Date -UFormat "%s"))
$jsonMinimo = @"
{
    "nombre": "Usuario Prueba $timestamp"
}
"@

Write-Host "JSON a enviar: $jsonMinimo" -ForegroundColor White

try {
    $response = Invoke-WebRequest -Uri $baseUrl -Method POST -Body $jsonMinimo -ContentType "application/json" -UseBasicParsing
    Write-Host "✅ Suscriptor creado con código: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Respuesta: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "❌ Error al crear (datos mínimos):" -ForegroundColor Red
    Write-Host "StatusCode: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    Write-Host "StatusDescription: $($_.Exception.Response.StatusDescription)" -ForegroundColor Red
    
    # Leer el contenido del error
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorContent = $reader.ReadToEnd()
        Write-Host "Contenido del error: $errorContent" -ForegroundColor Red
    }
}

# Probar creación con datos completos
Write-Host "`n3. Probando creación con datos completos..." -ForegroundColor Cyan
$jsonCompleto = @"
{
    "nombre": "Usuario Completo $timestamp",
    "alias": "UC$timestamp",
    "correo": "usuario$timestamp@test.com",
    "celular": "555-1234",
    "ciudadId": 121,
    "coloniaId": 5,
    "estadosAbreviatura": "JAL",
    "tipoSuscriptorCodigo": "RES"
}
"@

Write-Host "JSON a enviar: $jsonCompleto" -ForegroundColor White

try {
    $response = Invoke-WebRequest -Uri $baseUrl -Method POST -Body $jsonCompleto -ContentType "application/json" -UseBasicParsing
    Write-Host "✅ Suscriptor creado con código: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Respuesta: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "❌ Error al crear (datos completos):" -ForegroundColor Red
    Write-Host "StatusCode: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    Write-Host "StatusDescription: $($_.Exception.Response.StatusDescription)" -ForegroundColor Red
    
    # Leer el contenido del error
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorContent = $reader.ReadToEnd()
        Write-Host "Contenido del error: $errorContent" -ForegroundColor Red
    }
}

Write-Host "`nDiagnóstico completado." -ForegroundColor Yellow
