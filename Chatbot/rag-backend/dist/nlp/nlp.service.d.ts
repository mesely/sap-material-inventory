import { QueryFiltersDto } from '../types/query-filters.dto';
export declare class NlpService {
    isInventoryQuery(question: string): Promise<boolean>;
    extractFilters(question: string): Promise<QueryFiltersDto | null>;
}
