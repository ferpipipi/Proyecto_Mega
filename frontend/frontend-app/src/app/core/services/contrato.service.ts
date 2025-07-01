import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { 
  ValidacionContratoRequest, 
  ValidacionContratoResponse 
} from '../../models/contrato.model';

/**
 * Servicio para gestionar contratos
 */
@Injectable({
  providedIn: 'root'
})
export class ContratoService {
  private readonly apiUrl = `${environment.apiUrl}/api/proyeccion`;

  constructor(private http: HttpClient) {}

  /**
   * Valida si un contrato existe y es válido
   */
  validarContrato(numeroContrato: string): Observable<ValidacionContratoResponse> {
    const request: ValidacionContratoRequest = { numeroContrato };
    
    return this.http.post<ValidacionContratoResponse>(
      `${this.apiUrl}/validar-contrato`, 
      request
    );
  }

  /**
   * Obtiene información de un contrato específico
   */
  obtenerContrato(numeroContrato: string): Observable<any> {
    const params = new HttpParams().set('numeroContrato', numeroContrato);
    
    return this.http.get(`${this.apiUrl}/contrato`, { params });
  }

  /**
   * Busca contratos por criterios
   */
  buscarContratos(filtros: any): Observable<any> {
    let params = new HttpParams();
    
    if (filtros.searchTerm) {
      params = params.set('searchTerm', filtros.searchTerm);
    }
    if (filtros.estado) {
      params = params.set('estado', filtros.estado);
    }
    
    return this.http.get(`${this.apiUrl}/contratos`, { params });
  }
}
