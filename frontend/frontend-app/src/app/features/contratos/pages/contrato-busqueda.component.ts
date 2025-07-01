import { Component, OnInit } from '@angular/core';
import { ContratoService } from '../../../core/services/contrato.service';

/**
 * Componente de ejemplo para la página de búsqueda de contratos
 */
@Component({
  selector: 'app-contrato-busqueda',
  templateUrl: './contrato-busqueda.component.html',
  styleUrls: ['./contrato-busqueda.component.css']
})
export class ContratoBusquedaComponent implements OnInit {
  
  searchTerm: string = '';
  contratos: any[] = [];
  loading: boolean = false;
  error: string = '';

  constructor(private contratoService: ContratoService) {}

  ngOnInit(): void {
    // Inicialización del componente
  }

  /**
   * Busca contratos basado en el término de búsqueda
   */
  buscarContratos(): void {
    if (!this.searchTerm.trim()) {
      this.error = 'Ingrese un término de búsqueda';
      return;
    }

    this.loading = true;
    this.error = '';

    const filtros = {
      searchTerm: this.searchTerm,
      estado: 'ACTIVO'
    };

    this.contratoService.buscarContratos(filtros).subscribe({
      next: (response) => {
        this.contratos = response.data || [];
        this.loading = false;
      },
      error: (error) => {
        this.error = 'Error al buscar contratos: ' + error.message;
        this.loading = false;
      }
    });
  }

  /**
   * Valida un contrato específico
   */
  validarContrato(numeroContrato: string): void {
    this.contratoService.validarContrato(numeroContrato).subscribe({
      next: (response) => {
        if (response.esValido) {
          alert(`Contrato ${numeroContrato} es válido`);
        } else {
          alert(`Contrato ${numeroContrato} no es válido: ${response.mensaje}`);
        }
      },
      error: (error) => {
        alert('Error al validar contrato: ' + error.message);
      }
    });
  }

  /**
   * Limpia los resultados de búsqueda
   */
  limpiar(): void {
    this.searchTerm = '';
    this.contratos = [];
    this.error = '';
  }
}
