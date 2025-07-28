"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppService = void 0;
const common_1 = require("@nestjs/common");
const nlp_service_1 = require("./nlp/nlp.service");
const sap_service_1 = require("./sap/sap.service");
const aggregations_service_1 = require("./aggregations/aggregations.service");
const llm_service_1 = require("./llm/llm.service");
let AppService = class AppService {
    nlp;
    sap;
    aggs;
    llm;
    constructor(nlp, sap, aggs, llm) {
        this.nlp = nlp;
        this.sap = sap;
        this.aggs = aggs;
        this.llm = llm;
    }
    async processQuestion(question) {
        const filters = await this.nlp.extractFilters(question);
        if (!filters) {
            return {
                answer: 'Ben bir BMC depo asistanıyım; depo verileriyle ilgili sorularınıza yardımcı olabilirim.',
                filters: null,
                source_count: 0,
                aggregations: null,
                source_sample: [],
            };
        }
        const rows = await this.sap.fetchInventory({ ...filters });
        const aggs = this.aggs.aggregate(rows, filters);
        const answer = await this.llm.generateAnswer(question, filters, rows, aggs);
        return {
            answer,
            filters,
            source_count: rows.length,
            aggregations: aggs,
            source_sample: rows.slice(0, 3),
        };
    }
};
exports.AppService = AppService;
exports.AppService = AppService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [nlp_service_1.NlpService,
        sap_service_1.SapService,
        aggregations_service_1.AggregationService,
        llm_service_1.LlmService])
], AppService);
//# sourceMappingURL=app.service.js.map