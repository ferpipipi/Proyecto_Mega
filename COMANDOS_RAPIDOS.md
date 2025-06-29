# ⚡ MegaCable API - Comandos Rápidos

## 🚀 Instalación Rápida (5 minutos)

```powershell
# 1. Clonar proyecto
git clone https://github.com/ferpipipi/Proyecto_Mega.git
cd Proyecto_Mega
git checkout ApiFull

# 2. Configurar y ejecutar
cd MegaCableApi
dotnet restore
dotnet build
dotnet run
```

## 🌐 Acceso Inmediato
- **API:** http://localhost:5011
- **Swagger:** http://localhost:5011/swagger

## 🧪 Pruebas Rápidas

### Validar Contrato
```powershell
Invoke-RestMethod -Uri "http://localhost:5011/api/Proyeccion/contrato/CTR-2025-001/validar" -Method GET
```

### Generar Proyección
```powershell
Invoke-RestMethod -Uri "http://localhost:5011/api/Proyeccion/contrato/CTR-2025-001?mesesFuturos=6" -Method GET
```

## 🎭 Contratos de Prueba Válidos
- CTR-2025-001, CTR-2025-002, CTR-2025-003
- CTR-2024-001, CTR-2024-002, CON-2025-001

## 🛑 Detener API
`Ctrl + C` en la terminal

---
💡 **Para instrucciones completas, ver:** `INSTRUCCIONES_INSTALACION.md`
