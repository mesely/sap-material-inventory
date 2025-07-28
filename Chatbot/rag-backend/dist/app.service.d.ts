import { NlpService } from './nlp/nlp.service';
import { SapService } from './sap/sap.service';
import { AggregationService } from './aggregations/aggregations.service';
import { LlmService } from './llm/llm.service';
export declare class AppService {
    private readonly nlp;
    private readonly sap;
    private readonly aggs;
    private readonly llm;
    constructor(nlp: NlpService, sap: SapService, aggs: AggregationService, llm: LlmService);
    processQuestion(question: string): Promise<{
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
