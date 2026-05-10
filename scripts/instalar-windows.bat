@echo off
echo.
echo ==========================================
echo   ManyChat MCP - Instalador Triwer
echo ==========================================
echo.

node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Node.js nao encontrado!
    echo.
    echo Instale o Node.js em: https://nodejs.org
    echo Baixe a versao LTS e instale normalmente.
    echo Depois rode este script novamente.
    echo.
    pause
    exit /b 1
)

echo [OK] Node.js encontrado
echo.

echo Cole seu token da API do ManyChat abaixo.
echo Para obter: Configuracoes ^> Interface de Programacao de Aplicativos ^> Obtenha a chave API
echo.
set /p TOKEN="Token: "

if "%TOKEN%"=="" (
    echo [ERRO] Token nao pode ser vazio!
    pause
    exit /b 1
)

set INSTALL_DIR=%USERPROFILE%\manychat-mcp
echo.
echo Instalando em: %INSTALL_DIR%

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

set ROOT_DIR=%~dp0..
xcopy /E /I /Y "%ROOT_DIR%\*" "%INSTALL_DIR%\" >nul 2>&1

echo MANYCHAT_API_TOKEN=%TOKEN%> "%INSTALL_DIR%\.env"
echo [OK] Token salvo

cd /d "%INSTALL_DIR%"
echo.
echo Instalando dependencias (aguarde)...
call npm install
if %errorlevel% neq 0 (
    echo [ERRO] Falha ao instalar dependencias
    pause
    exit /b 1
)
echo [OK] Dependencias instaladas

set CLAUDE_DIR=%APPDATA%\Claude
set CLAUDE_CONFIG=%APPDATA%\Claude\claude_desktop_config.json

echo.
echo Configurando Claude Desktop...

if not exist "%CLAUDE_DIR%" (
    echo [AVISO] Claude Desktop nao encontrado. Configure manualmente.
    pause
    exit /b 0
)

node -e "const fs=require('fs');const p='%CLAUDE_CONFIG:\=\\%';let c={};if(fs.existsSync(p)){try{c=JSON.parse(fs.readFileSync(p,'utf8'));}catch(e){}}if(!c.mcpServers)c.mcpServers={};c.mcpServers.manychat={command:'node',args:['%INSTALL_DIR:\=/%/src/index.js']};fs.writeFileSync(p,JSON.stringify(c,null,2));console.log('OK');"

if %errorlevel% equ 0 (
    echo [OK] Claude Desktop configurado!
) else (
    echo [AVISO] Configure manualmente: %CLAUDE_CONFIG%
)

echo.
echo ==========================================
echo   Instalacao concluida com sucesso!
echo ==========================================
echo.
echo Proximos passos:
echo 1. Feche e abra o Claude Desktop
echo 2. As ferramentas do ManyChat estarao disponiveis!
echo.
pause
