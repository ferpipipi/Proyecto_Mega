import { Injectable } from "@angular/core";
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment.development';
import { HttpClient } from '@angular/common/http';

@Injectable({providedIn: 'root'})
export class ConfiguradorService {
    private apiUrl = `${environment.apiURL}/api`;

    constructor(private http: HttpClient) {}

    // Métodos para Promociones
    obtenerPromociones(): Observable<any> {
        return this.http.get<any>(`${this.apiUrl}/promociones`);
    }

    crearPromocion(promocion: any): Observable<any> {
        return this.http.post(`${this.apiUrl}/promociones`, promocion);
    }

    actualizarPromocion(id: number, promocion: any): Observable<any> {
        return this.http.put(`${this.apiUrl}/promociones/${id}`, promocion);
    }

    eliminarPromocion(id: number): Observable<any> {
        return this.http.delete(`${this.apiUrl}/promociones/${id}`);
    }

    // Métodos para Ciudades
    obtenerCiudades(): Observable<any[]> {
        return this.http.get<any[]>(`${this.apiUrl}/ciudades`);
    }

    crearCiudad(nombre: string): Observable<any> {
        return this.http.post(`${this.apiUrl}/ciudades`, { nombre });
    }

    // Métodos para Colonias
    obtenerColonias(): Observable<any[]> {
        return this.http.get<any[]>(`${this.apiUrl}/colonias`);
    }

    crearColonia(nombre: string): Observable<any> {
        return this.http.post(`${this.apiUrl}/colonias`, { nombre });
    }

    // Métodos auxiliares
    obtenerMesesDisponibles(): number[] {
        return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    }
}