"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.LlmService = void 0;
const common_1 = require("@nestjs/common");
const openai_1 = require("openai");
const openai = new openai_1.default({
    apiKey: "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",
});
let LlmService = class LlmService {
    async generateAnswer(question, filters, rows, aggs) {
        const rowsPreview = rows.slice(0, 50);
        const systemPrompt = `
You are an inventory analytics assistant for SAP data.
Answer ONLY using the data provided.
Finish with: "Kaynak: SAP ZINVENTORYRECORD (test ides)".
`;
        const userPrompt = `
Soru: ${question}

Filtreler: ${JSON.stringify(filters, null, 2)}

Agregasyon: ${JSON.stringify(aggs, null, 2)}

İlk 50 satır:
${JSON.stringify(rowsPreview, null, 2)}
`;
        const chat = await openai.chat.completions.create({
            model: 'gpt-4o-mini',
            temperature: 0.3,
            messages: [
                { role: 'system', content: systemPrompt },
                { role: 'user', content: userPrompt },
            ],
        });
        return chat.choices[0].message.content?.trim() ?? '';
    }
};
exports.LlmService = LlmService;
exports.LlmService = LlmService = __decorate([
    (0, common_1.Injectable)()
], LlmService);
//# sourceMappingURL=llm.service.js.map