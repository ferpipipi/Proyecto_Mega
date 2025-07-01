import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-promociones',
  templateUrl: './promociones.component.html',
  styleUrls: ['./promociones.component.css']
})
export class PromocionesComponent implements OnInit {
  promociones: any[] = [];
  nuevaPromo = {
    nombre: '',
    descripcion: '',
    tipo_promocion: '',
    valor_descuento: 0,
    es_porcentaje: false,
    duracion_meses: 0,
    fecha_inicio: '',
    fecha_fin: '',
    activo: true
  };
  editando: any = null;

  constructor(private http: HttpClient) {}

  ngOnInit(): void {
    this.cargarPromociones();
  }

  cargarPromociones() {
    this.http.get<any[]>('http://localhost:3000/api/promociones').subscribe(data => {
      this.promociones = data;
    });
  }

  agregarPromocion() {
    this.http.post('http://localhost:3000/api/promociones', this.nuevaPromo).subscribe(() => {
      this.nuevaPromo = {
        nombre: '', descripcion: '', tipo_promocion: '', valor_descuento: 0,
        es_porcentaje: false, duracion_meses: 0, fecha_inicio: '', fecha_fin: '', activo: true
      };
      this.cargarPromociones();
    });
  }

  eliminarPromocion(id: number) {
    this.http.delete(`http://localhost:3000/api/promociones/${id}`).subscribe(() => {
      this.cargarPromociones();
    });
  }

  editarPromocion(promo: any) {
    this.editando = { ...promo };
  }

  guardarEdicion() {
    this.http.put(`http://localhost:3000/api/promociones/${this.editando.id}`, this.editando).subscribe(() => {
      this.editando = null;
      this.cargarPromociones();
    });
  }

  cancelarEdicion() {
    this.editando = null;
  }
}
