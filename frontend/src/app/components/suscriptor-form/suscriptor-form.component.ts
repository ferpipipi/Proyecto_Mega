import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { SuscriptorService } from '../../services/suscriptor.service';
import { CrearSuscriptor, ActualizarSuscriptor, Suscriptor, TIPOS_SUSCRIPTOR, TipoSuscriptor } from '../../models/suscriptor.model';

@Component({
  selector: 'app-suscriptor-form',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule],
  template: `
    <div class="container py-4">
      <!-- Header -->
      <div class="row mb-4">
        <div class="col-12">
          <h1 class="h3 mb-3">
            <i class="fas fa-user-edit me-2 text-primary"></i>
            {{ esEdicion ? 'Editar Suscriptor' : 'Crear Suscriptor' }}
          </h1>
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><a routerLink="/dashboard">Dashboard</a></li>
              <li class="breadcrumb-item"><a routerLink="/suscriptores">Suscriptores</a></li>
              <li class="breadcrumb-item active">{{ esEdicion ? 'Editar' : 'Crear' }}</li>
            </ol>
          </nav>
        </div>
      </div>

      <!-- Formulario -->
      <div class="row">
        <div class="col-lg-8 mx-auto">
          <div class="card">
            <div class="card-header">
              <h5 class="card-title mb-0">
                <i class="fas fa-form me-2"></i>
                {{ esEdicion ? 'Editar información del suscriptor' : 'Información del nuevo suscriptor' }}
              </h5>
            </div>
            <div class="card-body">
              <form [formGroup]="formulario" (ngSubmit)="onSubmit()">
                <div class="row">
                  <!-- Información Personal -->
                  <div class="col-md-6">
                    <h6 class="text-muted mb-3">
                      <i class="fas fa-user me-1"></i>
                      Información Personal
                    </h6>
                    
                    <div class="mb-3">
                      <label class="form-label">Nombre Completo *</label>
                      <input 
                        type="text" 
                        class="form-control"
                        formControlName="nombre"
                        [class.is-invalid]="formulario.get('nombre')?.invalid && formulario.get('nombre')?.touched"
                        placeholder="Ejemplo: Juan Pérez López">
                      <div class="invalid-feedback" *ngIf="formulario.get('nombre')?.invalid && formulario.get('nombre')?.touched">
                        <div *ngIf="formulario.get('nombre')?.errors?.['required']">El nombre es requerido</div>
                        <div *ngIf="formulario.get('nombre')?.errors?.['maxlength']">El nombre no puede exceder 100 caracteres</div>
                      </div>
                    </div>

                    <div class="mb-3">
                      <label class="form-label">Alias</label>
                      <input 
                        type="text" 
                        class="form-control"
                        formControlName="alias"
                        placeholder="Ejemplo: JuanP2025">
                    </div>

                    <div class="mb-3">
                      <label class="form-label">Correo Electrónico *</label>
                      <input 
                        type="email" 
                        class="form-control"
                        formControlName="correo"
                        [class.is-invalid]="formulario.get('correo')?.invalid && formulario.get('correo')?.touched"
                        placeholder="ejemplo@email.com">
                      <div class="invalid-feedback" *ngIf="formulario.get('correo')?.invalid && formulario.get('correo')?.touched">
                        <div *ngIf="formulario.get('correo')?.errors?.['required']">El correo es requerido</div>
                        <div *ngIf="formulario.get('correo')?.errors?.['email']">Formato de correo inválido</div>
                        <div *ngIf="formulario.get('correo')?.errors?.['maxlength']">El correo no puede exceder 50 caracteres</div>
                      </div>
                      <div *ngIf="verificandoCorreo" class="form-text">
                        <i class="fas fa-spinner fa-spin me-1"></i>
                        Verificando disponibilidad...
                      </div>
                      <div *ngIf="correoExiste" class="form-text text-danger">
                        <i class="fas fa-exclamation-triangle me-1"></i>
                        Este correo ya está registrado
                      </div>
                    </div>

                    <div class="mb-3">
                      <label class="form-label">Teléfono Celular</label>
                      <input 
                        type="text" 
                        class="form-control"
                        formControlName="celular"
                        placeholder="33-1234-5678">
                    </div>
                  </div>

                  <!-- Información de Ubicación -->
                  <div class="col-md-6">
                    <h6 class="text-muted mb-3">
                      <i class="fas fa-map-marker-alt me-1"></i>
                      Información de Ubicación
                    </h6>

                    <div class="mb-3">
                      <label class="form-label">Ciudad ID *</label>
                      <input 
                        type="number" 
                        class="form-control"
                        formControlName="ciudadId"
                        [class.is-invalid]="formulario.get('ciudadId')?.invalid && formulario.get('ciudadId')?.touched"
                        placeholder="121">
                      <div class="form-text">ID válido conocido: 121</div>
                      <div class="invalid-feedback" *ngIf="formulario.get('ciudadId')?.invalid && formulario.get('ciudadId')?.touched">
                        <div *ngIf="formulario.get('ciudadId')?.errors?.['required']">La ciudad es requerida</div>
                        <div *ngIf="formulario.get('ciudadId')?.errors?.['min']">Debe ser mayor a 0</div>
                      </div>
                    </div>

                    <div class="mb-3">
                      <label class="form-label">Colonia ID *</label>
                      <input 
                        type="number" 
                        class="form-control"
                        formControlName="coloniaId"
                        [class.is-invalid]="formulario.get('coloniaId')?.invalid && formulario.get('coloniaId')?.touched"
                        placeholder="5">
                      <div class="form-text">ID válido conocido: 5</div>
                      <div class="invalid-feedback" *ngIf="formulario.get('coloniaId')?.invalid && formulario.get('coloniaId')?.touched">
                        <div *ngIf="formulario.get('coloniaId')?.errors?.['required']">La colonia es requerida</div>
                        <div *ngIf="formulario.get('coloniaId')?.errors?.['min']">Debe ser mayor a 0</div>
                      </div>
                    </div>

                    <div class="mb-3">
                      <label class="form-label">Estado</label>
                      <select class="form-select" formControlName="estadosAbreviatura">
                        <option value="">Seleccionar estado...</option>
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
                      <select class="form-select" formControlName="tipoSuscriptorCodigo">
                        <option value="">Seleccionar tipo...</option>
                        <option *ngFor="let tipo of tiposSuscriptor" [value]="tipo.codigo">
                          {{ tipo.codigo }} - {{ tipo.descripcion }}
                        </option>
                        <!-- Fallback si no hay tipos detallados cargados -->
                        <ng-container *ngIf="tiposSuscriptor.length === 0">
                          <option value="RES">RES - Residencial</option>
                          <option value="EMP">EMP - Empresa</option>
                          <option value="EMPL">EMPL - Empleado</option>
                          <option value="AC">AC - Asociación Civil</option>
                          <option value="GOB">GOB - Gobierno</option>
                          <option value="ESC">ESC - Escuela</option>
                          <option value="CARIDAD">CARIDAD - Caridad</option>
                          <option value="INTERNO">INTERNO - Interno</option>
                          <option value="COMERCIAL">COMERCIAL - Comercial</option>
                          <option value="INDUSTRIAL">INDUSTRIAL - Industrial</option>
                          <option value="PUBLICO">PUBLICO - Sector Público</option>
                          <option value="EDUCATIVO">EDUCATIVO - Educativo</option>
                          <option value="SALUD">SALUD - Sector Salud</option>
                          <option value="ONG">ONG - Organización No Gubernamental</option>
                          <option value="TEMPORAL">TEMPORAL - Suscriptor Temporal</option>
                          <option value="PREMIUM">PREMIUM - Suscriptor Premium</option>
                          <option value="CORPORATIVO">CORPORATIVO - Corporativo</option>
                        </ng-container>
                      </select>
                    </div>
                  </div>
                </div>

                <!-- Botones -->
                <div class="row mt-4">
                  <div class="col-12">
                    <div class="d-flex gap-2">
                      <button 
                        type="submit" 
                        class="btn btn-primary"
                        [disabled]="formulario.invalid || guardando || correoExiste">
                        <i class="fas fa-save me-2"></i>
                        <span *ngIf="!guardando">{{ esEdicion ? 'Actualizar' : 'Crear' }} Suscriptor</span>
                        <span *ngIf="guardando">
                          <span class="spinner-border spinner-border-sm me-2"></span>
                          {{ esEdicion ? 'Actualizando...' : 'Creando...' }}
                        </span>
                      </button>
                      
                      <button 
                        type="button" 
                        class="btn btn-secondary"
                        (click)="cancelar()">
                        <i class="fas fa-times me-2"></i>
                        Cancelar
                      </button>
                      
                      <button 
                        type="button" 
                        class="btn btn-outline-info"
                        (click)="generarDatosPrueba()"
                        *ngIf="!esEdicion">
                        <i class="fas fa-magic me-2"></i>
                        Datos de Prueba
                      </button>
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>

      <!-- Mensaje de éxito/error -->
      <div class="row mt-3" *ngIf="mensaje">
        <div class="col-lg-8 mx-auto">
          <div class="alert alert-dismissible fade show"
               [ngClass]="{
                 'alert-success': mensaje.tipo === 'success',
                 'alert-danger': mensaje.tipo === 'error'
               }">
            <i class="fas fa-check-circle me-2" *ngIf="mensaje.tipo === 'success'"></i>
            <i class="fas fa-exclamation-circle me-2" *ngIf="mensaje.tipo === 'error'"></i>
            {{ mensaje.texto }}
            <button type="button" class="btn-close" (click)="mensaje = null"></button>
          </div>
        </div>
      </div>
    </div>
  `
})
export class SuscriptorFormComponent implements OnInit {
  formulario!: FormGroup;
  esEdicion = false;
  suscriptorId?: number;
  guardando = false;
  verificandoCorreo = false;
  correoExiste = false;
  mensaje: { tipo: 'success' | 'error', texto: string } | null = null;
  tiposSuscriptor: TipoSuscriptor[] = [];
  tiposSuscriptorSimples: string[] = [...TIPOS_SUSCRIPTOR];

  constructor(
    private fb: FormBuilder,
    private suscriptorService: SuscriptorService,
    private router: Router,
    private route: ActivatedRoute
  ) {
    this.crearFormulario();
  }

  ngOnInit() {
    this.cargarTiposSuscriptor();
    
    this.route.params.subscribe(params => {
      if (params['id']) {
        this.esEdicion = true;
        this.suscriptorId = +params['id'];
        this.cargarSuscriptor();
      }
    });

    // Verificar correo cuando cambie
    this.formulario.get('correo')?.valueChanges.subscribe(correo => {
      if (correo && this.formulario.get('correo')?.valid) {
        this.verificarCorreo(correo);
      }
    });
  }

  crearFormulario() {
    this.formulario = this.fb.group({
      nombre: ['', [Validators.required, Validators.maxLength(100)]],
      alias: [''],
      correo: ['', [Validators.required, Validators.email, Validators.maxLength(50)]],
      celular: [''],
      ciudadId: [121, [Validators.required, Validators.min(1)]],
      coloniaId: [5, [Validators.required, Validators.min(1)]],
      estadosAbreviatura: ['JAL'],
      tipoSuscriptorCodigo: ['RES']
    });
  }

  cargarSuscriptor() {
    if (this.suscriptorId) {
      this.suscriptorService.obtenerSuscriptorPorId(this.suscriptorId).subscribe({
        next: (suscriptor: Suscriptor) => {
          this.formulario.patchValue({
            nombre: suscriptor.nombre,
            alias: suscriptor.alias,
            correo: suscriptor.correo,
            celular: suscriptor.celular,
            ciudadId: suscriptor.ciudadId,
            coloniaId: suscriptor.coloniaId,
            estadosAbreviatura: suscriptor.estadosAbreviatura,
            tipoSuscriptorCodigo: suscriptor.tipoSuscriptorCodigo
          });
        },
        error: (error: any) => {
          this.mostrarMensaje('error', 'Error al cargar el suscriptor: ' + error.message);
        }
      });
    }
  }

  verificarCorreo(correo: string) {
    this.verificandoCorreo = true;
    this.correoExiste = false;

    this.suscriptorService.verificarCorreo(correo).subscribe({
      next: (resultado) => {
        this.correoExiste = resultado.existe;
        this.verificandoCorreo = false;
      },
      error: () => {
        this.verificandoCorreo = false;
      }
    });
  }

  onSubmit() {
    if (this.formulario.valid && !this.correoExiste) {
      this.guardando = true;

      if (this.esEdicion && this.suscriptorId) {
        // Actualizar
        const datosActualizar: ActualizarSuscriptor = this.formulario.value;
        this.suscriptorService.actualizarSuscriptor(this.suscriptorId, datosActualizar).subscribe({
          next: () => {
            this.mostrarMensaje('success', 'Suscriptor actualizado exitosamente');
            this.guardando = false;
            setTimeout(() => this.router.navigate(['/suscriptores']), 2000);
          },
          error: (error: any) => {
            this.mostrarMensaje('error', 'Error al actualizar: ' + error.message);
            this.guardando = false;
          }
        });
      } else {
        // Crear
        const datosCrear: CrearSuscriptor = this.formulario.value;
        this.suscriptorService.crearSuscriptor(datosCrear).subscribe({
          next: (suscriptor: Suscriptor) => {
            this.mostrarMensaje('success', `Suscriptor creado exitosamente con ID: ${suscriptor.id}`);
            this.guardando = false;
            this.formulario.reset();
            this.crearFormulario();
          },
          error: (error: any) => {
            this.mostrarMensaje('error', 'Error al crear: ' + error.message);
            this.guardando = false;
          }
        });
      }
    }
  }

  generarDatosPrueba() {
    const timestamp = Date.now();
    this.formulario.patchValue({
      nombre: `Prueba Angular ${new Date().toLocaleString()}`,
      alias: `AngularTest${timestamp}`,
      correo: `angular.test.${timestamp}@ejemplo.com`,
      celular: '33-8888-9999',
      ciudadId: 121,
      coloniaId: 5,
      estadosAbreviatura: 'JAL',
      tipoSuscriptorCodigo: 'RES'
    });
  }

  cancelar() {
    this.router.navigate(['/suscriptores']);
  }

  cargarTiposSuscriptor() {
    // Intentar cargar desde el servidor, si falla usar la lista local
    this.suscriptorService.obtenerTiposSuscriptorDetallados().subscribe({
      next: (tipos) => {
        this.tiposSuscriptor = tipos;
      },
      error: (error) => {
        console.warn('No se pudieron cargar los tipos detallados, usando lista local:', error);
        // Usar la lista local como fallback
        this.tiposSuscriptor = this.tiposSuscriptorSimples.map(codigo => ({
          codigo,
          descripcion: this.obtenerDescripcionTipo(codigo),
          categoria: 'General',
          activo: true
        }));
      }
    });
  }

  obtenerDescripcionTipo(codigo: string): string {
    const descripciones: { [key: string]: string } = {
      'RES': 'Residencial',
      'EMP': 'Empresa',
      'EMPL': 'Empleado',
      'AC': 'Asociación Civil',
      'GOB': 'Gobierno',
      'ESC': 'Escuela',
      'CARIDAD': 'Caridad',
      'INTERNO': 'Interno',
      'COMERCIAL': 'Comercial',
      'INDUSTRIAL': 'Industrial',
      'PUBLICO': 'Sector Público',
      'EDUCATIVO': 'Educativo',
      'SALUD': 'Sector Salud',
      'ONG': 'Organización No Gubernamental',
      'TEMPORAL': 'Suscriptor Temporal',
      'PREMIUM': 'Suscriptor Premium',
      'CORPORATIVO': 'Corporativo'
    };
    return descripciones[codigo] || codigo;
  }

  mostrarMensaje(tipo: 'success' | 'error', texto: string) {
    this.mensaje = { tipo, texto };
    setTimeout(() => this.mensaje = null, 5000);
  }
}
