// Aggregation helpers – pure JS so no extra deps required
import { Injectable } from '@nestjs/common';
import { QueryFiltersDto } from '../types/query-filters.dto';

type Row = Record<string, any>;

@Injectable()
export class AggregationService {
  aggregate(rows: Row[], f: QueryFiltersDto): any[] | null {
    if (!rows.length) return null;

    switch (f.aggregate) {
      case 'by_material':
        return this.sumByKey(rows, 'MATERIAL_NAME');
      case 'by_group':
        return this.sumByKey(rows, 'MATERIAL_GROUP');
      case 'top':
        return this
          .sumByKey(rows, 'MATERIAL_NAME')
          .slice(0, f.top_k ?? 5);
      case 'sum':
        const total = rows.reduce((acc, r) => acc + (r.QUANTITY ?? 0), 0);
        return [{ total_quantity: total }];
      default:
        return null;
    }
  }

  private sumByKey(rows: Row[], key: string) {
  const map = new Map<string, { sum: number; count: number }>();

  for (const r of rows) {
    const k = r[key] ?? 'UNKNOWN';
    const q = r.QUANTITY ?? 0;
    const prev = map.get(k) ?? { sum: 0, count: 0 };
    map.set(k, { sum: prev.sum + q, count: prev.count + 1 });
  }

  return Array.from(map.entries())
    .map(([k, v]) => ({
      [key.toLowerCase()]: k,
      quantity_sum: v.sum,
      record_count: v.count,
      average: +(v.sum / v.count).toFixed(2),
    }))
    .sort((a, b) => b.quantity_sum - a.quantity_sum);
}

}
