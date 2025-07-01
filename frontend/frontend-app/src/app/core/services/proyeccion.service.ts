import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { 
  ProyeccionRequest, 
  ProyeccionMultipleRequest, 
  ProyeccionResponse 
} from '../../models/proyeccion.model';

/**
 * Servicio para gestionar proyecciones financieras
 */
@Injectable({
  providedIn: 'root'
})
export class ProyeccionService {
  private readonly apiUrl = `${environment.apiUrl}/api/proyeccion`;

  constructor(private http: HttpClient) {}

  /**
   * Genera proyección para un contrato individual
   */
  generarProyeccionIndividual(request: ProyeccionRequest): Observable<ProyeccionResponse> {
    return this.http.post<ProyeccionResponse>(
      `${this.apiUrl}/proyeccion-individual`, 
      request
    );
  }

  /**
   * Genera proyección para múltiples contratos
   */
  generarProyeccionMultiple(request: ProyeccionMultipleRequest): Observable<ProyeccionResponse> {
    return this.http.post<ProyeccionResponse>(
      `${this.apiUrl}/proyeccion-multiple`, 
      request
    );
  }

  /**
   * Obtiene histórico de proyecciones
   */
  obtenerHistoricoProyecciones(numeroContrato?: string): Observable<any> {
    let url = `${this.apiUrl}/historico-proyecciones`;
    
    if (numeroContrato) {
      url += `?numeroContrato=${numeroContrato}`;
    }
    
    return this.http.get(url);
  }

  /**
   * Exporta proyecciones a Excel
   */
  exportarProyecciones(request: ProyeccionMultipleRequest): Observable<Blob> {
    return this.http.post(
      `${this.apiUrl}/exportar-proyecciones`, 
      request,
      { 
        responseType: 'blob',
        headers: { 'Accept': 'application/vnd.ms-excel' }
      }
    );
  }
}
