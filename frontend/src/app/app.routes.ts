import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: '/dashboard',
    pathMatch: 'full'
  },
  {
    path: 'dashboard',
    loadComponent: () => import('./components/dashboard/dashboard.component').then(m => m.DashboardComponent)
  },
  {
    path: 'suscriptores',
    loadComponent: () => import('./components/suscriptores-lista/suscriptores-lista.component').then(m => m.SuscriptoresListaComponent)
  },
  {
    path: 'suscriptores/crear',
    loadComponent: () => import('./components/suscriptor-form/suscriptor-form.component').then(m => m.SuscriptorFormComponent)
  },
  {
    path: 'suscriptores/editar/:id',
    loadComponent: () => import('./components/suscriptor-form/suscriptor-form.component').then(m => m.SuscriptorFormComponent)
  },
  {
    path: 'test-api',
    loadComponent: () => import('./components/test-api/test-api.component').then(m => m.TestApiComponent)
  },
  {
    path: 'proyecciones',
    loadComponent: () => import('./components/proyecciones/proyecciones.component').then(m => m.ProyeccionesComponent)
  },
  {
    path: '**',
    redirectTo: '/dashboard'
  }
];
