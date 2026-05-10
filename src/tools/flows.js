import { createClient, handleError } from "../services/manychat.js";
import { z } from "zod";

export function registerFlowTools(server) {

  server.registerTool("manychat_get_flows", {
    title: "Listar Flows",
    description: "Lista todos os flows da conta ManyChat. Use para descobrir o flow_ns antes de disparar.",
    inputSchema: z.object({}),
    annotations: { readOnlyHint: true, destructiveHint: false }
  }, async () => {
    try {
      const client = createClient();
      const response = await client.get("/fb/page/getFlows");
      const flows = response.data?.data || [];
      if (!flows.length) return { content: [{ type: "text", text: "Nenhum flow encontrado." }] };
      const formatted = flows.map(f => `• [NS: ${f.ns}]\n  ${f.name}`).join("\n");
      return { content: [{ type: "text", text: `Flows:\n\n${formatted}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: handleError(e) }] };
    }
  });

  server.registerTool("manychat_send_flow", {
    title: "Disparar Flow para Contato",
    description: "Dispara um flow do ManyChat para um contato especifico. Use manychat_get_flows para descobrir o flow_ns.",
    inputSchema: z.object({
        subscriber_id: z.string().describe("ID do contato no ManyChat"),
        flow_ns: z.string().describe("Namespace do flow (ex: content20180221085508_278692)")
      }),
    annotations: { readOnlyHint: false, destructiveHint: false }
  }, async ({ subscriber_id, flow_ns }) => {
    try {
      const client = createClient();
      await client.post("/fb/sending/sendFlow", { subscriber_id, flow_ns });
      return { content: [{ type: "text", text: `Flow disparado!\n\nContato: ${subscriber_id}\nFlow: ${flow_ns}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: handleError(e) }] };
    }
  });
}
