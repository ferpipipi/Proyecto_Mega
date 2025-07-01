/**
 * Utilidades para formateo de datos
 */
export class FormatUtils {
  
  /**
   * Formatea un número como moneda en pesos mexicanos
   */
  static formatCurrency(value: number | string): string {
    if (value === null || value === undefined || value === '') {
      return '$0.00';
    }

    const numericValue = typeof value === 'string' ? parseFloat(value) : value;
    
    if (isNaN(numericValue)) {
      return '$0.00';
    }

    return new Intl.NumberFormat('es-MX', {
      style: 'currency',
      currency: 'MXN'
    }).format(numericValue);
  }

  /**
   * Formatea una fecha en formato dd/MM/yyyy
   */
  static formatDate(date: Date | string): string {
    if (!date) return '';

    const d = typeof date === 'string' ? new Date(date) : date;
    
    if (isNaN(d.getTime())) return '';

    return d.toLocaleDateString('es-MX');
  }

  /**
   * Formatea un número con separadores de miles
   */
  static formatNumber(value: number | string, decimals: number = 2): string {
    if (value === null || value === undefined || value === '') {
      return '0';
    }

    const numericValue = typeof value === 'string' ? parseFloat(value) : value;
    
    if (isNaN(numericValue)) {
      return '0';
    }

    return numericValue.toLocaleString('es-MX', {
      minimumFractionDigits: decimals,
      maximumFractionDigits: decimals
    });
  }

  /**
   * Capitaliza la primera letra de una cadena
   */
  static capitalize(text: string): string {
    if (!text) return '';
    return text.charAt(0).toUpperCase() + text.slice(1).toLowerCase();
  }

  /**
   * Trunca un texto a una longitud específica
   */
  static truncate(text: string, length: number): string {
    if (!text || text.length <= length) return text;
    return text.substring(0, length) + '...';
  }
}
