import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface ContratoValidacion {
  numeroContrato: string;
  valido?: boolean;
  esValido?: boolean;
  mensaje?: string;
  fechaValidacion: string;
}

export interface ProyeccionMensual {
  mesNombre: string;
  subtotalServicios: number;
  descuentosPromociones: number;
  impuestos: number;
  totalProyectado: number;
  promocionesActivas: string;
  promocionesVencen?: string;
  tieneAlertas: boolean;
  notas: string;
}

export interface ResumenEjecutivo {
  pagoMinimo: number;
  pagoMaximo: number;
  pagoPromedio: number;
  totalPeriodo: number;
  ahorrosTotales: number;
  porcentajeAhorroTotal: number;
}

export interface ProyeccionContrato {
  numeroContrato: string;
  mesesFuturos: number;
  exitoso: boolean;
  fechaGeneracion: string;
  mensaje: string;
  proyeccionesMensuales: ProyeccionMensual[];
  resumenEjecutivo: ResumenEjecutivo;
}

export interface SolicitudProyeccionMultiple {
  numeroContrato: string;
  mesesFuturos: number;
}

@Injectable({
  providedIn: 'root'
})
export class ProyeccionService {
  private readonly baseUrl = 'http://localhost:5011/api/Proyeccion';

  constructor(private http: HttpClient) { }

  /**
   * Valida si un contrato existe y es válido
   */
  validarContrato(numeroContrato: string): Observable<ContratoValidacion> {
    return this.http.get<ContratoValidacion>(
      `${this.baseUrl}/contrato/${numeroContrato}/validar`
    );
  }

  /**
   * Genera proyección de un contrato específico
   */
  generarProyeccion(numeroContrato: string, mesesFuturos: number): Observable<ProyeccionContrato> {
    const params = new HttpParams().set('mesesFuturos', mesesFuturos.toString());
    
    return this.http.get<ProyeccionContrato>(
      `${this.baseUrl}/contrato/${numeroContrato}`,
      { params }
    );
  }

  /**
   * Procesa múltiples proyecciones de contratos
   */
  generarProyeccionesMultiples(solicitudes: SolicitudProyeccionMultiple[]): Observable<ProyeccionContrato[]> {
    return this.http.post<ProyeccionContrato[]>(
      `${this.baseUrl}/contratos/multiple`,
      solicitudes
    );
  }

  /**
   * Verifica la conectividad con la API de proyecciones
   */
  verificarConexion(): Observable<ContratoValidacion> {
    return this.validarContrato('CTR-2025-001');
  }
}
