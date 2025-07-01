/**
 * Modelo para representar un contrato en el sistema
 */
export interface Contrato {
  numeroContrato: string;
  fechaInicio: Date;
  fechaFin: Date;
  estado: EstadoContrato;
  cliente?: string;
  montoTotal?: number;
}

/**
 * Estados posibles de un contrato
 */
export enum EstadoContrato {
  ACTIVO = 'ACTIVO',
  INACTIVO = 'INACTIVO',
  PENDIENTE = 'PENDIENTE',
  CANCELADO = 'CANCELADO'
}

/**
 * DTO para validación de contrato
 */
export interface ValidacionContratoRequest {
  numeroContrato: string;
}

/**
 * DTO para respuesta de validación de contrato
 */
export interface ValidacionContratoResponse {
  esValido: boolean;
  mensaje: string;
  contrato?: Contrato;
}
