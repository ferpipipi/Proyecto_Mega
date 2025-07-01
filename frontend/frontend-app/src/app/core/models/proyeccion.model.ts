/**
 * Modelo para representar una proyección financiera
 */
export interface Proyeccion {
  numeroContrato: string;
  mes: number;
  año: number;
  montoProyectado: number;
  fechaProyeccion: Date;
  concepto?: string;
}

/**
 * DTO para solicitud de proyección individual
 */
export interface ProyeccionRequest {
  numeroContrato: string;
  fechaInicio?: Date;
  fechaFin?: Date;
}

/**
 * DTO para solicitud de proyección múltiple
 */
export interface ProyeccionMultipleRequest {
  numerosContrato: string[];
  fechaInicio?: Date;
  fechaFin?: Date;
}

/**
 * DTO para respuesta de proyección
 */
export interface ProyeccionResponse {
  proyecciones: Proyeccion[];
  totalProyectado: number;
  resumen: ResumenProyeccion;
}

/**
 * Resumen de una proyección
 */
export interface ResumenProyeccion {
  cantidadContratos: number;
  montoTotal: number;
  periodoInicio: Date;
  periodoFin: Date;
}
