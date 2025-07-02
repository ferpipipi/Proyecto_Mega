import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { SuscriptorService } from '../../services/suscriptor.service';
import { EstadisticasSuscriptores } from '../../models/suscriptor.model';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="container-fluid py-4">
      <!-- Header -->
      <div class="row mb-4">
        <div class="col-12">
          <h1 class="h3 mb-3">
            <i class="fas fa-chart-pie me-2 text-primary"></i>
            Dashboard - Gestión de Suscriptores
          </h1>
          <p class="text-muted">Panel de control para la gestión de suscriptores MegaCable</p>
        </div>
      </div>

      <!-- Estadísticas Cards -->
      <div class="row mb-4">
        <div class="col-md-3 mb-3">
          <div class="card bg-primary text-white">
            <div class="card-body">
              <div class="d-flex justify-content-between">
                <div>
                  <h4 class="card-title">{{ estadisticas?.totalSuscriptores || 0 }}</h4>
                  <p class="card-text">Total Suscriptores</p>
                </div>
                <div class="align-self-center">
                  <i class="fas fa-users fa-2x opacity-75"></i>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div class="col-md-3 mb-3">
          <div class="card bg-success text-white">
            <div class="card-body">
              <div class="d-flex justify-content-between">
                <div>
                  <h4 class="card-title">{{ nuevosHoy }}</h4>
                  <p class="card-text">Nuevos Hoy</p>
                </div>
                <div class="align-self-center">
                  <i class="fas fa-user-plus fa-2x opacity-75"></i>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div class="col-md-3 mb-3">
          <div class="card bg-info text-white">
            <div class="card-body">
              <div class="d-flex justify-content-between">
                <div>
                  <h4 class="card-title">{{ activos }}</h4>
                  <p class="card-text">Activos</p>
                </div>
                <div class="align-self-center">
                  <i class="fas fa-check-circle fa-2x opacity-75"></i>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div class="col-md-3 mb-3">
          <div class="card bg-warning text-white">
            <div class="card-body">
              <div class="d-flex justify-content-between">
                <div>
                  <h4 class="card-title">{{ pendientes }}</h4>
                  <p class="card-text">Pendientes</p>
                </div>
                <div class="align-self-center">
                  <i class="fas fa-clock fa-2x opacity-75"></i>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Acciones Rápidas -->
      <div class="row mb-4">
        <div class="col-12">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title mb-0">
                <i class="fas fa-bolt me-2"></i>
                Acciones Rápidas
              </h5>
            </div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-3 mb-3">
                  <a routerLink="/suscriptores/crear" class="btn btn-primary w-100">
                    <i class="fas fa-user-plus me-2"></i>
                    Crear Suscriptor
                  </a>
                </div>
                <div class="col-md-3 mb-3">
                  <a routerLink="/suscriptores" class="btn btn-outline-primary w-100">
                    <i class="fas fa-list me-2"></i>
                    Ver Todos
                  </a>
                </div>
                <div class="col-md-3 mb-3">
                  <a routerLink="/proyecciones" class="btn btn-outline-warning w-100">
                    <i class="fas fa-chart-line me-2"></i>
                    Proyecciones
                  </a>
                </div>
                <div class="col-md-3 mb-3">
                  <a routerLink="/test-api" class="btn btn-outline-info w-100">
                    <i class="fas fa-vials me-2"></i>
                    Pruebas API
                  </a>
                </div>
              </div>
              <div class="row">
                <div class="col-md-3 mb-3">
                  <button class="btn btn-outline-success w-100" (click)="actualizarEstadisticas()">
                    <i class="fas fa-sync me-2"></i>
                    Actualizar
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Estado de la API -->
      <div class="row">
        <div class="col-md-6 mb-4">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title mb-0">
                <i class="fas fa-server me-2"></i>
                Estado de la API
              </h5>
            </div>
            <div class="card-body">
              <div class="d-flex align-items-center" *ngIf="!cargando">
                <div class="me-3">
                  <span class="badge bg-success fs-6">
                    <i class="fas fa-check-circle me-1"></i>
                    Conectado
                  </span>
                </div>
                <div>
                  <small class="text-muted">
                    Última actualización: {{ estadisticas?.fechaConsulta | date:'short' }}
                  </small>
                </div>
              </div>
              <div *ngIf="cargando" class="text-center py-3">
                <div class="spinner-border spinner-border-sm me-2" role="status"></div>
                Verificando conexión...
              </div>
            </div>
          </div>
        </div>
        
        <div class="col-md-6 mb-4">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title mb-0">
                <i class="fas fa-info-circle me-2"></i>
                Información del Sistema
              </h5>
            </div>
            <div class="card-body">
              <ul class="list-unstyled mb-0">
                <li><strong>Frontend:</strong> Angular 17</li>
                <li><strong>Backend:</strong> ASP.NET Core</li>
                <li><strong>Base de datos:</strong> SQL Server</li>
                <li><strong>API URL:</strong> http://localhost:49991</li>
                <li><strong>Frontend URL:</strong> http://localhost:4201</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  `
})
export class DashboardComponent implements OnInit {
  estadisticas: EstadisticasSuscriptores | null = null;
  cargando = true;
  nuevosHoy = 0;
  activos = 0;
  pendientes = 0;

  constructor(private suscriptorService: SuscriptorService) {}

  ngOnInit() {
    this.cargarEstadisticas();
  }

  cargarEstadisticas() {
    this.cargando = true;
    this.suscriptorService.obtenerEstadisticas().subscribe({
      next: (datos) => {
        this.estadisticas = datos;
        this.nuevosHoy = Math.floor(Math.random() * 10); // Simulado
        this.activos = datos.totalSuscriptores - Math.floor(Math.random() * 5);
        this.pendientes = Math.floor(Math.random() * 3);
        this.cargando = false;
      },
      error: (error) => {
        console.error('Error al cargar estadísticas:', error);
        this.cargando = false;
      }
    });
  }

  actualizarEstadisticas() {
    this.cargarEstadisticas();
  }
}
