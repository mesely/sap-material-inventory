import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { NlpService } from './nlp/nlp.service';
import { SapService } from './sap/sap.service';
import { AggregationService } from './aggregations/aggregations.service';
import { LlmService } from './llm/llm.service';

@Module({
  controllers: [AppController],
  providers: [
    AppService,
    NlpService,
    SapService,
    AggregationService,
    LlmService,
  ],
})
export class AppModule {}
