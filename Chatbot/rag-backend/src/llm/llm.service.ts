// src/llm/llm.service.ts
import { Injectable } from '@nestjs/common';
import OpenAI from 'openai';


const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
@Injectable()
export class LlmService {
  /**
   * Builds a prompt and returns an assistant answer.
   * Uses GPT-4o-mini; no special response_format needed (plain text).
   */
  async generateAnswer(
    question: string,
    filters: any,
    rows: any[],
    aggs: any[] | null,
  ): Promise<string> {
    const rowsPreview = rows.slice(0, 50); // keep prompt small

    const systemPrompt = `
You are an inventory analytics assistant for SAP data.
Answer ONLY using the data provided.
Finish with: "Kaynak: SAP ZINVENTORYRECORD (test ides)".
`;

    const userPrompt = `
Soru: ${question}

Filtreler: ${JSON.stringify(filters, null, 2)}

Agregasyon: ${JSON.stringify(aggs, null, 2)}

First 50 row:
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
}
