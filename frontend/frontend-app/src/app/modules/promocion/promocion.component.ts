import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-promociones',
  standalone: true,
  templateUrl: './promocion.component.html',
  imports: [
    CommonModule,
    FormsModule,
    RouterModule,
    HttpClientModule
  ],
  styleUrls: ['./promocion.component.scss']
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
    this.http.get<any[]>('http://localhost:5011/api/promociones').subscribe(data => {
      this.promociones = data;
    });
  }

  agregarPromocion() {
    this.http.post('http://localhost:5011/api/promociones', this.nuevaPromo).subscribe(() => {
      this.nuevaPromo = {
        nombre: '', descripcion: '', tipo_promocion: '', valor_descuento: 0,
        es_porcentaje: false, duracion_meses: 0, fecha_inicio: '', fecha_fin: '', activo: true
      };
      this.cargarPromociones();
    });
  }

  eliminarPromocion(id: number) {
    this.http.delete(`http://localhost:5011/api/promociones/${id}`).subscribe(() => {
      this.cargarPromociones();
    });
  }

  editarPromocion(promo: any) {
    this.editando = { ...promo };
  }

  guardarEdicion() {
    this.http.put(`http://localhost:5011/api/promociones/${this.editando.id}`, this.editando).subscribe(() => {
      this.editando = null;
      this.cargarPromociones();
    });
  }

  cancelarEdicion() {
    this.editando = null;
  }
}
