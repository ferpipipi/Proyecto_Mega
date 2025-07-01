import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, Router } from '@angular/router';
import { Observable } from 'rxjs';

/**
 * Guard para proteger rutas que requieren autenticación
 */
@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  
  constructor(private router: Router) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): Observable<boolean> | Promise<boolean> | boolean {
    
    // Aquí iría la lógica de verificación de autenticación
    const isAuthenticated = this.checkAuthentication();
    
    if (!isAuthenticated) {
      this.router.navigate(['/login']);
      return false;
    }
    
    return true;
  }

  private checkAuthentication(): boolean {
    // Implementar lógica de verificación de token/sesión
    // Por ejemplo: verificar si existe un token válido en localStorage
    const token = localStorage.getItem('authToken');
    return !!token; // Simplificado para el ejemplo
  }
}
