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
exports.SapService = void 0;
const common_1 = require("@nestjs/common");
const axios_1 = require("axios");
let SapService = class SapService {
    client;
    constructor() {
        const base = "https://bmcides.bmc.com.tr:44300/sap/bc/zrag_inv";
        const user = "HERGIN";
        const pass = "Rugare%500";
        if (!base || !user || !pass) {
            throw new common_1.InternalServerErrorException('SAP connection env vars (SAP_BASE_URL, SAP_USER, SAP_PASS) are missing.');
        }
        this.client = axios_1.default.create({
            baseURL: base,
            auth: { username: user, password: pass },
            timeout: 30_000,
        });
    }
    async fetchInventory(filters) {
        const params = {};
        for (const [k, v] of Object.entries(filters)) {
            if (v !== undefined && v !== null)
                params[k] = v;
        }
        const { data } = await this.client.get('/', { params });
        return data;
    }
};
exports.SapService = SapService;
exports.SapService = SapService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [])
], SapService);
//# sourceMappingURL=sap.service.js.map