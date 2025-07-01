import { Injectable } from "@angular/core";
import { Observable, of } from 'rxjs';
import { environment } from '../../environments/environment.development';
import { HttpClient } from '@angular/common/http';

@Injectable({providedIn: 'root'})
export class DeudaService {
    private apiUrl = `${environment.apiURL}/api/Proyeccion`;

    constructor(private http: HttpClient) {}

    validarContrato(contratoId: string): Observable<any> {
        return this.http.get(`${this.apiUrl}/contrato/${contratoId}/validar`);
    }

    generarProyeccion(contratoId: string, mesesFuturos: number): Observable<any> {
        return this.http.get(
        `${this.apiUrl}/contrato/${contratoId}?mesesFuturos=${mesesFuturos}`
        );
    }

    generarProyeccionesMultiples(solicitudes: { numeroContrato: string; mesesFuturos: number }[]): Observable<any> {
        return this.http.post(`${this.apiUrl}/contratos/multiple`, solicitudes);
    }

    verificarConexion(): Observable<any> {
        return this.http.get(`${this.apiUrl}/contrato/CTR-2025-001/validar`);
    }

    obtenerSuscriptores(): Observable<string[]> {
        return this.http.get<string[]>(`${this.apiUrl}/suscriptores`);
    }
}

