import { AppService } from './app.service';
export declare class AppController {
    private readonly appSvc;
    constructor(appSvc: AppService);
    ask(question: string): Promise<{
        answer: string;
        filters: null;
        source_count: number;
        aggregations: null;
        source_sample: never[];
    } | {
        answer: string;
        filters: import("./types/query-filters.dto").QueryFiltersDto;
        source_count: number;
        aggregations: any[] | null;
        source_sample: any[];
    }>;
}
