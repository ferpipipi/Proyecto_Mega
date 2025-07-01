/**
 * Utilidades para validación de datos
 */
export class ValidationUtils {
  
  /**
   * Valida si un número de contrato tiene el formato correcto
   */
  static isValidContractNumber(contractNumber: string): boolean {
    if (!contractNumber) return false;
    
    // Ejemplo: validar que tenga al menos 6 caracteres y sea alfanumérico
    const regex = /^[A-Z0-9]{6,}$/i;
    return regex.test(contractNumber.trim());
  }

  /**
   * Valida si un email tiene formato correcto
   */
  static isValidEmail(email: string): boolean {
    if (!email) return false;
    
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email.trim());
  }

  /**
   * Valida si una fecha está en un rango válido
   */
  static isValidDateRange(startDate: Date, endDate: Date): boolean {
    if (!startDate || !endDate) return false;
    
    return startDate <= endDate;
  }

  /**
   * Valida si un valor numérico está en un rango específico
   */
  static isInRange(value: number, min: number, max: number): boolean {
    return value >= min && value <= max;
  }

  /**
   * Valida si una cadena tiene una longitud mínima
   */
  static hasMinLength(text: string, minLength: number): boolean {
    return !!(text && text.trim().length >= minLength);
  }

  /**
   * Valida si un valor es un número válido
   */
  static isValidNumber(value: any): boolean {
    return !isNaN(parseFloat(value)) && isFinite(value);
  }

  /**
   * Valida si una fecha no es anterior a hoy
   */
  static isNotPastDate(date: Date): boolean {
    if (!date) return false;
    
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    return date >= today;
  }
}
