class WasmHttpClient {
    constructor() {
        this.wasmModule = null;
        this.isInitialized = false;
    }

    static async initialize() {
        const instance = new WasmHttpClient();
        try {
            // Load WASM module
            const wasmResponse = await fetch('/assets/http_wasm.wasm');
            const wasmBytes = await wasmResponse.arrayBuffer();

            // Initialize WASM module
            const wasmModule = await WebAssembly.instantiate(wasmBytes, {
                env: {
                    // Environment functions that WASM can call
                    log: (ptr, len) => {
                        const memory = new Uint8Array(wasmModule.instance.exports.memory.buffer);
                        const message = new TextDecoder().decode(memory.slice(ptr, ptr + len));
                        console.log('[WASM]', message);
                    }
                }
            });

            instance.wasmModule = wasmModule;
            instance.isInitialized = true;

            return instance;
        } catch (error) {
            console.error('Failed to initialize WASM:', error);
            throw error;
        }
    }

    async performRequest(options) {
        if (!this.isInitialized) {
            throw new Error('WASM client not initialized');
        }

        try {
            // Use fetch API with WASM optimizations
            const fetchOptions = {
                method: options.method,
                headers: options.headers,
                body: options.body,
            };

            // Add timeout support
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), options.timeout);

            const response = await fetch(options.url, {
                ...fetchOptions,
                signal: controller.signal,
            });

            clearTimeout(timeoutId);

            // Read response
            const bodyArrayBuffer = await response.arrayBuffer();
            const bodyBytes = new Uint8Array(bodyArrayBuffer);

            // Convert headers
            const headers = {};
            for (const [key, value] of response.headers.entries()) {
                headers[key] = value;
            }

            return {
                statusCode: response.status,
                statusMessage: response.statusText,
                headers: headers,
                body: Array.from(bodyBytes),
            };

        } catch (error) {
            if (error.name === 'AbortError') {
                throw new Error('Request timeout');
            }
            throw error;
        }
    }
}

// Global instance
window.WasmHttpClient = {
    instance: null,

    async initialize() {
        if (!this.instance) {
            this.instance = await WasmHttpClient.initialize();
        }
        return this.instance;
    },

    async performRequest(options) {
        if (!this.instance) {
            await this.initialize();
        }
        return this.instance.performRequest(options);
    }
};