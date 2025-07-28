"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.NlpService = void 0;
const common_1 = require("@nestjs/common");
const openai_1 = require("openai");
const query_filters_dto_1 = require("../types/query-filters.dto");
const openai = new openai_1.default({ apiKey: "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" });
const NAME_TO_ID = {
    'Mehmet Ökten': '27500',
    'Atalay Özcan': '27501',
    'Necdet Karakaya': '27502',
    'Hande Er': '27503',
    'Mustafa Ali Tatlı': '27504',
    'Emre Başaran': '27505',
    'Gülistan Duman': '27506',
    'Onur Ergüden': '27507',
    'Onur Sipahioğlu': '27508',
    'Oğuz Ünlüerler': '27509',
    'Merve Yıldız Sunarlı': '27510',
    'Işıl Yılmaz': '27511',
    'Osman Şerit': '27512',
    'Emre Tarhan': '27515',
};
const intentSystemPrompt = `
You are a strict JSON-only classifier.
Return {"is_inventory": true|false}.
True only if the user asks about inventory, stock, materials, quantities, warehouses, dates etc.
`;
const intentFewShot = [
    { role: 'user', content: 'Kirpi grubunda 10 tane parça var mı?' },
    { role: 'assistant', content: '{"is_inventory": true}' },
    { role: 'user', content: 'Fenerbahçe maçı kaç kaç bitti?' },
    { role: 'assistant', content: '{"is_inventory": false}' },
];
const filterSystemPrompt = `
Today is 28 July 2025.
If year is missing in the question, assume 2025.

• If user asks to see the entire table, set "show_full": true.
  Keywords: "hepsini göster", "tam liste", "tüm satırlar".
• If the user mentions a person's full name (first + last), fill first_name & last_name.

Return JSON matching the schema exactly. Do NOT explain.
`;
const filterFunctionDef = {
    name: 'extract_filters',
    description: 'Extract SAP filter fields.',
    parameters: {
        type: 'object',
        properties: {
            warehouse_id: { type: 'integer', nullable: true },
            material_id: { type: 'integer', nullable: true },
            material_type: { type: 'string', nullable: true },
            material_group: { type: 'string', nullable: true },
            personnel_id: { type: 'string', nullable: true },
            first_name: { type: 'string', nullable: true },
            last_name: { type: 'string', nullable: true },
            date_from: { type: 'string', nullable: true },
            date_to: { type: 'string', nullable: true },
            aggregate: {
                type: 'string',
                enum: ['sum', 'count', 'list', 'by_material', 'by_group', 'by_type', 'top'],
            },
            top_k: { type: 'integer', nullable: true },
            show_full: { type: 'boolean', nullable: true },
        },
        required: ['aggregate'],
    },
};
let NlpService = class NlpService {
    async isInventoryQuery(question) {
        const req = {
            model: 'gpt-4o-mini',
            temperature: 0,
            response_format: { type: 'json_object' },
            messages: [
                { role: 'system', content: intentSystemPrompt },
                ...intentFewShot,
                { role: 'user', content: question },
            ],
        };
        const chat = await openai.chat.completions.create(req);
        const res = JSON.parse(chat.choices[0].message.content ?? '{}');
        return res.is_inventory ?? false;
    }
    async extractFilters(question) {
        if (!(await this.isInventoryQuery(question)))
            return null;
        const chat = await openai.chat.completions.create({
            model: 'gpt-4o-mini',
            temperature: 0,
            messages: [
                { role: 'system', content: filterSystemPrompt },
                { role: 'user', content: question },
            ],
            tools: [{ type: 'function', function: filterFunctionDef }],
            tool_choice: { type: 'function', function: { name: 'extract_filters' } },
        });
        const args = chat.choices[0].message.tool_calls?.[0]?.function?.arguments;
        const obj = JSON.parse(args ?? '{}');
        if (!obj.personnel_id && obj.first_name && obj.last_name) {
            const full = `${obj.first_name} ${obj.last_name}`;
            if (NAME_TO_ID[full])
                obj.personnel_id = NAME_TO_ID[full];
        }
        return Object.assign(new query_filters_dto_1.QueryFiltersDto(), obj);
    }
};
exports.NlpService = NlpService;
exports.NlpService = NlpService = __decorate([
    (0, common_1.Injectable)()
], NlpService);
//# sourceMappingURL=nlp.service.js.map