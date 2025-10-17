@echo off
REM push_to_github.cmd
REM Uso: execute este arquivo no diretório do projeto (duplo clique ou via cmd)
REM Observações: Git deve estar instalado e disponível no PATH. O script pedirá suas credenciais GitHub se necessário.

SETLOCAL ENABLEDELAYEDEXPANSION

REM Configurações do repositório remoto — ALTERE se necessário
set REPO_URL=https://github.com/diegogobbisdev/Yu-Gi-Oh-Jokenp-Edition.git
set BRANCH=main

echo Verificando se estamos no diretório correto...
cd /d "%~dp0"
echo Diretório atual: %CD%

REM Inicializa git se necessário
if not exist .git (
    echo Inicializando repositório git...
    git init
) else (
    echo Repositório git já inicializado.
)

REM Adiciona remote se não existir
for /f "tokens=*" %%R in ('git remote') do set FOUND_REMOTE=%%R
if "%FOUND_REMOTE%"=="" (
    echo Adicionando remote origin: %REPO_URL%
    git remote add origin %REPO_URL%
) else (
    echo Remote(s) existentes: 
    git remote -v
)

REM Cria branch principal se não existir
git rev-parse --verify %BRANCH% >nul 2>&1
if errorlevel 1 (
    echo Criando branch %BRANCH%...
    git checkout -b %BRANCH%
) else (
    echo Branch %BRANCH% existe.
    git checkout %BRANCH%
)

REM Adiciona todos arquivos, com exceção do que estiver em .gitignore
echo Adicionando arquivos ao commit...
git add -A

REM Commit inicial — usa mensagem padrão se não especificado
set /p CMMSG=Digite a mensagem de commit (pressione Enter para usar "Initial commit"): 
if "%CMMSG%"=="" set CMMSG=Initial commit
git commit -m "%CMMSG%" || (
    echo Nenhuma alteração para commitar ou commit falhou.
)

REM Push para origin
echo Enviando para %REPO_URL% branch %BRANCH%...
git push -u origin %BRANCH%

echo Feito. Verifique o GitHub para confirmar os arquivos enviados.
pause
