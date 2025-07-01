import { Injectable } from "@angular/core";
import { Observable, of } from 'rxjs';
import { environment } from '../../environments/environment.development';
import { HttpClient } from '@angular/common/http';

@Injectable({providedIn: 'root'})
export class DeudaService {
    private apiUrl = `${environment.apiURL}/api`;

    constructor(private http: HttpClient) {}

    obtenerSuscriptores(): Observable<string[]> {
        return this.http.get<string[]>(`${this.apiUrl}/Suscriptores`);
    }

    calcularDeuda(suscriptorId: number): Observable<any> {
        return this.http.get<any>(`${this.apiUrl}/calcular/${suscriptorId}`);
    }
}

