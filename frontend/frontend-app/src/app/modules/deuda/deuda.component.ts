import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms'; // Para ngModel
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

  constructor(private deudaService: DeudaService) {}

  ngOnInit(): void {
    this.cargarSuscriptores();
  }


  cargarSuscriptores() {
    this.deudaService.obtenerSuscriptores().subscribe({
      next: (data: any) => {
        console.log('Respuesta de la API:', data);
        this.suscriptores = data.data;  // guardamos todo el array de objetos
      },
      error: (error) => {
        console.error('Error al obtener suscriptores', error);
      }
    });
  }

  consultarDeuda() {
    const suscriptor = this.suscriptores.find(s => s.id === this.suscriptorSeleccionadoId);
    console.log('Consultando deuda para:', suscriptor);
    // Aquí puedes acceder a suscriptor.nombre, suscriptor.alias, etc.
  }

}
