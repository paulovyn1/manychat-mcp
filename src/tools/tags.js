import { createClient, handleError } from "../services/manychat.js";
import { z } from "zod";

export function registerTagTools(server) {

  server.registerTool("manychat_get_tags", {
    title: "Buscar Tags",
    description: "Lista todas as tags da conta ManyChat. Use para descobrir o tag_id antes de aplicar em um contato.",
    inputSchema: z.object({}),
    annotations: { readOnlyHint: true, destructiveHint: false }
  }, async () => {
    try {
      const client = createClient();
      const response = await client.get("/fb/page/getTags");
      const tags = response.data?.data || [];
      if (!tags.length) return { content: [{ type: "text", text: "Nenhuma tag encontrada." }] };
      const formatted = tags.map(t => `• [ID: ${t.id}] ${t.name}`).join("\n");
      return { content: [{ type: "text", text: `Tags:\n\n${formatted}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: handleError(e) }] };
    }
  });

  server.registerTool("manychat_create_tag", {
    title: "Criar Tag",
    description: "Cria uma nova tag na conta ManyChat.",
    inputSchema: z.object({ name: z.string().describe("Nome da tag") }),
    annotations: { readOnlyHint: false, destructiveHint: false }
  }, async ({ name }) => {
    try {
      const client = createClient();
      const response = await client.post("/fb/page/createTag", { name });
      const tag = response.data?.data;
      return { content: [{ type: "text", text: `Tag criada!\n\nID: ${tag?.id}\nNome: ${tag?.name}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: handleError(e) }] };
    }
  });

  server.registerTool("manychat_add_tag_to_subscriber", {
    title: "Adicionar Tag ao Contato",
    description: "Adiciona uma tag a um contato no ManyChat. Use manychat_get_tags para descobrir o tag_id.",
    inputSchema: z.object({
        subscriber_id: z.string().describe("ID do contato no ManyChat"),
        tag_id: z.number().describe("ID da tag")
      }),
    annotations: { readOnlyHint: false, destructiveHint: false }
  }, async ({ subscriber_id, tag_id }) => {
    try {
      const client = createClient();
      await client.post("/fb/subscriber/addTag", { subscriber_id, tag_id });
      return { content: [{ type: "text", text: `Tag adicionada!\n\nContato: ${subscriber_id}\nTag ID: ${tag_id}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: handleError(e) }] };
    }
  });

  server.registerTool("manychat_remove_tag_from_subscriber", {
    title: "Remover Tag do Contato",
    description: "Remove uma tag de um contato no ManyChat.",
    inputSchema: z.object({
        subscriber_id: z.string().describe("ID do contato no ManyChat"),
        tag_id: z.number().describe("ID da tag a remover")
      }),
    annotations: { readOnlyHint: false, destructiveHint: true }
  }, async ({ subscriber_id, tag_id }) => {
    try {
      const client = createClient();
      await client.post("/fb/subscriber/removeTag", { subscriber_id, tag_id });
      return { content: [{ type: "text", text: `Tag removida!\n\nContato: ${subscriber_id}\nTag ID: ${tag_id}` }] };
    } catch (e) {
      return { content: [{ type: "text", text: handleError(e) }] };
    }
  });
}
