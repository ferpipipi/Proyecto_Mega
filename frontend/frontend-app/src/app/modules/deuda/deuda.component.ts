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
  suscriptores: string [] = [];
  suscriptorSeleccionado: string = '';

  constructor(private deudaService: DeudaService) {}

  ngOnInit(): void {
    this.cargarSuscriptores();
  }


  cargarSuscriptores() {
    //Aquí se conectara el servicio mas adelante

    this.suscriptores = [
      'Pepe aguirre',
      'Hugo castro',
      'Luis Hidalgo',
      'Miguel Angel'
    ];
  }

  consultarDeuda() {
  console.log('Consultando deuda para:', this.suscriptorSeleccionado);
  // Aquí se conectara el servicio mas adelante
  }

}
