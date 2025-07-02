import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { SuscriptorService } from '../../services/suscriptor.service';
import { Suscriptor, FiltrosSuscriptor, RespuestaPaginada } from '../../models/suscriptor.model';

@Component({
  selector: 'app-suscriptores-lista',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  template: `
    <div class="container-fluid py-4">
      <!-- Header -->
      <div class="row mb-4">
        <div class="col-12">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <h1 class="h3 mb-2">
                <i class="fas fa-users me-2 text-primary"></i>
                Gestión de Suscriptores
              </h1>
              <p class="text-muted mb-0">Lista completa de suscriptores registrados</p>
            </div>
            <div>
              <a routerLink="/suscriptores/crear" class="btn btn-primary">
                <i class="fas fa-user-plus me-2"></i>
                Nuevo Suscriptor
              </a>
            </div>
          </div>
        </div>
      </div>

      <!-- Filtros -->
      <div class="row mb-4">
        <div class="col-12">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title mb-0">
                <i class="fas fa-filter me-2"></i>
                Filtros de Búsqueda
              </h5>
            </div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-3 mb-3">
                  <label class="form-label">Nombre</label>
                  <input 
                    type="text" 
                    class="form-control" 
                    [(ngModel)]="filtros.nombre"
                    placeholder="Buscar por nombre"
                    (keyup.enter)="buscar()">
                </div>
                <div class="col-md-3 mb-3">
                  <label class="form-label">Correo</label>
                  <input 
                    type="email" 
                    class="form-control" 
                    [(ngModel)]="filtros.correo"
                    placeholder="Buscar por correo"
                    (keyup.enter)="buscar()">
                </div>
                <div class="col-md-2 mb-3">
                  <label class="form-label">Ciudad ID</label>
                  <input 
                    type="number" 
                    class="form-control" 
                    [(ngModel)]="filtros.ciudadId"
                    placeholder="ID"
                    (keyup.enter)="buscar()">
                </div>
                <div class="col-md-2 mb-3">
                  <label class="form-label">Estado</label>
                  <select class="form-select" [(ngModel)]="filtros.estadosAbreviatura" (change)="buscar()">
                    <option value="">Todos los estados</option>
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
                <div class="col-md-2 mb-3 d-flex align-items-end">
                  <div class="btn-group w-100">
                    <button class="btn btn-outline-primary" (click)="buscar()" [disabled]="cargando">
                      <i class="fas fa-search me-2"></i>
                      Buscar
                    </button>
                    <button class="btn btn-outline-secondary" (click)="limpiarFiltros()">
                      <i class="fas fa-eraser"></i>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Estadísticas rápidas -->
      <div class="row mb-4">
        <div class="col-md-3">
          <div class="card bg-info text-white">
            <div class="card-body text-center">
              <h4>{{ respuesta?.totalRegistros || 0 }}</h4>
              <p class="mb-0">Total Registros</p>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card bg-success text-white">
            <div class="card-body text-center">
              <h4>{{ respuesta?.totalPaginas || 0 }}</h4>
              <p class="mb-0">Total Páginas</p>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card bg-warning text-white">
            <div class="card-body text-center">
              <h4>{{ respuesta?.paginaActual || 0 }}</h4>
              <p class="mb-0">Página Actual</p>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card bg-primary text-white">
            <div class="card-body text-center">
              <h4>{{ respuesta?.tamanoPagina || 0 }}</h4>
              <p class="mb-0">Por Página</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Banner informativo de filtro activo -->
      <div class="row mb-3" *ngIf="filtros.estadosAbreviatura">
        <div class="col-12">
          <div class="alert alert-info border-0 shadow-sm">
            <div class="d-flex align-items-center">
              <i class="fas fa-info-circle me-3"></i>
              <div class="flex-grow-1">
                <strong>Filtro Activo:</strong> 
                Mostrando solo suscriptores del estado 
                <span class="badge bg-primary ms-2">{{ filtros.estadosAbreviatura }}</span>
                <span class="text-muted">- {{ obtenerNombreEstado(filtros.estadosAbreviatura) }}</span>
                <small class="d-block text-muted mt-1">
                  <i class="fas fa-info-circle me-1"></i>
                  La búsqueda se realiza por abreviatura del estado enviada a la API
                </small>
              </div>
              <button class="btn btn-outline-primary btn-sm" (click)="limpiarFiltroEstado()">
                <i class="fas fa-times me-1"></i>
                Quitar Filtro
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Tabla de suscriptores -->
      <div class="row">
        <div class="col-12">
          <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
              <h5 class="card-title mb-0">
                <i class="fas fa-table me-2"></i>
                Lista de Suscriptores
              </h5>
              <div class="d-flex align-items-center gap-2">
                <label class="me-2">Mostrar:</label>
                <select class="form-select form-select-sm" style="width: auto;" 
                        [(ngModel)]="filtros.tamanoPagina" (change)="cambiarTamanoPagina()">
                  <option value="5">5</option>
                  <option value="10">10</option>
                  <option value="25">25</option>
                  <option value="50">50</option>
                </select>
                <button class="btn btn-outline-success btn-sm" (click)="cargarSuscriptores()" [disabled]="cargando">
                  <i class="fas fa-sync me-1" [class.fa-spin]="cargando"></i>
                  Actualizar
                </button>
              </div>
            </div>
            <div class="card-body">
              <!-- Loading -->
              <div *ngIf="cargando" class="text-center py-4">
                <div class="spinner-border text-primary" role="status">
                  <span class="visually-hidden">Cargando...</span>
                </div>
                <p class="mt-2 text-muted">Cargando suscriptores...</p>
              </div>

              <!-- Tabla -->
              <div *ngIf="!cargando && suscriptores.length > 0" class="table-responsive">
                <table class="table table-hover">
                  <thead class="table-light">
                    <tr>
                      <th>ID</th>
                      <th>Nombre</th>
                      <th>Alias</th>
                      <th>Correo</th>
                      <th>Celular</th>
                      <th>Ciudad</th>
                      <th>Estado</th>
                      <th>Tipo</th>
                      <th>Acciones</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr *ngFor="let suscriptor of suscriptores">
                      <td>{{ suscriptor.id }}</td>
                      <td>
                        <strong>{{ suscriptor.nombre }}</strong>
                      </td>
                      <td>
                        <span class="badge bg-secondary" *ngIf="suscriptor.alias">{{ suscriptor.alias }}</span>
                        <span class="text-muted" *ngIf="!suscriptor.alias">-</span>
                      </td>
                      <td>
                        <a [href]="'mailto:' + suscriptor.correo" class="text-decoration-none">
                          {{ suscriptor.correo }}
                        </a>
                      </td>
                      <td>{{ suscriptor.celular || '-' }}</td>
                      <td>{{ suscriptor.ciudadId }}</td>
                      <td>
                        <span class="badge bg-info">{{ suscriptor.estadosAbreviatura || '-' }}</span>
                      </td>
                      <td>
                        <span class="badge" 
                              [ngClass]="{
                                'bg-success': suscriptor.tipoSuscriptorCodigo === 'RES',
                                'bg-warning': suscriptor.tipoSuscriptorCodigo === 'COM',
                                'bg-primary': suscriptor.tipoSuscriptorCodigo === 'EMP'
                              }">
                          {{ suscriptor.tipoSuscriptorCodigo || '-' }}
                        </span>
                      </td>
                      <td>
                        <div class="btn-group btn-group-sm">
                          <button class="btn btn-outline-info" 
                                  [routerLink]="['/suscriptores/editar', suscriptor.id]"
                                  title="Editar">
                            <i class="fas fa-edit"></i>
                          </button>
                          <button class="btn btn-outline-danger" 
                                  (click)="confirmarEliminacion(suscriptor)"
                                  title="Eliminar">
                            <i class="fas fa-trash"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- Sin resultados -->
              <div *ngIf="!cargando && suscriptores.length === 0" class="text-center py-5">
                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                <h4 class="text-muted">No se encontraron suscriptores</h4>
                <p class="text-muted">No hay suscriptores que coincidan con los filtros seleccionados</p>
                <button class="btn btn-primary" (click)="limpiarFiltros()">
                  <i class="fas fa-eraser me-2"></i>
                  Limpiar Filtros
                </button>
              </div>

              <!-- Paginación -->
              <div *ngIf="!cargando && respuesta && respuesta.totalPaginas > 1" class="d-flex justify-content-between align-items-center mt-4">
                <div>
                  <small class="text-muted">
                    Mostrando {{ (respuesta.paginaActual - 1) * respuesta.tamanoPagina + 1 }} - 
                    {{ Math.min(respuesta.paginaActual * respuesta.tamanoPagina, respuesta.totalRegistros) }} 
                    de {{ respuesta.totalRegistros }} registros
                  </small>
                </div>
                <nav>
                  <ul class="pagination pagination-sm mb-0">
                    <li class="page-item" [class.disabled]="respuesta.paginaActual <= 1">
                      <button class="page-link" (click)="irAPagina(respuesta.paginaActual - 1)">
                        <i class="fas fa-chevron-left"></i>
                      </button>
                    </li>
                    
                    <li class="page-item" 
                        *ngFor="let pagina of obtenerPaginas()" 
                        [class.active]="pagina === respuesta.paginaActual">
                      <button class="page-link" (click)="irAPagina(pagina)">{{ pagina }}</button>
                    </li>
                    
                    <li class="page-item" [class.disabled]="respuesta.paginaActual >= respuesta.totalPaginas">
                      <button class="page-link" (click)="irAPagina(respuesta.paginaActual + 1)">
                        <i class="fas fa-chevron-right"></i>
                      </button>
                    </li>
                  </ul>
                </nav>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Modal de confirmación de eliminación -->
      <div class="modal fade" id="modalEliminar" tabindex="-1" *ngIf="suscriptorAEliminar">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Confirmar Eliminación</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
              <p>¿Está seguro de que desea eliminar al suscriptor?</p>
              <div class="alert alert-warning">
                <strong>{{ suscriptorAEliminar.nombre }}</strong><br>
                <small>{{ suscriptorAEliminar.correo }}</small>
              </div>
              <p class="text-muted"><small>Esta acción no se puede deshacer.</small></p>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
              <button type="button" class="btn btn-danger" (click)="eliminarSuscriptor()" [disabled]="eliminando">
                <span *ngIf="!eliminando">
                  <i class="fas fa-trash me-2"></i>
                  Eliminar
                </span>
                <span *ngIf="eliminando">
                  <span class="spinner-border spinner-border-sm me-2"></span>
                  Eliminando...
                </span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  `
})
export class SuscriptoresListaComponent implements OnInit {
  suscriptores: Suscriptor[] = [];
  respuesta: RespuestaPaginada | null = null;
  cargando = false;
  eliminando = false;
  suscriptorAEliminar: Suscriptor | null = null;

  filtros: FiltrosSuscriptor = {
    nombre: '',
    correo: '',
    ciudadId: undefined,
    coloniaId: undefined,
    estadosAbreviatura: '',
    tipoSuscriptorCodigo: '',
    pagina: 1,
    tamanoPagina: 10
  };

  Math = Math; // Para usar Math.min en el template

  constructor(private suscriptorService: SuscriptorService) {}

  ngOnInit() {
    this.cargarSuscriptores();
  }

  cargarSuscriptores() {
    this.cargando = true;
    this.suscriptorService.obtenerSuscriptores(this.filtros).subscribe({
      next: (respuesta: RespuestaPaginada) => {
        this.respuesta = respuesta;
        this.suscriptores = respuesta.suscriptores;
        this.cargando = false;
      },
      error: (error: any) => {
        console.error('Error al cargar suscriptores:', error);
        this.cargando = false;
      }
    });
  }

  buscar() {
    this.filtros.pagina = 1; // Resetear a la primera página
    this.cargarSuscriptores();
  }

  limpiarFiltros() {
    this.filtros = {
      nombre: '',
      correo: '',
      ciudadId: undefined,
      coloniaId: undefined,
      estadosAbreviatura: '',
      tipoSuscriptorCodigo: '',
      pagina: 1,
      tamanoPagina: 10
    };
    this.cargarSuscriptores();
  }

  limpiarFiltroEstado() {
    this.filtros.estadosAbreviatura = '';
    this.filtros.pagina = 1;
    this.cargarSuscriptores();
  }

  obtenerNombreEstado(abreviatura: string): string {
    const estados: { [key: string]: string } = {
      'AGS': 'Aguascalientes',
      'BC': 'Baja California',
      'BCS': 'Baja California Sur',
      'CAM': 'Campeche',
      'CHPS': 'Chiapas',
      'CHIH': 'Chihuahua',
      'COAH': 'Coahuila',
      'COL': 'Colima',
      'CDMX': 'Ciudad de México',
      'DGO': 'Durango',
      'GTO': 'Guanajuato',
      'GRO': 'Guerrero',
      'HGO': 'Hidalgo',
      'JAL': 'Jalisco',
      'MEX': 'México',
      'MICH': 'Michoacán',
      'MOR': 'Morelos',
      'NAY': 'Nayarit',
      'NL': 'Nuevo León',
      'OAX': 'Oaxaca',
      'PUE': 'Puebla',
      'QRO': 'Querétaro',
      'QROO': 'Quintana Roo',
      'SLP': 'San Luis Potosí',
      'SIN': 'Sinaloa',
      'SON': 'Sonora',
      'TAB': 'Tabasco',
      'TAMS': 'Tamaulipas',
      'TLAX': 'Tlaxcala',
      'VER': 'Veracruz',
      'YUC': 'Yucatán',
      'ZAC': 'Zacatecas'
    };
    return estados[abreviatura] || abreviatura;
  }

  cambiarTamanoPagina() {
    this.filtros.pagina = 1;
    this.cargarSuscriptores();
  }

  irAPagina(pagina: number) {
    if (pagina >= 1 && this.respuesta && pagina <= this.respuesta.totalPaginas) {
      this.filtros.pagina = pagina;
      this.cargarSuscriptores();
    }
  }

  obtenerPaginas(): number[] {
    if (!this.respuesta) return [];
    
    const paginas: number[] = [];
    const totalPaginas = this.respuesta.totalPaginas;
    const paginaActual = this.respuesta.paginaActual;
    
    // Mostrar máximo 5 páginas
    let inicio = Math.max(1, paginaActual - 2);
    let fin = Math.min(totalPaginas, inicio + 4);
    
    // Ajustar inicio si estamos cerca del final
    if (fin - inicio < 4) {
      inicio = Math.max(1, fin - 4);
    }
    
    for (let i = inicio; i <= fin; i++) {
      paginas.push(i);
    }
    
    return paginas;
  }

  confirmarEliminacion(suscriptor: Suscriptor) {
    this.suscriptorAEliminar = suscriptor;
    // Aquí podrías usar Bootstrap modal programáticamente
    // Por simplicidad, usamos confirm
    if (confirm(`¿Está seguro de que desea eliminar a ${suscriptor.nombre}?`)) {
      this.eliminarSuscriptor();
    }
  }

  eliminarSuscriptor() {
    if (this.suscriptorAEliminar?.id) {
      this.eliminando = true;
      this.suscriptorService.eliminarSuscriptor(this.suscriptorAEliminar.id).subscribe({
        next: () => {
          this.eliminando = false;
          this.suscriptorAEliminar = null;
          this.cargarSuscriptores(); // Recargar la lista
        },
        error: (error: any) => {
          console.error('Error al eliminar suscriptor:', error);
          this.eliminando = false;
        }
      });
    }
  }
}
