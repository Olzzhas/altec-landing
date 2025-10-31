#!/bin/bash

# Скрипт для обновления сайта на сервере
# Запускается на ЛОКАЛЬНОЙ машине

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SERVER="ubuntu@194.32.142.152"
REMOTE_DIR="~/altec-landing"

echo -e "${GREEN}🔄 Обновление сайта на сервере${NC}"
echo ""

# Шаг 1: Копирование файлов
echo -e "${YELLOW}📤 Копирование файлов на сервер...${NC}"
rsync -avz --progress \
  --exclude 'node_modules' \
  --exclude '.git' \
  --exclude '.next' \
  --exclude 'out' \
  --exclude '.env.local' \
  ./ "$SERVER:$REMOTE_DIR/"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Ошибка при копировании файлов${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Файлы скопированы${NC}"
echo ""

# Шаг 2: Деплой на сервере
echo -e "${YELLOW}🚀 Запуск деплоя на сервере...${NC}"
echo ""

ssh "$SERVER" "cd $REMOTE_DIR && bash deploy-local.sh"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ ОБНОВЛЕНИЕ ЗАВЕРШЕНО!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}🌐 Проверьте сайт:${NC}"
    echo -e "   http://194.32.142.152"
    echo -e "   https://td-altec.kz"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Ошибка при деплое${NC}"
    exit 1
fi

