import { Component, OnInit } from '@angular/core';
import { ProyeccionService } from '../../../core/services/proyeccion.service';
import { ProyeccionRequest, ProyeccionResponse } from '../../../core/models/proyeccion.model';

/**
 * Componente de ejemplo para generar proyecciones individuales
 */
@Component({
  selector: 'app-proyeccion-individual',
  templateUrl: './proyeccion-individual.component.html',
  styleUrls: ['./proyeccion-individual.component.css']
})
export class ProyeccionIndividualComponent implements OnInit {
  
  numeroContrato: string = '';
  fechaInicio: Date | null = null;
  fechaFin: Date | null = null;
  proyeccionResponse: ProyeccionResponse | null = null;
  loading: boolean = false;
  error: string = '';

  constructor(private proyeccionService: ProyeccionService) {}

  ngOnInit(): void {
    // Inicialización del componente
  }

  /**
   * Genera la proyección para el contrato especificado
   */
  generarProyeccion(): void {
    if (!this.numeroContrato.trim()) {
      this.error = 'Ingrese un número de contrato válido';
      return;
    }

    this.loading = true;
    this.error = '';
    this.proyeccionResponse = null;

    const request: ProyeccionRequest = {
      numeroContrato: this.numeroContrato.trim(),
      fechaInicio: this.fechaInicio || undefined,
      fechaFin: this.fechaFin || undefined
    };

    this.proyeccionService.generarProyeccionIndividual(request).subscribe({
      next: (response: ProyeccionResponse) => {
        this.proyeccionResponse = response;
        this.loading = false;
      },
      error: (error: any) => {
        this.error = 'Error al generar proyección: ' + error.message;
        this.loading = false;
      }
    });
  }

  /**
   * Exporta la proyección a Excel
   */
  exportarProyeccion(): void {
    if (!this.proyeccionResponse) {
      return;
    }

    const request = {
      numerosContrato: [this.numeroContrato],
      fechaInicio: this.fechaInicio || undefined,
      fechaFin: this.fechaFin || undefined
    };

    this.proyeccionService.exportarProyecciones(request).subscribe({
      next: (blob: Blob) => {
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `proyeccion_${this.numeroContrato}_${new Date().getTime()}.xlsx`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
      },
      error: (error: any) => {
        alert('Error al exportar: ' + error.message);
      }
    });
  }

  /**
   * Limpia el formulario
   */
  limpiar(): void {
    this.numeroContrato = '';
    this.fechaInicio = null;
    this.fechaFin = null;
    this.proyeccionResponse = null;
    this.error = '';
  }

  /**
   * Obtiene el total de la proyección
   */
  getTotalProyeccion(): number {
    if (!this.proyeccionResponse?.proyecciones) {
      return 0;
    }
    
    return this.proyeccionResponse.proyecciones.reduce(
      (total, proyeccion) => total + proyeccion.montoProyectado, 
      0
    );
  }
}
