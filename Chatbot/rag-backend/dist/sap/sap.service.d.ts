export declare class SapService {
    private readonly client;
    constructor();
    fetchInventory(filters: Record<string, unknown>): Promise<any[]>;
}
