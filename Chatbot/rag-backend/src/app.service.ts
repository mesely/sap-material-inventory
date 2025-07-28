import { Injectable } from '@nestjs/common';
import { NlpService } from './nlp/nlp.service';
import { SapService } from './sap/sap.service';
import { AggregationService } from './aggregations/aggregations.service';
import { LlmService } from './llm/llm.service';

@Injectable()
export class AppService {
  constructor(
    private readonly nlp: NlpService,
    private readonly sap: SapService,
    private readonly aggs: AggregationService,
    private readonly llm: LlmService,
  ) {}

  /** Main orchestrator: question → NLP → SAP → aggregation → answer */
  async processQuestion(question: string) {
    // 1) NLP – extract filters (or null if unrelated)
    const filters = await this.nlp.extractFilters(question);

    // 1.a) Not an inventory query → fixed assistant reply
    if (!filters) {
      return {
        answer:
          'Ben bir BMC depo asistanıyım; depo verileriyle ilgili sorularınıza yardımcı olabilirim.',
        filters: null,
        source_count: 0,
        aggregations: null,
        source_sample: [],
      };
    }

    // 2) SAP fetch
    const rows = await this.sap.fetchInventory({ ...filters });

    // 3) Aggregations
    const aggs = this.aggs.aggregate(rows, filters);

    // 4) LLM answer
    const answer = await this.llm.generateAnswer(
      question,
      filters,
      rows,
      aggs,
    );

    return {
      answer,
      filters,
      source_count: rows.length,
      aggregations: aggs,
      source_sample: rows.slice(0, 3),
    };
  }
}
