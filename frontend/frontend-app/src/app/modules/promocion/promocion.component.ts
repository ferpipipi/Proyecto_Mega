import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ConfiguradorService } from '../../services/configuradorPromo.service';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-promociones',
  standalone: true,
  templateUrl: './promocion.component.html',
  styleUrls: ['./promocion.component.scss'],
  imports: [CommonModule, FormsModule, RouterLink]
})
export class PromocionesComponent implements OnInit {
  promociones: any[] = [];
  ciudades: any[] = [];
  colonias: any[] = [];
  coloniaSeleccionada: number[] = [];

  nuevaPromo: any = {
    nombre: '',
    descripcion: '',
    tipo_promocion: '',
    valor_descuento: 0,
    es_porcentaje: false,
    duracion_meses: 1,
    fecha_inicio: '',
    fecha_fin: '',
    activo: true,
    ciudad_id: null,
    colonias_id: [],
  };

  meses: number[] = []; // Inicializado como array vacío
  ciudadNueva: string = '';
  coloniaNueva: string = '';

  mostrarModal = false;
  editandoIndex: number | null = null;
  
  constructor(private configuradorService: ConfiguradorService) {}

  ngOnInit(): void {
    this.inicializarMeses();
    this.cargarDatosIniciales();
  }

  inicializarMeses() {
    // Solución más limpia: Definir directamente los meses ya que son valores fijos
    this.meses = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    
    // Si realmente necesitas obtenerlos del servicio (para futura flexibilidad):
    // this.meses = this.configuradorService.obtenerMesesDisponibles();
  }

  cargarDatosIniciales() {
    this.cargarPromociones();
    this.cargarCiudades();
    this.cargarColonias();
  }

  cargarPromociones() {
    this.configuradorService.obtenerPromociones().subscribe(res => {
      this.promociones = res.data.map((promo: any) => ({
        ...promo,
        ciudad: promo.ciudad_nombre || 'Sin ciudad',
        colonias: promo.colonias_nombre || []
      }));
    });
  }

  cargarCiudades() {
    this.configuradorService.obtenerCiudades().subscribe(data => {
      this.ciudades = data;
    });
  }

  cargarColonias() {
    this.configuradorService.obtenerColonias().subscribe(data => {
      this.colonias = data;
    });
  }

  agregarCiudad() {
    if (this.ciudadNueva.trim()) {
      this.configuradorService.crearCiudad(this.ciudadNueva).subscribe(() => {
        this.ciudadNueva = '';
        this.cargarCiudades();
      });
    }
  }

  agregarColonia() {
    if (this.coloniaNueva.trim()) {
      this.configuradorService.crearColonia(this.coloniaNueva).subscribe(() => {
        this.coloniaNueva = '';
        this.cargarColonias();
      });
    }
  }

  guardarPromocion() {
    this.nuevaPromo.colonias_id = this.coloniaSeleccionada;

    const operacion = this.editandoIndex !== null 
      ? this.configuradorService.actualizarPromocion(this.nuevaPromo.id, this.nuevaPromo)
      : this.configuradorService.crearPromocion(this.nuevaPromo);

    operacion.subscribe(() => {
      this.cargarPromociones();
      this.cerrarModal();
    });
  }

  editarPromo(promo: any) {
    this.editandoIndex = this.promociones.indexOf(promo);
    this.nuevaPromo = { ...promo };
    this.coloniaSeleccionada = [...promo.colonias];
    this.mostrarModal = true;
  }

  eliminarPromo(index: number) {
    const id = this.promociones[index].id;
    this.configuradorService.eliminarPromocion(id).subscribe(() => {
      this.promociones[index].efecto = 'eliminar';
      setTimeout(() => {
        this.promociones.splice(index, 1);
      }, 500);
    });
  }

  cerrarModal() {
    this.nuevaPromo = {
      nombre: '',
      descripcion: '',
      tipo_promocion: '',
      valor_descuento: 0,
      es_porcentaje: false,
      duracion_meses: 1,
      fecha_inicio: '',
      fecha_fin: '',
      activo: true,
      ciudad_id: null,
      colonias_id: []
    };
    this.coloniaSeleccionada = [];
    this.mostrarModal = false;
    this.editandoIndex = null;
  }
}