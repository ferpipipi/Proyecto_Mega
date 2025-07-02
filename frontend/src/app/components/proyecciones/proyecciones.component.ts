import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { 
  ProyeccionService, 
  ContratoValidacion, 
  ProyeccionContrato, 
  SolicitudProyeccionMultiple 
} from '../../services/proyeccion.service';

interface EstadoConexion {
  conectado: boolean;
  mensaje: string;
  clase: string;
}

@Component({
  selector: 'app-proyecciones',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './proyecciones.component.html',
  styleUrls: ['./proyecciones.component.scss']
})
export class ProyeccionesComponent implements OnInit {
  // Estados de conexión y carga
  estadoConexion: EstadoConexion = {
    conectado: false,
    mensaje: '🔄 Verificando conexión con la API...',
    clase: 'status-info'
  };
  
  cargando = false;
  
  // Formularios
  formValidacion!: FormGroup;
  formProyeccion!: FormGroup;
  
  // Resultados
  resultadoValidacion: ContratoValidacion | null = null;
  resultadoProyeccion: ProyeccionContrato | null = null;
  resultadosMultiples: ProyeccionContrato[] = [];
  
  // Control de errores
  errorValidacion: string | null = null;
  errorProyeccion: string | null = null;
  errorMultiple: string | null = null;
  
  // Contratos de prueba
  contratosPrueba = [
    'CTR-2025-001',
    'CTR-2025-002', 
    'CTR-2025-003',
    'CTR-2025-004'
  ];

  constructor(
    private proyeccionService: ProyeccionService,
    private fb: FormBuilder
  ) {
    this.initForms();
  }

  ngOnInit(): void {
    this.verificarConexion();
  }

  private initForms(): void {
    this.formValidacion = this.fb.group({
      numeroContrato: ['CTR-2025-001', [Validators.required, Validators.pattern(/^[A-Z]{3}-\d{4}-\d{3}$/)]]
    });

    this.formProyeccion = this.fb.group({
      numeroContrato: ['CTR-2025-001', [Validators.required, Validators.pattern(/^[A-Z]{3}-\d{4}-\d{3}$/)]],
      mesesFuturos: [6, [Validators.required, Validators.min(1), Validators.max(24)]]
    });
  }

  /**
   * Verifica la conexión con la API
   */
  async verificarConexion(): Promise<void> {
    try {
      await this.proyeccionService.verificarConexion().toPromise();
      this.estadoConexion = {
        conectado: true,
        mensaje: '✅ Conexión exitosa con MegaCable API',
        clase: 'status-success'
      };
    } catch (error) {
      this.estadoConexion = {
        conectado: false,
        mensaje: '❌ No se puede conectar con la API. Asegúrate de que esté ejecutándose en http://localhost:5011',
        clase: 'status-error'
      };
    }
  }

  /**
   * Valida un contrato
   */
  async validarContrato(): Promise<void> {
    if (this.formValidacion.invalid) {
      return;
    }

    const numeroContrato = this.formValidacion.value.numeroContrato.trim();
    this.cargando = true;
    this.errorValidacion = null;
    this.resultadoValidacion = null;

    try {
      const result = await this.proyeccionService.validarContrato(numeroContrato).toPromise();
      this.resultadoValidacion = result || null;
    } catch (error: any) {
      this.errorValidacion = error.error?.mensaje || 'Error al validar contrato';
      console.error('Error en validación:', error);
    } finally {
      this.cargando = false;
    }
  }

  /**
   * Genera proyección de contrato
   */
  async generarProyeccion(): Promise<void> {
    if (this.formProyeccion.invalid) {
      return;
    }

    const { numeroContrato, mesesFuturos } = this.formProyeccion.value;
    this.cargando = true;
    this.errorProyeccion = null;
    this.resultadoProyeccion = null;

    try {
      const result = await this.proyeccionService.generarProyeccion(
        numeroContrato.trim(), 
        mesesFuturos
      ).toPromise();
      this.resultadoProyeccion = result || null;
    } catch (error: any) {
      this.errorProyeccion = error.error?.mensaje || 'Error al generar proyección';
      console.error('Error en proyección:', error);
    } finally {
      this.cargando = false;
    }
  }

  /**
   * Genera proyecciones múltiples
   */
  async generarProyeccionesMultiples(): Promise<void> {
    const solicitudes: SolicitudProyeccionMultiple[] = [
      { numeroContrato: "CTR-2025-001", mesesFuturos: 3 },
      { numeroContrato: "CTR-2025-002", mesesFuturos: 6 },
      { numeroContrato: "CTR-2025-003", mesesFuturos: 12 }
    ];

    this.cargando = true;
    this.errorMultiple = null;
    this.resultadosMultiples = [];

    try {
      this.resultadosMultiples = await this.proyeccionService.generarProyeccionesMultiples(solicitudes).toPromise() || [];
    } catch (error: any) {
      this.errorMultiple = error.error?.mensaje || 'Error al procesar múltiples proyecciones';
      console.error('Error en proyecciones múltiples:', error);
    } finally {
      this.cargando = false;
    }
  }

  /**
   * Carga un contrato de prueba en los formularios
   */
  probarContrato(numeroContrato: string): void {
    this.formValidacion.patchValue({ numeroContrato });
    this.formProyeccion.patchValue({ numeroContrato });
    this.validarContrato();
  }

  /**
   * Calcula el total proyectado de un contrato
   */
  calcularTotalProyectado(proyeccion: ProyeccionContrato): number {
    return proyeccion.resumenEjecutivo?.totalPeriodo || 0;
  }

  /**
   * Calcula el gran total de proyecciones múltiples
   */
  calcularGranTotal(): number {
    return this.resultadosMultiples.reduce((total, proyeccion) => 
      total + this.calcularTotalProyectado(proyeccion), 0
    );
  }

  /**
   * Formatea moneda mexicana
   */
  formatCurrency(amount: number): string {
    return new Intl.NumberFormat('es-MX', {
      style: 'currency',
      currency: 'MXN'
    }).format(amount);
  }

  /**
   * Formatea fecha
   */
  formatDate(dateString: string): string {
    return new Date(dateString).toLocaleDateString('es-MX');
  }

  /**
   * Verifica si un contrato es válido
   */
  esContratoValido(validacion: ContratoValidacion): boolean {
    return validacion.valido || validacion.esValido || false;
  }
}
