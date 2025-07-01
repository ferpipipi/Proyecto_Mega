/**
 * Modelos comunes utilizados en toda la aplicación
 */

/**
 * Respuesta API estándar
 */
export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  message?: string;
  errors?: string[];
}

/**
 * Parámetros de paginación
 */
export interface PaginationParams {
  page: number;
  pageSize: number;
  sortBy?: string;
  sortDirection?: 'asc' | 'desc';
}

/**
 * Respuesta paginada
 */
export interface PaginatedResponse<T = any> {
  items: T[];
  totalItems: number;
  totalPages: number;
  currentPage: number;
  pageSize: number;
}

/**
 * Filtros de búsqueda
 */
export interface SearchFilters {
  searchTerm?: string;
  dateFrom?: Date;
  dateTo?: Date;
  status?: string;
}

/**
 * Configuración de tabla
 */
export interface TableColumn {
  key: string;
  label: string;
  sortable?: boolean;
  type?: 'text' | 'number' | 'date' | 'currency' | 'status';
}
