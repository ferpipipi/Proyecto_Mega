import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { 
  Suscriptor,
  CrearSuscriptor,
  ActualizarSuscriptor,
  FiltrosSuscriptor,
  RespuestaPaginada,
  EstadisticasSuscriptores,
  VerificarCorreo,
  TipoSuscriptor,
  TIPOS_SUSCRIPTOR
} from '../models/suscriptor.model';

@Injectable({
  providedIn: 'root'
})
export class SuscriptorService {
  private readonly baseUrl = 'http://localhost:5011/api/suscriptores';

  constructor(private http: HttpClient) {}

  /**
   * Obtiene lista paginada de suscriptores con filtros
   */
  obtenerSuscriptores(filtros?: FiltrosSuscriptor): Observable<RespuestaPaginada> {
    let params = new HttpParams();
    
    if (filtros) {
      if (filtros.nombre) params = params.set('nombre', filtros.nombre);
      if (filtros.correo) params = params.set('correo', filtros.correo);
      if (filtros.celular) params = params.set('celular', filtros.celular);
      if (filtros.ciudadId) params = params.set('ciudadId', filtros.ciudadId.toString());
      if (filtros.coloniaId) params = params.set('coloniaId', filtros.coloniaId.toString());
      if (filtros.estadosAbreviatura) params = params.set('estadosAbreviatura', filtros.estadosAbreviatura);
      if (filtros.tipoSuscriptorCodigo) params = params.set('tipoSuscriptorCodigo', filtros.tipoSuscriptorCodigo);
      if (filtros.pagina) params = params.set('pagina', filtros.pagina.toString());
      if (filtros.tamanoPagina) params = params.set('tamanoPagina', filtros.tamanoPagina.toString());
    }

    return this.http.get<RespuestaPaginada>(this.baseUrl, { params });
  }

  /**
   * Obtiene un suscriptor por ID
   */
  obtenerSuscriptorPorId(id: number): Observable<Suscriptor> {
    return this.http.get<Suscriptor>(`${this.baseUrl}/${id}`);
  }

  /**
   * Crea un nuevo suscriptor
   */
  crearSuscriptor(suscriptor: CrearSuscriptor): Observable<Suscriptor> {
    return this.http.post<Suscriptor>(this.baseUrl, suscriptor);
  }

  /**
   * Actualiza un suscriptor existente
   */
  actualizarSuscriptor(id: number, suscriptor: ActualizarSuscriptor): Observable<Suscriptor> {
    return this.http.put<Suscriptor>(`${this.baseUrl}/${id}`, suscriptor);
  }

  /**
   * Elimina un suscriptor
   */
  eliminarSuscriptor(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }

  /**
   * Busca suscriptores por término
   */
  buscarSuscriptores(termino: string): Observable<Suscriptor[]> {
    const params = new HttpParams().set('termino', termino);
    return this.http.get<Suscriptor[]>(`${this.baseUrl}/buscar`, { params });
  }

  /**
   * Verifica si un correo existe
   */
  verificarCorreo(correo: string): Observable<VerificarCorreo> {
    const params = new HttpParams().set('correo', correo);
    return this.http.get<VerificarCorreo>(`${this.baseUrl}/verificar-correo`, { params });
  }

  /**
   * Obtiene estadísticas de suscriptores
   */
  obtenerEstadisticas(): Observable<EstadisticasSuscriptores> {
    return this.http.get<EstadisticasSuscriptores>(`${this.baseUrl}/estadisticas`);
  }

  /**
   * Obtiene la lista de tipos de suscriptor válidos (códigos únicamente)
   */
  obtenerTiposSuscriptorValidos(): Observable<string[]> {
    return this.http.get<string[]>(`${this.baseUrl}/tipos-validos`);
  }

  /**
   * Obtiene la lista detallada de tipos de suscriptor
   */
  obtenerTiposSuscriptorDetallados(): Observable<TipoSuscriptor[]> {
    return this.http.get<TipoSuscriptor[]>(`${this.baseUrl}/tipos-detallados`);
  }

  /**
   * Obtiene los tipos de suscriptor localmente (sin llamada al servidor)
   */
  obtenerTiposSuscriptorLocales(): string[] {
    return [...TIPOS_SUSCRIPTOR];
  }
}
