import { Component } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive],
  template: `
    <div class="d-flex flex-column min-vh-100">
      <!-- Navbar -->
      <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
          <a class="navbar-brand" routerLink="/">
            <i class="fas fa-broadcast-tower me-2"></i>
            MegaCable
          </a>
          
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
          </button>
          
          <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
              <li class="nav-item">
                <a class="nav-link" routerLink="/dashboard" routerLinkActive="active">
                  <i class="fas fa-chart-pie me-1"></i>
                  Dashboard
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" routerLink="/suscriptores" routerLinkActive="active">
                  <i class="fas fa-users me-1"></i>
                  Suscriptores
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" routerLink="/suscriptores/crear" routerLinkActive="active">
                  <i class="fas fa-user-plus me-1"></i>
                  Crear Suscriptor
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" routerLink="/test-api" routerLinkActive="active">
                  <i class="fas fa-vials me-1"></i>
                  Pruebas API
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" routerLink="/proyecciones" routerLinkActive="active">
                  <i class="fas fa-chart-line me-1"></i>
                  Proyecciones
                </a>
              </li>
            </ul>
            
            <ul class="navbar-nav">
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                  <i class="fas fa-user-circle me-1"></i>
                  Usuario
                </a>
                <ul class="dropdown-menu">
                  <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Configuración</a></li>
                  <li><hr class="dropdown-divider"></li>
                  <li><a class="dropdown-item" href="#"><i class="fas fa-sign-out-alt me-2"></i>Cerrar Sesión</a></li>
                </ul>
              </li>
            </ul>
          </div>
        </div>
      </nav>

      <!-- Main Content -->
      <main class="flex-grow-1">
        <router-outlet></router-outlet>
      </main>

      <!-- Footer -->
      <footer class="footer py-4 mt-5">
        <div class="container">
          <div class="row">
            <div class="col-md-6">
              <h5 class="text-white">MegaCable API</h5>
              <p class="text-muted">Sistema de gestión de suscriptores</p>
            </div>
            <div class="col-md-6 text-md-end">
              <p class="text-muted mb-1">© 2025 MegaCable. Todos los derechos reservados.</p>
              <p class="text-muted mb-0">
                <small>
                  <i class="fas fa-code me-1"></i>
                  Desarrollado con Angular & ASP.NET Core
                </small>
              </p>
            </div>
          </div>
        </div>
      </footer>
    </div>
  `,
  styleUrls: []
})
export class AppComponent {
  title = 'MegaCable - Gestión de Suscriptores';
}
