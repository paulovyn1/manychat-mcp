# ManyChat MCP - Instalador Triwer
# Execute no PowerShell como administrador

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  ManyChat MCP - Instalador Triwer" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Node.js
try {
    $nodeVersion = node --version
    Write-Host "[OK] Node.js encontrado: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERRO] Node.js nao encontrado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Instale o Node.js em: https://nodejs.org"
    Write-Host "Baixe a versao LTS e instale normalmente."
    Write-Host "Depois rode este script novamente."
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host ""

# Pedir token
Write-Host "Cole seu token da API do ManyChat abaixo."
Write-Host "Para obter: Configuracoes > Interface de Programacao de Aplicativos > Obtenha a chave API"
Write-Host ""
$TOKEN = Read-Host "Token"

if ([string]::IsNullOrWhiteSpace($TOKEN)) {
    Write-Host "[ERRO] Token nao pode ser vazio!" -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit 1
}

# Definir pasta de instalacao
$INSTALL_DIR = "$env:USERPROFILE\manychat-mcp"
Write-Host ""
Write-Host "Instalando em: $INSTALL_DIR"

# Baixar arquivos do GitHub
Write-Host ""
Write-Host "Baixando arquivos (aguarde)..." -ForegroundColor Yellow

if (Test-Path $INSTALL_DIR) {
    Remove-Item -Recurse -Force $INSTALL_DIR
}
New-Item -ItemType Directory -Path $INSTALL_DIR | Out-Null

$REPO_URL = "https://github.com/paulovyn1/manychat-mcp/archive/refs/heads/main.zip"
$ZIP_PATH = "$env:TEMP\manychat-mcp.zip"

Invoke-WebRequest -Uri $REPO_URL -OutFile $ZIP_PATH
Expand-Archive -Path $ZIP_PATH -DestinationPath "$env:TEMP\manychat-mcp-extract" -Force
Copy-Item -Recurse -Force "$env:TEMP\manychat-mcp-extract\manychat-mcp-main\*" $INSTALL_DIR
Remove-Item $ZIP_PATH -Force
Remove-Item -Recurse -Force "$env:TEMP\manychat-mcp-extract"

Write-Host "[OK] Arquivos baixados" -ForegroundColor Green

# Salvar token
"MANYCHAT_API_TOKEN=$TOKEN" | Out-File -FilePath "$INSTALL_DIR\.env" -Encoding utf8
Write-Host "[OK] Token salvo" -ForegroundColor Green

# Instalar dependencias
Set-Location $INSTALL_DIR
Write-Host ""
Write-Host "Instalando dependencias (aguarde)..." -ForegroundColor Yellow
npm install
Write-Host "[OK] Dependencias instaladas" -ForegroundColor Green

# Configurar Claude Desktop
$CLAUDE_DIR = "$env:APPDATA\Claude"
$CLAUDE_CONFIG = "$CLAUDE_DIR\claude_desktop_config.json"

Write-Host ""
Write-Host "Configurando Claude Desktop..."

if (-not (Test-Path $CLAUDE_DIR)) {
    Write-Host "[AVISO] Claude Desktop nao encontrado. Configure manualmente." -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 0
}

$INDEX_PATH = "$INSTALL_DIR\src\index.js" -replace "\\", "/"

$CONFIG = @{}
if (Test-Path $CLAUDE_CONFIG) {
    try {
        $CONFIG = Get-Content $CLAUDE_CONFIG -Raw | ConvertFrom-Json -AsHashtable
    } catch {}
}

if (-not $CONFIG.ContainsKey("mcpServers")) {
    $CONFIG["mcpServers"] = @{}
}

$CONFIG["mcpServers"]["manychat"] = @{
    command = "node"
    args = @($INDEX_PATH)
}

$CONFIG | ConvertTo-Json -Depth 10 | Out-File -FilePath $CLAUDE_CONFIG -Encoding utf8
Write-Host "[OK] Claude Desktop configurado!" -ForegroundColor Green

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Instalacao concluida com sucesso!" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Proximos passos:"
Write-Host "1. Feche o Claude Desktop completamente (botao direito na bandeja > Sair)"
Write-Host "2. Abra o Claude Desktop novamente"
Write-Host "3. As ferramentas do ManyChat estarao disponiveis!"
Write-Host ""
Read-Host "Pressione Enter para sair"
