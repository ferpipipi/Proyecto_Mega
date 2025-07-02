export interface Suscriptor {
  id?: number;
  nombre: string;
  alias?: string;
  correo: string;
  celular?: string;
  ciudadId: number;
  coloniaId: number;
  estadosAbreviatura?: string;
  tipoSuscriptorCodigo?: string;
}

export interface CrearSuscriptor {
  nombre: string;
  alias?: string;
  correo: string;
  celular?: string;
  ciudadId: number;
  coloniaId: number;
  estadosAbreviatura?: string;
  tipoSuscriptorCodigo?: string;
}

export interface ActualizarSuscriptor {
  nombre?: string;
  alias?: string;
  correo?: string;
  celular?: string;
  ciudadId?: number;
  coloniaId?: number;
  estadosAbreviatura?: string;
  tipoSuscriptorCodigo?: string;
}

export interface FiltrosSuscriptor {
  nombre?: string;
  correo?: string;
  celular?: string;
  ciudadId?: number;
  coloniaId?: number;
  estadosAbreviatura?: string;
  tipoSuscriptorCodigo?: string;
  pagina?: number;
  tamanoPagina?: number;
}

export interface RespuestaPaginada {
  suscriptores: Suscriptor[];
  totalRegistros: number;
  totalPaginas: number;
  paginaActual: number;
  tamanoPagina: number;
}

export interface EstadisticasSuscriptores {
  totalSuscriptores: number;
  fechaConsulta: string;
}

export interface VerificarCorreo {
  correo: string;
  existe: boolean;
  mensaje: string;
}

export interface TipoSuscriptor {
  codigo: string;
  descripcion: string;
  categoria: string;
  activo: boolean;
}

// Tipos de suscriptor válidos
export const TIPOS_SUSCRIPTOR = [
  'RES',        // Residencial
  'EMP',        // Empresa
  'EMPL',       // Empleado
  'AC',         // Asociación Civil
  'GOB',        // Gobierno
  'ESC',        // Escuela
  'CARIDAD',    // Caridad
  'INTERNO',    // Interno
  'COMERCIAL',  // Comercial
  'INDUSTRIAL', // Industrial
  'PUBLICO',    // Sector Público
  'EDUCATIVO',  // Educativo
  'SALUD',      // Sector Salud
  'ONG',        // Organización No Gubernamental
  'TEMPORAL',   // Suscriptor Temporal
  'PREMIUM',    // Suscriptor Premium
  'CORPORATIVO' // Corporativo
] as const;

export type TipoSuscriptorCodigo = typeof TIPOS_SUSCRIPTOR[number];
