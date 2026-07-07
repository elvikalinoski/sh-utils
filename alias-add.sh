#!/bin/bash
#
# alias-add.sh - Cria chave SSH e alias para conexão a servidores
#
# Uso: ./alias-add.sh <usuario> <nome_servidor> <ip_servidor>
#

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Validação de parâmetros
if [ $# -lt 3 ]; then
    echo -e "${RED}Erro: Parâmetros insuficientes.${NC}"
    echo ""
    echo "Uso: $0 <usuario> <nome_servidor> <ip_servidor>"
    echo ""
    echo "Exemplo: $0 ec2-user meu-servidor 10.0.1.50"
    exit 1
fi

USUARIO="$1"
NOME_SERVIDOR="$2"
IP_SERVIDOR="$3"
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
    echo -e "${YELLOW}Aviso: Chave SSH '${NOME_SERVIDOR}' já existe em ${SSH_DIR}/${NC}"
    read -p "Deseja sobrescrever? (s/N): " RESPOSTA
    if [[ ! "$RESPOSTA" =~ ^[sS]$ ]]; then
        echo "Operação cancelada."
        exit 0
    fi
fi

# Gerar chave SSH
echo -e "${GREEN}Gerando chave SSH para '${NOME_SERVIDOR}'...${NC}"
ssh-keygen -t ed25519 -f "$CHAVE_PATH" -N "" -C "${NOME_SERVIDOR}" -q

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
    echo -e "${YELLOW}Aviso: Alias '${NOME_SERVIDOR}' já existe em ${SHELL_RC}${NC}"
    read -p "Deseja atualizar? (s/N): " RESPOSTA
    if [[ ! "$RESPOSTA" =~ ^[sS]$ ]]; then
        echo "Alias não foi atualizado."
        exit 0
    fi
    # Remover alias existente
    sed -i.bak "/alias ${NOME_SERVIDOR}=/d" "$SHELL_RC"
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
echo -e "${YELLOW}Chave pública para copiar ao servidor:${NC}"
cat "${CHAVE_PATH}.pub"
echo ""

# Aplicar o source para ativar o alias na sessão atual
echo -e "${GREEN}Ativando alias na sessão atual...${NC}"
source "$SHELL_RC"
echo -e "${GREEN}Alias '${NOME_SERVIDOR}' pronto para uso.${NC}"
