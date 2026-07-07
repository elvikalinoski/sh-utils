#!/bin/bash
#
# alias-add.sh - Cria chave SSH e alias para conexão a servidores
#
# Uso remoto:
#   curl -fsSL https://raw.githubusercontent.com/elvikalinoski/sh-utils/main/alias-add.sh | bash -s -- <nome_servidor> <ip_servidor> [usuario]
#
# Uso local:
#   ./alias-add.sh <nome_servidor> <ip_servidor> [usuario]
#
# Se o usuário não for informado, usa o usuário atual do terminal (whoami).
#

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detectar se está rodando de forma interativa (terminal) ou via pipe
INTERATIVO=false
if [ -t 0 ]; then
    INTERATIVO=true
fi

# Validação de parâmetros
if [ $# -lt 2 ]; then
    echo -e "${RED}Erro: Parâmetros insuficientes.${NC}"
    echo ""
    echo "Uso: $0 <nome_servidor> <ip_servidor> [usuario]"
    echo ""
    echo "Se o usuário não for informado, será usado o usuário atual do terminal ($(whoami))."
    echo ""
    echo "Exemplos:"
    echo "  curl -fsSL https://raw.githubusercontent.com/elvikalinoski/sh-utils/main/alias-add.sh | bash -s -- meu-servidor 10.0.1.50"
    echo "  curl -fsSL https://raw.githubusercontent.com/elvikalinoski/sh-utils/main/alias-add.sh | bash -s -- meu-servidor 10.0.1.50 ec2-user"
    exit 1
fi

NOME_SERVIDOR="$1"
IP_SERVIDOR="$2"
USUARIO="${3:-$(whoami)}"
SSH_DIR="$HOME/.ssh"
CHAVE_PATH="${SSH_DIR}/${NOME_SERVIDOR}"

# Criar diretório .ssh se não existir
if [ ! -d "$SSH_DIR" ]; then
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    echo -e "${GREEN}Diretório ~/.ssh criado.${NC}"
fi

# Verificar se a chave já existe
if [ -f "$CHAVE_PATH" ]; then
    if [ "$INTERATIVO" = true ]; then
        echo -e "${YELLOW}Aviso: Chave SSH '${NOME_SERVIDOR}' já existe em ${SSH_DIR}/${NC}"
        read -p "Deseja sobrescrever? (s/N): " RESPOSTA
        if [[ ! "$RESPOSTA" =~ ^[sS]$ ]]; then
            echo "Operação cancelada."
            exit 0
        fi
    else
        echo -e "${YELLOW}Chave SSH '${NOME_SERVIDOR}' já existe. Sobrescrevendo...${NC}"
    fi
fi

# Gerar chave SSH
echo -e "${GREEN}Gerando chave SSH para '${NOME_SERVIDOR}'...${NC}"
ssh-keygen -t ed25519 -f "$CHAVE_PATH" -N "" -C "${NOME_SERVIDOR}" -q <<< y

chmod 600 "$CHAVE_PATH"
chmod 644 "${CHAVE_PATH}.pub"

echo -e "${GREEN}Chave SSH criada em: ${CHAVE_PATH}${NC}"

# Detectar shell do usuário
SHELL_ATUAL=$(basename "$SHELL")

case "$SHELL_ATUAL" in
    zsh)
        SHELL_RC="$HOME/.zshrc"
        ;;
    bash)
        SHELL_RC="$HOME/.bashrc"
        ;;
    *)
        echo -e "${YELLOW}Shell '${SHELL_ATUAL}' não reconhecido. Usando .bashrc como padrão.${NC}"
        SHELL_RC="$HOME/.bashrc"
        ;;
esac

# Definir o alias
ALIAS_CMD="alias ${NOME_SERVIDOR}='ssh -i ${CHAVE_PATH} ${USUARIO}@${IP_SERVIDOR}'"

# Verificar se o alias já existe no arquivo
if grep -q "alias ${NOME_SERVIDOR}=" "$SHELL_RC" 2>/dev/null; then
    if [ "$INTERATIVO" = true ]; then
        echo -e "${YELLOW}Aviso: Alias '${NOME_SERVIDOR}' já existe em ${SHELL_RC}${NC}"
        read -p "Deseja atualizar? (s/N): " RESPOSTA
        if [[ ! "$RESPOSTA" =~ ^[sS]$ ]]; then
            echo "Alias não foi atualizado."
            exit 0
        fi
    else
        echo -e "${YELLOW}Alias '${NOME_SERVIDOR}' já existe. Atualizando...${NC}"
    fi
    # Remover alias existente e seu comentário
    sed -i.bak "/# SSH alias para ${NOME_SERVIDOR}/d;/alias ${NOME_SERVIDOR}=/d" "$SHELL_RC"
    rm -f "${SHELL_RC}.bak"
fi

# Adicionar alias ao arquivo de configuração do shell
echo "" >> "$SHELL_RC"
echo "# SSH alias para ${NOME_SERVIDOR} (adicionado por alias-add.sh)" >> "$SHELL_RC"
echo "$ALIAS_CMD" >> "$SHELL_RC"

echo -e "${GREEN}Alias adicionado em: ${SHELL_RC}${NC}"
echo ""
echo -e "${GREEN}=== Resumo ===${NC}"
echo "  Servidor:  ${NOME_SERVIDOR}"
echo "  Usuário:   ${USUARIO}"
echo "  IP:        ${IP_SERVIDOR}"
echo "  Chave:     ${CHAVE_PATH}"
echo "  Shell RC:  ${SHELL_RC}"
echo ""
echo -e "${YELLOW}Chave pública (copie para o servidor):${NC}"
cat "${CHAVE_PATH}.pub"
echo ""
echo -e "${GREEN}Para ativar o alias agora, execute:${NC}"
echo "  source ${SHELL_RC}"
echo ""
echo -e "${GREEN}Depois basta digitar: ${NOME_SERVIDOR}${NC}"
