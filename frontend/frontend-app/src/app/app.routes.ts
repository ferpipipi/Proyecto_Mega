import { Routes } from '@angular/router';

export const routes: Routes = [
    {
        path: '',
        loadComponent: () =>
        import('./modules/inicio/inicio.component').then(i => i.InicioComponent)
    },
    {
        path: "deuda",
        loadComponent: () =>
        import('./modules/deuda/deuda.component').then(i => i.DeudaComponent)
    },
    {
        path: "promocion",
        loadComponent: () =>
        import('./modules/promocion/promocion.component').then(i => i.PromocionesComponent)
    }
];
