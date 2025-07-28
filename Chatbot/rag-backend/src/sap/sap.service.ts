// src/sap/sap.service.ts
import { Injectable, InternalServerErrorException } from '@nestjs/common';
import axios, { AxiosInstance } from 'axios';

@Injectable()
export class SapService {
  private readonly client: AxiosInstance;

  constructor() {
    
    const base = process.env.SAP_BASE_URL ;
    const user = process.env.SAP_USER;
    const pass = process.env.SAP_PASS;

 
    if (!base || !user || !pass) {
      throw new InternalServerErrorException(
        'SAP connection env vars (SAP_BASE_URL, SAP_USER, SAP_PASS) are missing.'
      );
    }

  
    this.client = axios.create({
      baseURL: base,              
      auth: { username: user, password: pass },
      timeout: 30_000,
    });
  }

  
  async fetchInventory(filters: Record<string, unknown>): Promise<any[]> {
    // undefined/null 
    const params: Record<string, unknown> = {};
    for (const [k, v] of Object.entries(filters)) {
      if (v !== undefined && v !== null) params[k] = v;
    }

    const { data } = await this.client.get('/', { params });
    return data; // JSON → any
  }
}
