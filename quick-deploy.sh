#!/bin/bash

# Быстрый деплой без лишних вопросов
# Использовать когда Nginx уже настроен и нужно только обновить файлы

# Загрузка конфигурации из .env.deploy если файл существует
if [ -f .env.deploy ]; then
    export $(cat .env.deploy | grep -v '^#' | xargs)
fi

SERVER_IP="${DEPLOY_SERVER_IP:-194.32.142.152}"
SERVER_USER="${DEPLOY_SERVER_USER:-root}"
REMOTE_DIR="${DEPLOY_REMOTE_DIR:-/var/www/altec}"
BUILD_DIR="${DEPLOY_BUILD_DIR:-./out}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}⚡ Быстрый деплой...${NC}"

# Сборка
echo -e "${YELLOW}📦 Сборка проекта...${NC}"
npm run build

# Копирование
echo -e "${YELLOW}📤 Копирование файлов...${NC}"
rsync -avz --delete ${BUILD_DIR}/ ${SERVER_USER}@${SERVER_IP}:${REMOTE_DIR}/

# Перезагрузка Nginx
echo -e "${YELLOW}🔄 Перезагрузка Nginx...${NC}"
ssh ${SERVER_USER}@${SERVER_IP} "systemctl reload nginx"

echo -e "${GREEN}✅ Готово! http://${SERVER_IP}${NC}"

