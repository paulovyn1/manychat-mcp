import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import * as dotenv from "dotenv";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

// Carregar .env da pasta raiz do projeto
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
dotenv.config({ path: join(__dirname, "../.env") });

import { registerCustomFieldTools } from "./tools/customFields.js";
import { registerTagTools } from "./tools/tags.js";
import { registerFlowTools } from "./tools/flows.js";

const server = new McpServer({
  name: "manychat-mcp-server",
  version: "1.0.0",
});

registerCustomFieldTools(server);
registerTagTools(server);
registerFlowTools(server);

const transport = new StdioServerTransport();
await server.connect(transport);
