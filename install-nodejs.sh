#!/bin/bash

# Скрипт для установки Node.js на Ubuntu сервере
# Запустите на сервере: bash install-nodejs.sh

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}📦 Установка Node.js и npm${NC}"
echo ""

# Проверка прав
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Запустите с правами root: sudo bash install-nodejs.sh${NC}"
    exit 1
fi

# Обновление системы
echo -e "${YELLOW}🔄 Обновление системы...${NC}"
apt-get update

# Установка curl если его нет
echo -e "${YELLOW}📦 Установка curl...${NC}"
apt-get install -y curl

# Установка Node.js 20.x (LTS версия)
echo -e "${YELLOW}📦 Добавление репозитория Node.js...${NC}"
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

echo -e "${YELLOW}📦 Установка Node.js и npm...${NC}"
apt-get install -y nodejs

# Проверка установки
echo ""
echo -e "${GREEN}✅ Установка завершена!${NC}"
echo ""
echo -e "${YELLOW}Версии:${NC}"
node --version
npm --version

echo ""
echo -e "${GREEN}Теперь можно собрать проект:${NC}"
echo -e "  cd ~/altec-landing"
echo -e "  npm install"
echo -e "  npm run build"

