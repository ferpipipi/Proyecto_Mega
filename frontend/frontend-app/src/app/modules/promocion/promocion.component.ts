import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-promociones',
  standalone: true,
  templateUrl: './promocion.component.html',
  styleUrls: ['./promocion.component.scss'],
  imports: [CommonModule, FormsModule, HttpClientModule]
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

  meses = [1, 2, 3, 4, 5, 6,7,8,9,10,11, 12];
  ciudadNueva: string = '';
  coloniaNueva: string = '';

  mostrarModal = false;
  editandoIndex: number | null = null;

  constructor(private http: HttpClient) {}

  ngOnInit(): void {
    this.cargarPromociones();
    this.cargarCiudades();
    this.cargarColonias();
  }

  cargarPromociones() {
    this.http.get<any>('http://localhost:5011/api/promociones').subscribe(res => {
      this.promociones = res.data.map((promo: any) => ({
        ...promo,
        ciudad: promo.ciudad_nombre || 'Sin ciudad',
        colonias: promo.colonias_nombre || []
      }));
    });
  }

cargarCiudades() {
  this.http.get<any[]>('http://localhost:5011/api/ciudades').subscribe(data => {
    this.ciudades = data;
  });
}

  cargarColonias() {
    this.http.get<any[]>('http://localhost:5011/api/colonias').subscribe(data => {
      this.colonias = data;
    });
  }

  agregarCiudad() {
    if (this.ciudadNueva.trim()) {
      this.http.post('http://localhost:5011/api/ciudades', { nombre: this.ciudadNueva }).subscribe(() => {
        this.ciudadNueva = '';
        this.cargarCiudades();
      });
    }
  }

  agregarColonia() {
    if (this.coloniaNueva.trim()) {
      this.http.post('http://localhost:5011/api/colonias', { nombre: this.coloniaNueva }).subscribe(() => {
        this.coloniaNueva = '';
        this.cargarColonias();
      });
    }
  }

  guardarPromocion() {
    this.nuevaPromo.colonias_id = this.coloniaSeleccionada;

    this.http.post('http://localhost:5011/api/promociones', this.nuevaPromo).subscribe(() => {
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
    this.promociones[index].efecto = 'eliminar';
    setTimeout(() => {
      this.promociones.splice(index, 1);
    }, 500);
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
      ciudad: '',
      colonias: []
    };
    this.coloniaSeleccionada = [];
    this.mostrarModal = false;
    this.editandoIndex = null;
  }
}
