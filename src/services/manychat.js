import axios from "axios";
import * as dotenv from "dotenv";
dotenv.config();

const BASE_URL = "https://api.manychat.com";

export function createClient() {
  const token = process.env.MANYCHAT_API_TOKEN;
  if (!token) throw new Error("MANYCHAT_API_TOKEN nao encontrado no arquivo .env");
  return axios.create({
    baseURL: BASE_URL,
    headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
    timeout: 15000,
  });
}

export function handleError(error) {
  if (axios.isAxiosError(error)) {
    const status = error.response?.status;
    const msg = error.response?.data?.message || error.message;
    if (status === 401) return "Erro 401: Token invalido ou expirado.";
    if (status === 403) return "Erro 403: Sem permissao para esta acao.";
    if (status === 404) return `Erro 404: Recurso nao encontrado. ${msg}`;
    if (status === 422) return `Erro 422: Dados invalidos. ${msg}`;
    if (status === 429) return "Erro 429: Limite de requisicoes atingido. Aguarde e tente novamente.";
    return `Erro da API ManyChat (${status}): ${msg}`;
  }
  if (error instanceof Error) return `Erro: ${error.message}`;
  return "Erro desconhecido";
}
