# 🌐 Conectar Frontend con MegaCable API

## ⚙️ Configuración Previa

### 1. CORS habilitado en la API ✅
La API ya está configurada para permitir peticiones desde cualquier origen.

### 2. URL Base de la API
```
http://localhost:5011/api/Proyeccion
```

---

## 🟨 **JavaScript Vanilla / HTML**

### 📄 **Ejemplo HTML básico:**
```html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MegaCable API Client</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        .result { background: #f4f4f4; padding: 15px; margin: 10px 0; border-radius: 5px; }
        button { background: #007cba; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin: 5px; }
        button:hover { background: #005a87; }
        input { padding: 8px; margin: 5px; border: 1px solid #ddd; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 MegaCable API - Cliente Web</h1>
        
        <h2>🔍 Validar Contrato</h2>
        <input type="text" id="contratoValidar" placeholder="Ej: CTR-2025-001" value="CTR-2025-001">
        <button onclick="validarContrato()">Validar</button>
        
        <h2>📊 Generar Proyección</h2>
        <input type="text" id="contratoProyeccion" placeholder="Ej: CTR-2025-001" value="CTR-2025-001">
        <input type="number" id="mesesFuturos" placeholder="Meses" value="6" min="1" max="24">
        <button onclick="generarProyeccion()">Generar</button>
        
        <h2>📈 Proyecciones Múltiples</h2>
        <button onclick="proyeccionesMultiples()">Procesar Múltiples</button>
        
        <div id="resultado" class="result" style="display:none;">
            <h3>Resultado:</h3>
            <pre id="resultadoTexto"></pre>
        </div>
    </div>

    <script>
        const API_BASE = 'http://localhost:5011/api/Proyeccion';

        // Función para mostrar resultados
        function mostrarResultado(data) {
            document.getElementById('resultado').style.display = 'block';
            document.getElementById('resultadoTexto').textContent = JSON.stringify(data, null, 2);
        }

        // Validar contrato
        async function validarContrato() {
            const contrato = document.getElementById('contratoValidar').value;
            try {
                const response = await fetch(`${API_BASE}/contrato/${contrato}/validar`);
                const data = await response.json();
                mostrarResultado(data);
            } catch (error) {
                console.error('Error:', error);
                mostrarResultado({ error: 'Error al validar contrato' });
            }
        }

        // Generar proyección
        async function generarProyeccion() {
            const contrato = document.getElementById('contratoProyeccion').value;
            const meses = document.getElementById('mesesFuturos').value;
            try {
                const response = await fetch(`${API_BASE}/contrato/${contrato}?mesesFuturos=${meses}`);
                const data = await response.json();
                mostrarResultado(data);
            } catch (error) {
                console.error('Error:', error);
                mostrarResultado({ error: 'Error al generar proyección' });
            }
        }

        // Proyecciones múltiples
        async function proyeccionesMultiples() {
            const solicitudes = [
                { numeroContrato: "CTR-2025-001", mesesFuturos: 3 },
                { numeroContrato: "CTR-2025-002", mesesFuturos: 6 }
            ];

            try {
                const response = await fetch(`${API_BASE}/contratos/multiple`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(solicitudes)
                });
                const data = await response.json();
                mostrarResultado(data);
            } catch (error) {
                console.error('Error:', error);
                mostrarResultado({ error: 'Error al procesar múltiples proyecciones' });
            }
        }
    </script>
</body>
</html>
```

---

## ⚛️ **React.js**

### 📦 **Instalación de dependencias:**
```bash
npm install axios  # Para peticiones HTTP
```

### 🔧 **Servicio API (apiService.js):**
```javascript
import axios from 'axios';

const API_BASE_URL = 'http://localhost:5011/api/Proyeccion';

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const megaCableAPI = {
  // Validar contrato
  validarContrato: async (numeroContrato) => {
    const response = await apiClient.get(`/contrato/${numeroContrato}/validar`);
    return response.data;
  },

  // Generar proyección
  generarProyeccion: async (numeroContrato, mesesFuturos = 6) => {
    const response = await apiClient.get(`/contrato/${numeroContrato}?mesesFuturos=${mesesFuturos}`);
    return response.data;
  },

  // Proyecciones múltiples
  proyeccionesMultiples: async (solicitudes) => {
    const response = await apiClient.post('/contratos/multiple', solicitudes);
    return response.data;
  }
};
```

### 🎨 **Componente React (MegaCableClient.jsx):**
```jsx
import React, { useState } from 'react';
import { megaCableAPI } from './apiService';

const MegaCableClient = () => {
  const [contrato, setContrato] = useState('CTR-2025-001');
  const [meses, setMeses] = useState(6);
  const [resultado, setResultado] = useState(null);
  const [loading, setLoading] = useState(false);

  const validarContrato = async () => {
    setLoading(true);
    try {
      const data = await megaCableAPI.validarContrato(contrato);
      setResultado(data);
    } catch (error) {
      setResultado({ error: 'Error al validar contrato' });
    }
    setLoading(false);
  };

  const generarProyeccion = async () => {
    setLoading(true);
    try {
      const data = await megaCableAPI.generarProyeccion(contrato, meses);
      setResultado(data);
    } catch (error) {
      setResultado({ error: 'Error al generar proyección' });
    }
    setLoading(false);
  };

  const proyeccionesMultiples = async () => {
    setLoading(true);
    try {
      const solicitudes = [
        { numeroContrato: "CTR-2025-001", mesesFuturos: 3 },
        { numeroContrato: "CTR-2025-002", mesesFuturos: 6 }
      ];
      const data = await megaCableAPI.proyeccionesMultiples(solicitudes);
      setResultado(data);
    } catch (error) {
      setResultado({ error: 'Error al procesar múltiples proyecciones' });
    }
    setLoading(false);
  };

  return (
    <div style={{ maxWidth: '800px', margin: '0 auto', padding: '20px' }}>
      <h1>🚀 MegaCable API - Cliente React</h1>
      
      <div style={{ marginBottom: '20px' }}>
        <h2>🔍 Validar Contrato</h2>
        <input
          type="text"
          value={contrato}
          onChange={(e) => setContrato(e.target.value)}
          placeholder="Número de contrato"
          style={{ padding: '8px', margin: '5px', width: '200px' }}
        />
        <button onClick={validarContrato} disabled={loading}>
          {loading ? 'Validando...' : 'Validar'}
        </button>
      </div>

      <div style={{ marginBottom: '20px' }}>
        <h2>📊 Generar Proyección</h2>
        <input
          type="number"
          value={meses}
          onChange={(e) => setMeses(e.target.value)}
          placeholder="Meses futuros"
          min="1"
          max="24"
          style={{ padding: '8px', margin: '5px', width: '100px' }}
        />
        <button onClick={generarProyeccion} disabled={loading}>
          {loading ? 'Generando...' : 'Generar Proyección'}
        </button>
      </div>

      <div style={{ marginBottom: '20px' }}>
        <h2>📈 Proyecciones Múltiples</h2>
        <button onClick={proyeccionesMultiples} disabled={loading}>
          {loading ? 'Procesando...' : 'Procesar Múltiples'}
        </button>
      </div>

      {resultado && (
        <div style={{ 
          background: '#f4f4f4', 
          padding: '15px', 
          borderRadius: '5px',
          marginTop: '20px'
        }}>
          <h3>Resultado:</h3>
          <pre style={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}>
            {JSON.stringify(resultado, null, 2)}
          </pre>
        </div>
      )}
    </div>
  );
};

export default MegaCableClient;
```

---

## 🟢 **Vue.js**

### 📦 **Instalación:**
```bash
npm install axios
```

### 🎨 **Componente Vue (MegaCableClient.vue):**
```vue
<template>
  <div class="container">
    <h1>🚀 MegaCable API - Cliente Vue</h1>
    
    <div class="section">
      <h2>🔍 Validar Contrato</h2>
      <input 
        v-model="contrato" 
        placeholder="Número de contrato"
        class="input"
      />
      <button @click="validarContrato" :disabled="loading" class="button">
        {{ loading ? 'Validando...' : 'Validar' }}
      </button>
    </div>

    <div class="section">
      <h2>📊 Generar Proyección</h2>
      <input 
        v-model.number="meses" 
        type="number" 
        placeholder="Meses futuros"
        min="1" 
        max="24"
        class="input"
      />
      <button @click="generarProyeccion" :disabled="loading" class="button">
        {{ loading ? 'Generando...' : 'Generar Proyección' }}
      </button>
    </div>

    <div class="section">
      <h2>📈 Proyecciones Múltiples</h2>
      <button @click="proyeccionesMultiples" :disabled="loading" class="button">
        {{ loading ? 'Procesando...' : 'Procesar Múltiples' }}
      </button>
    </div>

    <div v-if="resultado" class="result">
      <h3>Resultado:</h3>
      <pre>{{ JSON.stringify(resultado, null, 2) }}</pre>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'MegaCableClient',
  data() {
    return {
      contrato: 'CTR-2025-001',
      meses: 6,
      resultado: null,
      loading: false,
      apiBaseUrl: 'http://localhost:5011/api/Proyeccion'
    };
  },
  methods: {
    async validarContrato() {
      this.loading = true;
      try {
        const response = await axios.get(`${this.apiBaseUrl}/contrato/${this.contrato}/validar`);
        this.resultado = response.data;
      } catch (error) {
        this.resultado = { error: 'Error al validar contrato' };
      }
      this.loading = false;
    },

    async generarProyeccion() {
      this.loading = true;
      try {
        const response = await axios.get(`${this.apiBaseUrl}/contrato/${this.contrato}?mesesFuturos=${this.meses}`);
        this.resultado = response.data;
      } catch (error) {
        this.resultado = { error: 'Error al generar proyección' };
      }
      this.loading = false;
    },

    async proyeccionesMultiples() {
      this.loading = true;
      try {
        const solicitudes = [
          { numeroContrato: "CTR-2025-001", mesesFuturos: 3 },
          { numeroContrato: "CTR-2025-002", mesesFuturos: 6 }
        ];
        const response = await axios.post(`${this.apiBaseUrl}/contratos/multiple`, solicitudes);
        this.resultado = response.data;
      } catch (error) {
        this.resultado = { error: 'Error al procesar múltiples proyecciones' };
      }
      this.loading = false;
    }
  }
};
</script>

<style scoped>
.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  font-family: Arial, sans-serif;
}

.section {
  margin-bottom: 20px;
}

.input {
  padding: 8px;
  margin: 5px;
  border: 1px solid #ddd;
  border-radius: 3px;
  width: 200px;
}

.button {
  background: #007cba;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin: 5px;
}

.button:hover {
  background: #005a87;
}

.button:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.result {
  background: #f4f4f4;
  padding: 15px;
  border-radius: 5px;
  margin-top: 20px;
}

pre {
  white-space: pre-wrap;
  word-break: break-word;
}
</style>
```

---

## 🔧 **Pasos para Implementar:**

### 1️⃣ **Compilar y ejecutar la API con CORS:**
```powershell
cd MegaCableApi
dotnet build
dotnet run
```

### 2️⃣ **Crear tu frontend:**
- Para **HTML/JS**: Guarda el código HTML en un archivo `.html` y ábrelo en el navegador
- Para **React**: Crea un nuevo proyecto con `npx create-react-app` e integra el código
- Para **Vue**: Crea un proyecto con `npm create vue@latest` e integra el componente

### 3️⃣ **Verificar que todo funciona:**
- API ejecutándose en: `http://localhost:5011`
- Frontend conectándose a la API correctamente
- CORS habilitado para permitir las peticiones

## 🚀 **¡Ahora ya puedes conectar cualquier frontend con tu MegaCable API!**

¿Te gustaría que te ayude a implementar algún frontend específico o necesitas más detalles sobre alguna tecnología?
