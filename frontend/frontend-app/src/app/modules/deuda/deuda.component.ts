import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-deuda',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './deuda.component.html',
  styleUrl: './deuda.component.scss'
})
export class DeudaComponent {

}
