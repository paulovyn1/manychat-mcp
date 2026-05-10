import { createClient, handleError } from "../services/manychat.js";
import { z } from "zod";

export function registerCustomFieldTools(server) {

  server.registerTool("manychat_get_custom_fields", {
    title: "Buscar Campos Personalizados",
    description: "Lista todos os campos personalizados da conta ManyChat. Use para descobrir o field_id antes de setar um valor.",
    inputSchema: z.object({}),
    annotations: { readOnlyHint: true, destructiveHint: false }
  }, async () => {
    try {
      const client = createClient();
      const response = await client.get("/fb/page/getCustomFields");
      const fields = response.data?.data || [];
      if (!fields.length) return { content: [{ type: "text", text: "Nenhum campo encontrado." }] };
      const formatted = fields.map(f => `• [ID: ${f.id}] ${f.name} (${f.type})`).join("\n");
      return { content: [{ type: "text", text: `Campos personalizados:\n\n${formatted}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: handleError(e) }] };
    }
  });

  server.registerTool("manychat_create_custom_field", {
    title: "Criar Campo Personalizado",
    description: "Cria um novo campo personalizado na conta ManyChat. Tipos: text, number, date, boolean, datetime.",
    inputSchema: z.object({
        name: z.string().describe("Nome do campo"),
        type: z.enum(["text", "number", "date", "boolean", "datetime"]).describe("Tipo do campo")
      }),
    annotations: { readOnlyHint: false, destructiveHint: false }
  }, async ({ name, type }) => {
    try {
      const client = createClient();
      const response = await client.post("/fb/page/createCustomField", { name, type });
      const field = response.data?.data;
      return { content: [{ type: "text", text: `Campo criado!\n\nID: ${field?.id}\nNome: ${field?.name}\nTipo: ${field?.type}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: handleError(e) }] };
    }
  });

  server.registerTool("manychat_set_custom_field", {
    title: "Setar Valor de Campo Personalizado",
    description: "Define o valor de um campo personalizado para um contato. Use manychat_get_custom_fields para descobrir o field_id.",
    inputSchema: z.object({
        subscriber_id: z.string().describe("ID do contato no ManyChat"),
        field_id: z.number().describe("ID do campo personalizado"),
        field_value: z.string().describe("Valor a definir no campo")
      }),
    annotations: { readOnlyHint: false, destructiveHint: false }
  }, async ({ subscriber_id, field_id, field_value }) => {
    try {
      const client = createClient();
      await client.post("/fb/subscriber/setCustomFieldByFieldId", { subscriber_id, field_id, field_value });
      return { content: [{ type: "text", text: `Campo atualizado!\n\nContato: ${subscriber_id}\nCampo ID: ${field_id}\nValor: ${field_value}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: handleError(e) }] };
    }
  });
}
