import { Pipe, PipeTransform } from '@angular/core';

/**
 * Pipe para formatear valores monetarios en pesos mexicanos
 */
@Pipe({
  name: 'currency'
})
export class CurrencyPipe implements PipeTransform {

  transform(value: number | string, showSymbol: boolean = true): string {
    if (value === null || value === undefined || value === '') {
      return showSymbol ? '$0.00' : '0.00';
    }

    const numericValue = typeof value === 'string' ? parseFloat(value) : value;
    
    if (isNaN(numericValue)) {
      return showSymbol ? '$0.00' : '0.00';
    }

    const formatted = numericValue.toLocaleString('es-MX', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });

    return showSymbol ? `$${formatted}` : formatted;
  }
}
