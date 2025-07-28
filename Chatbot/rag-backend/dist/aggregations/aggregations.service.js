"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AggregationService = void 0;
const common_1 = require("@nestjs/common");
let AggregationService = class AggregationService {
    aggregate(rows, f) {
        if (!rows.length)
            return null;
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
    sumByKey(rows, key) {
        const map = new Map();
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
};
exports.AggregationService = AggregationService;
exports.AggregationService = AggregationService = __decorate([
    (0, common_1.Injectable)()
], AggregationService);
//# sourceMappingURL=aggregations.service.js.map