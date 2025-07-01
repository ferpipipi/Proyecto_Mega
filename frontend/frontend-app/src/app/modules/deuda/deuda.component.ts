import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { DeudaService } from '../../services/deuda.service';
import { OnInit } from '@angular/core';

@Component({
  selector: 'app-deuda',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './deuda.component.html',
  styleUrl: './deuda.component.scss'
})
export class DeudaComponent implements OnInit {
  suscriptores: any[] = [];  
  suscriptorSeleccionadoId: number | null = null;
  deuda: any = null;
  cargando: boolean = false;
  error: string | null = null;

  constructor(private deudaService: DeudaService) {}

  ngOnInit(): void {
    this.cargarSuscriptores();
  }

  cargarSuscriptores() {
    this.deudaService.obtenerSuscriptores().subscribe({
      next: (data: any) => {
        this.suscriptores = data.data;
      },
      error: (error) => {
        console.error('Error al obtener suscriptores', error);
        this.error = 'Error al cargar suscriptores';
      }
    });
  }

  consultarDeuda() {
    if (!this.suscriptorSeleccionadoId) return;
    
    this.cargando = true;
    this.error = null;
    this.deuda = null;
    
    this.deudaService.calcularDeuda(this.suscriptorSeleccionadoId).subscribe({
      next: (data: any) => {
        this.deuda = data;
        this.cargando = false;
      },
      error: (error) => {
        console.error('Error al calcular deuda', error);
        this.error = 'Error al calcular la deuda';
        this.cargando = false;
      }
    });
  }
}
