import { QueryFiltersDto } from '../types/query-filters.dto';
type Row = Record<string, any>;
export declare class AggregationService {
    aggregate(rows: Row[], f: QueryFiltersDto): any[] | null;
    private sumByKey;
}
export {};
