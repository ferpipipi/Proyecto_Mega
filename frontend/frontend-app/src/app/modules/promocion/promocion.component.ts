import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-promocion',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './promocion.component.html',
  styleUrl: './promocion.component.scss'
})
export class PromocionComponent {

}
