# ManyChat MCP — Triwer

Integração do Claude Desktop com o ManyChat via MCP (Model Context Protocol).

Com isso instalado, você consegue pedir diretamente no Claude coisas como:

- "Liste todas as tags da minha conta ManyChat"
- "Adicione a tag 'Lead Quente' ao contato 7654321"
- "Dispare o flow de boas-vindas para o contato 1234567"
- "Crie um campo personalizado chamado Produto de interesse"

---

## Pre-requisitos

Antes de instalar, garanta que voce tem:

1. **Claude Desktop** instalado — baixe em: https://claude.ai/download
2. **Plano pago do Claude** (Pro ou superior)
3. **Node.js LTS** instalado — baixe em: https://nodejs.org
4. **Token da API do ManyChat** — veja como obter abaixo

### Como obter o token do ManyChat

1. Acesse sua conta em app.manychat.com
2. Va em **Configuracoes** (icone de engrenagem)
3. Clique em **Interface de Programacao de Aplicativos**
4. Clique em **Obtenha a chave API**
5. Copie o token gerado

---

## Instalacao com comando unico (recomendado)

### Windows

Abra o **PowerShell** e cole:

```powershell
irm https://raw.githubusercontent.com/paulovyn1/manychat-mcp/main/scripts/instalar-windows.ps1 | iex
```

### Mac

Abra o **Terminal** e cole:

```bash
curl -fsSL https://raw.githubusercontent.com/paulovyn1/manychat-mcp/main/scripts/instalar-mac.sh | bash
```

Cole seu token quando solicitado. Depois feche e abra o Claude Desktop.

---

## Ferramentas disponiveis

### Campos Personalizados

| Ferramenta | O que faz |
|---|---|
| `manychat_get_custom_fields` | Lista todos os campos da conta |
| `manychat_create_custom_field` | Cria um novo campo |
| `manychat_set_custom_field` | Seta valor de um campo para um contato |

### Tags

| Ferramenta | O que faz |
|---|---|
| `manychat_get_tags` | Lista todas as tags da conta |
| `manychat_create_tag` | Cria uma nova tag |
| `manychat_add_tag_to_subscriber` | Adiciona tag a um contato |
| `manychat_remove_tag_from_subscriber` | Remove tag de um contato |

### Flows

| Ferramenta | O que faz |
|---|---|
| `manychat_get_flows` | Lista todos os flows da conta |
| `manychat_send_flow` | Dispara um flow para um contato |

---

## Como usar no Claude

Exemplos de prompts:

```
Liste todas as tags da minha conta ManyChat
```
```
Existe uma tag chamada "aluno-cp" na minha conta?
```
```
Adicione a tag [ID] ao contato [subscriber_id]
```
```
Liste todos os flows da minha conta
```
```
Dispare o flow [flow_ns] para o contato [subscriber_id]
```
```
Crie um campo personalizado chamado "Produto de interesse" do tipo texto
```

---

## Atualizar o token

Edite o arquivo `.env` na pasta de instalacao:

- **Windows:** `C:\Users\[seu-usuario]\manychat-mcp\.env`
- **Mac:** `~/manychat-mcp/.env`

Troque o valor de `MANYCHAT_API_TOKEN` e reinicie o Claude Desktop.

---

## Problemas comuns

**MCP nao aparece no Claude**
- Feche completamente (botao direito na bandeja > Sair) e abra de novo

**"Token invalido"**
- Verifique o token em Configuracoes > Interface de Programacao de Aplicativos

**PowerShell bloqueou o script**
- Execute: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`
- Depois rode o comando de instalacao novamente

---

Feito com amor pelo Triwer
