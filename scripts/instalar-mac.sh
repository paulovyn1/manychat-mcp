#!/bin/bash
set -e

echo ""
echo "=========================================="
echo "  ManyChat MCP - Instalador Triwer"
echo "=========================================="
echo ""

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js nao encontrado!"
    echo ""
    echo "Instale o Node.js em: https://nodejs.org"
    echo "Baixe a versao LTS, instale e rode este comando novamente."
    exit 1
fi

echo "✅ Node.js encontrado: $(node --version)"
echo ""

# Pedir token
echo "Cole seu token da API do ManyChat abaixo."
echo "Para obter: Configuracoes > Interface de Programacao de Aplicativos > Obtenha a chave API"
echo ""
read -p "Token: " TOKEN

if [ -z "$TOKEN" ]; then
    echo "❌ Token nao pode ser vazio!"
    exit 1
fi

# Instalar
INSTALL_DIR="$HOME/manychat-mcp"
echo ""
echo "Baixando e instalando em: $INSTALL_DIR"
echo ""

rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

echo "⏳ Baixando arquivos..."
curl -fsSL https://github.com/triwer/manychat-mcp/archive/refs/heads/main.tar.gz | tar -xz -C "$INSTALL_DIR" --strip-components=1

echo "MANYCHAT_API_TOKEN=$TOKEN" > "$INSTALL_DIR/.env"
echo "✅ Token salvo"

cd "$INSTALL_DIR"
echo ""
echo "⏳ Instalando dependencias..."
npm install
echo "✅ Dependencias instaladas"

# Configurar Claude Desktop
CLAUDE_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_CONFIG="$CLAUDE_DIR/claude_desktop_config.json"

echo ""
echo "Configurando Claude Desktop..."

if [ ! -d "$CLAUDE_DIR" ]; then
    echo "⚠️  Claude Desktop nao encontrado. Configure manualmente."
    exit 0
fi

node -e "
const fs=require('fs');
const p='$CLAUDE_CONFIG';
let c={};
if(fs.existsSync(p)){try{c=JSON.parse(fs.readFileSync(p,'utf8'));}catch(e){}}
if(!c.mcpServers)c.mcpServers={};
c.mcpServers.manychat={command:'node',args:['$INSTALL_DIR/src/index.js']};
fs.writeFileSync(p,JSON.stringify(c,null,2));
"

echo "✅ Claude Desktop configurado!"
echo ""
echo "=========================================="
echo "  Instalacao concluida! 🎉"
echo "=========================================="
echo ""
echo "Proximos passos:"
echo "1. Feche o Claude Desktop completamente"
echo "2. Abra novamente"
echo "3. As ferramentas do ManyChat estarao disponiveis!"
echo ""
