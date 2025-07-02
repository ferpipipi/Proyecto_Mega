import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SuscriptorService } from '../../services/suscriptor.service';
import { CrearSuscriptor, Suscriptor, EstadisticasSuscriptores } from '../../models/suscriptor.model';

@Component({
  selector: 'app-test-api',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="container-fluid py-4">
      <!-- Header -->
      <div class="row mb-4">
        <div class="col-12">
          <h1 class="h3 mb-3">
            <i class="fas fa-vials me-2 text-info"></i>
            Pruebas de API - MegaCable Suscriptores
          </h1>
          <p class="text-muted">Panel de pruebas para validar endpoints de la API</p>
        </div>
      </div>

      <!-- Estado de la API -->
      <div class="row mb-4">
        <div class="col-12">
          <div class="card">
            <div class="card-header bg-info text-white">
              <h5 class="card-title mb-0">
                <i class="fas fa-server me-2"></i>
                Estado de la API
              </h5>
            </div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-6">
                  <p><strong>URL de la API:</strong> http://localhost:5011/api/suscriptores</p>
                  <p><strong>Estado:</strong> 
                    <span class="badge bg-success ms-2" *ngIf="apiConectada">
                      <i class="fas fa-check-circle me-1"></i>
                      Conectada
                    </span>
                    <span class="badge bg-danger ms-2" *ngIf="!apiConectada && !cargandoEstado">
                      <i class="fas fa-times-circle me-1"></i>
                      Desconectada
                    </span>
                    <span class="badge bg-warning ms-2" *ngIf="cargandoEstado">
                      <i class="fas fa-spinner fa-spin me-1"></i>
                      Verificando...
                    </span>
                  </p>
                </div>
                <div class="col-md-6">
                  <button class="btn btn-outline-info" (click)="verificarEstado()" [disabled]="cargandoEstado">
                    <i class="fas fa-sync me-2"></i>
                    Verificar Estado
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Estadísticas -->
      <div class="row mb-4">
        <div class="col-md-6">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title mb-0">
                <i class="fas fa-chart-bar me-2"></i>
                Estadísticas Actuales
              </h5>
            </div>
            <div class="card-body">
              <div *ngIf="estadisticas">
                <h3 class="text-primary">{{ estadisticas.totalSuscriptores }}</h3>
                <p class="text-muted mb-2">Total de suscriptores registrados</p>
                <small class="text-muted">
                  <i class="fas fa-clock me-1"></i>
                  Última consulta: {{ estadisticas.fechaConsulta | date:'short' }}
                </small>
              </div>
              <div *ngIf="!estadisticas && !cargandoEstadisticas" class="text-center py-3">
                <button class="btn btn-primary" (click)="cargarEstadisticas()">
                  <i class="fas fa-chart-bar me-2"></i>
                  Cargar Estadísticas
                </button>
              </div>
              <div *ngIf="cargandoEstadisticas" class="text-center py-3">
                <div class="spinner-border spinner-border-sm me-2"></div>
                Cargando estadísticas...
              </div>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title mb-0">
                <i class="fas fa-list me-2"></i>
                Lista de Suscriptores
              </h5>
            </div>
            <div class="card-body">
              <button class="btn btn-outline-primary mb-3" (click)="cargarSuscriptores()" [disabled]="cargandoSuscriptores">
                <i class="fas fa-users me-2"></i>
                Cargar Lista (Primeros 5)
              </button>
              
              <div *ngIf="cargandoSuscriptores" class="text-center py-3">
                <div class="spinner-border spinner-border-sm me-2"></div>
                Cargando suscriptores...
              </div>
              
              <div *ngIf="suscriptores.length > 0" class="table-responsive">
                <table class="table table-sm">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Nombre</th>
                      <th>Correo</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr *ngFor="let suscriptor of suscriptores">
                      <td>{{ suscriptor.id }}</td>
                      <td>{{ suscriptor.nombre }}</td>
                      <td>{{ suscriptor.correo }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Crear Suscriptor -->
      <div class="row mb-4">
        <div class="col-12">
          <div class="card">
            <div class="card-header bg-success text-white">
              <h5 class="card-title mb-0">
                <i class="fas fa-user-plus me-2"></i>
                Prueba de Creación de Suscriptor
              </h5>
            </div>
            <div class="card-body">
              <form (ngSubmit)="crearSuscriptorPrueba()" #formulario="ngForm">
                <div class="row">
                  <div class="col-md-6">
                    <div class="mb-3">
                      <label class="form-label">Nombre *</label>
                      <input 
                        type="text" 
                        class="form-control" 
                        [(ngModel)]="nuevoSuscriptor.nombre"
                        name="nombre"
                        required
                        placeholder="Ejemplo: Juan Perez Lopez">
                    </div>
                    
                    <div class="mb-3">
                      <label class="form-label">Alias</label>
                      <input 
                        type="text" 
                        class="form-control" 
                        [(ngModel)]="nuevoSuscriptor.alias"
                        name="alias"
                        placeholder="Ejemplo: JuanP2025">
                    </div>
                    
                    <div class="mb-3">
                      <label class="form-label">Correo *</label>
                      <input 
                        type="email" 
                        class="form-control" 
                        [(ngModel)]="nuevoSuscriptor.correo"
                        name="correo"
                        required
                        placeholder="ejemplo@email.com">
                    </div>
                    
                    <div class="mb-3">
                      <label class="form-label">Celular</label>
                      <input 
                        type="text" 
                        class="form-control" 
                        [(ngModel)]="nuevoSuscriptor.celular"
                        name="celular"
                        placeholder="33-1234-5678">
                    </div>
                  </div>
                  
                  <div class="col-md-6">
                    <div class="mb-3">
                      <label class="form-label">Ciudad ID *</label>
                      <input 
                        type="number" 
                        class="form-control" 
                        [(ngModel)]="nuevoSuscriptor.ciudadId"
                        name="ciudadId"
                        required
                        placeholder="121">
                      <small class="form-text text-muted">ID válido: 121</small>
                    </div>
                    
                    <div class="mb-3">
                      <label class="form-label">Colonia ID *</label>
                      <input 
                        type="number" 
                        class="form-control" 
                        [(ngModel)]="nuevoSuscriptor.coloniaId"
                        name="coloniaId"
                        required
                        placeholder="5">
                      <small class="form-text text-muted">ID válido: 5</small>
                    </div>
                    
                    <div class="mb-3">
                      <label class="form-label">Estado</label>
                      <select 
                        class="form-control" 
                        [(ngModel)]="nuevoSuscriptor.estadosAbreviatura"
                        name="estado">
                        <option value="">Seleccionar...</option>
                        <option value="AGS">AGS - Aguascalientes</option>
                        <option value="BC">BC - Baja California</option>
                        <option value="BCS">BCS - Baja California Sur</option>
                        <option value="CAM">CAM - Campeche</option>
                        <option value="CHPS">CHPS - Chiapas</option>
                        <option value="CHIH">CHIH - Chihuahua</option>
                        <option value="COAH">COAH - Coahuila</option>
                        <option value="COL">COL - Colima</option>
                        <option value="CDMX">CDMX - Ciudad de México</option>
                        <option value="DGO">DGO - Durango</option>
                        <option value="GTO">GTO - Guanajuato</option>
                        <option value="GRO">GRO - Guerrero</option>
                        <option value="HGO">HGO - Hidalgo</option>
                        <option value="JAL">JAL - Jalisco</option>
                        <option value="MEX">MEX - México</option>
                        <option value="MICH">MICH - Michoacán</option>
                        <option value="MOR">MOR - Morelos</option>
                        <option value="NAY">NAY - Nayarit</option>
                        <option value="NL">NL - Nuevo León</option>
                        <option value="OAX">OAX - Oaxaca</option>
                        <option value="PUE">PUE - Puebla</option>
                        <option value="QRO">QRO - Querétaro</option>
                        <option value="QROO">QROO - Quintana Roo</option>
                        <option value="SLP">SLP - San Luis Potosí</option>
                        <option value="SIN">SIN - Sinaloa</option>
                        <option value="SON">SON - Sonora</option>
                        <option value="TAB">TAB - Tabasco</option>
                        <option value="TAMS">TAMS - Tamaulipas</option>
                        <option value="TLAX">TLAX - Tlaxcala</option>
                        <option value="VER">VER - Veracruz</option>
                        <option value="YUC">YUC - Yucatán</option>
                        <option value="ZAC">ZAC - Zacatecas</option>
                      </select>
                    </div>
                    
                    <div class="mb-3">
                      <label class="form-label">Tipo de Suscriptor</label>
                      <select 
                        class="form-control" 
                        [(ngModel)]="nuevoSuscriptor.tipoSuscriptorCodigo"
                        name="tipo">
                        <option value="">Seleccionar...</option>
                        <option value="RES">Residencial</option>
                        <option value="COM">Comercial</option>
                        <option value="EMP">Empresarial</option>
                      </select>
                    </div>
                  </div>
                </div>
                
                <div class="row">
                  <div class="col-12 d-flex gap-2">
                    <button 
                      type="submit" 
                      class="btn btn-success" 
                      [disabled]="!formulario.form.valid || creandoSuscriptor">
                      <i class="fas fa-save me-2"></i>
                      <span *ngIf="!creandoSuscriptor">Crear Suscriptor</span>
                      <span *ngIf="creandoSuscriptor">
                        <span class="spinner-border spinner-border-sm me-2"></span>
                        Creando...
                      </span>
                    </button>
                    
                    <button 
                      type="button" 
                      class="btn btn-secondary" 
                      (click)="generarDatosPrueba()">
                      <i class="fas fa-magic me-2"></i>
                      Datos de Prueba
                    </button>
                    
                    <button 
                      type="button" 
                      class="btn btn-outline-secondary" 
                      (click)="limpiarFormulario()">
                      <i class="fas fa-eraser me-2"></i>
                      Limpiar
                    </button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>

      <!-- Resultados -->
      <div class="row" *ngIf="resultados.length > 0">
        <div class="col-12">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title mb-0">
                <i class="fas fa-clipboard-list me-2"></i>
                Resultados de las Pruebas
              </h5>
            </div>
            <div class="card-body">
              <div *ngFor="let resultado of resultados" 
                   class="alert mb-2"
                   [ngClass]="{
                     'alert-success': resultado.tipo === 'success',
                     'alert-danger': resultado.tipo === 'error',
                     'alert-info': resultado.tipo === 'info'
                   }">
                <div class="d-flex align-items-start">
                  <div class="me-2">
                    <i class="fas fa-check-circle" *ngIf="resultado.tipo === 'success'"></i>
                    <i class="fas fa-times-circle" *ngIf="resultado.tipo === 'error'"></i>
                    <i class="fas fa-info-circle" *ngIf="resultado.tipo === 'info'"></i>
                  </div>
                  <div class="flex-grow-1">
                    <strong>{{ resultado.titulo }}</strong>
                    <p class="mb-1">{{ resultado.mensaje }}</p>
                    <small class="text-muted">{{ resultado.fecha | date:'short' }}</small>
                    <pre *ngIf="resultado.datos" class="mt-2 mb-0">{{ resultado.datos | json }}</pre>
                  </div>
                </div>
              </div>
              
              <button class="btn btn-outline-secondary btn-sm mt-2" (click)="limpiarResultados()">
                <i class="fas fa-trash me-2"></i>
                Limpiar Resultados
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  `
})
export class TestApiComponent implements OnInit {
  // Estado de la API
  apiConectada = false;
  cargandoEstado = false;

  // Estadísticas
  estadisticas: EstadisticasSuscriptores | null = null;
  cargandoEstadisticas = false;

  // Suscriptores
  suscriptores: Suscriptor[] = [];
  cargandoSuscriptores = false;

  // Formulario
  nuevoSuscriptor: CrearSuscriptor = {
    nombre: '',
    alias: '',
    correo: '',
    celular: '',
    ciudadId: 121,
    coloniaId: 5,
    estadosAbreviatura: 'JAL',
    tipoSuscriptorCodigo: 'RES'
  };
  creandoSuscriptor = false;

  // Resultados
  resultados: Array<{
    tipo: 'success' | 'error' | 'info';
    titulo: string;
    mensaje: string;
    fecha: Date;
    datos?: any;
  }> = [];

  constructor(private suscriptorService: SuscriptorService) {}

  ngOnInit() {
    this.verificarEstado();
  }

  verificarEstado() {
    this.cargandoEstado = true;
    this.suscriptorService.obtenerEstadisticas().subscribe({
      next: () => {
        this.apiConectada = true;
        this.cargandoEstado = false;
        this.agregarResultado('success', 'Conexión API', 'La API está disponible y respondiendo correctamente');
      },
      error: (error) => {
        this.apiConectada = false;
        this.cargandoEstado = false;
        this.agregarResultado('error', 'Error de Conexión', 'No se pudo conectar con la API: ' + error.message);
      }
    });
  }

  cargarEstadisticas() {
    this.cargandoEstadisticas = true;
    this.suscriptorService.obtenerEstadisticas().subscribe({
      next: (datos) => {
        this.estadisticas = datos;
        this.cargandoEstadisticas = false;
        this.agregarResultado('success', 'Estadísticas Cargadas', 
          `Total de suscriptores: ${datos.totalSuscriptores}`, datos);
      },
      error: (error) => {
        this.cargandoEstadisticas = false;
        this.agregarResultado('error', 'Error al Cargar Estadísticas', error.message);
      }
    });
  }

  cargarSuscriptores() {
    this.cargandoSuscriptores = true;
    this.suscriptorService.obtenerSuscriptores({ pagina: 1, tamanoPagina: 5 }).subscribe({
      next: (respuesta) => {
        this.suscriptores = respuesta.suscriptores;
        this.cargandoSuscriptores = false;
        this.agregarResultado('success', 'Suscriptores Cargados', 
          `Se cargaron ${respuesta.suscriptores.length} suscriptores`, respuesta);
      },
      error: (error) => {
        this.cargandoSuscriptores = false;
        this.agregarResultado('error', 'Error al Cargar Suscriptores', error.message);
      }
    });
  }

  crearSuscriptorPrueba() {
    this.creandoSuscriptor = true;
    this.suscriptorService.crearSuscriptor(this.nuevoSuscriptor).subscribe({
      next: (suscriptor) => {
        this.creandoSuscriptor = false;
        this.agregarResultado('success', 'Suscriptor Creado', 
          `Suscriptor "${suscriptor.nombre}" creado con ID: ${suscriptor.id}`, suscriptor);
        this.limpiarFormulario();
        // Actualizar estadísticas
        this.cargarEstadisticas();
      },
      error: (error) => {
        this.creandoSuscriptor = false;
        this.agregarResultado('error', 'Error al Crear Suscriptor', error.message || error);
      }
    });
  }

  generarDatosPrueba() {
    const timestamp = Date.now();
    this.nuevoSuscriptor = {
      nombre: `Prueba API ${new Date().toLocaleString()}`,
      alias: `ApiTest${timestamp}`,
      correo: `api.test.${timestamp}@ejemplo.com`,
      celular: '33-9999-0000',
      ciudadId: 121,
      coloniaId: 5,
      estadosAbreviatura: 'JAL',
      tipoSuscriptorCodigo: 'RES'
    };
  }

  limpiarFormulario() {
    this.nuevoSuscriptor = {
      nombre: '',
      alias: '',
      correo: '',
      celular: '',
      ciudadId: 121,
      coloniaId: 5,
      estadosAbreviatura: 'JAL',
      tipoSuscriptorCodigo: 'RES'
    };
  }

  agregarResultado(tipo: 'success' | 'error' | 'info', titulo: string, mensaje: string, datos?: any) {
    this.resultados.unshift({
      tipo,
      titulo,
      mensaje,
      fecha: new Date(),
      datos
    });
    
    // Mantener solo los últimos 10 resultados
    if (this.resultados.length > 10) {
      this.resultados = this.resultados.slice(0, 10);
    }
  }

  limpiarResultados() {
    this.resultados = [];
  }
}
