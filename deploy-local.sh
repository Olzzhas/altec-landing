#!/bin/bash

# Скрипт для деплоя ПРЯМО НА СЕРВЕРЕ
# Просто запустите: bash deploy-local.sh

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🚀 Деплой Altec${NC}"
echo ""

# Директории
PROJECT_DIR="$HOME/altec-landing"
WEB_DIR="/var/www/altec"

# Шаг 1: Проверка Node.js
echo -e "${YELLOW}📦 Проверка Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js не установлен${NC}"
    echo -e "${YELLOW}Устанавливаю Node.js...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
    sudo apt-get install -y nodejs
fi

echo -e "${GREEN}✅ Node.js: $(node --version)${NC}"
echo -e "${GREEN}✅ npm: $(npm --version)${NC}"
echo ""

# Шаг 2: Переход в директорию проекта
echo -e "${YELLOW}📁 Переход в директорию проекта...${NC}"
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}❌ Директория $PROJECT_DIR не найдена${NC}"
    exit 1
fi

cd "$PROJECT_DIR"
echo -e "${GREEN}✅ $(pwd)${NC}"
echo ""

# Шаг 3: Установка зависимостей
echo -e "${YELLOW}📦 Установка зависимостей...${NC}"
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Ошибка при установке зависимостей${NC}"
    exit 1
fi
echo ""

# Шаг 4: Сборка проекта
echo -e "${YELLOW}🔨 Сборка проекта...${NC}"
npm run build
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Ошибка при сборке${NC}"
    exit 1
fi
echo ""

# Шаг 5: Проверка результата сборки
if [ ! -d "out" ]; then
    echo -e "${RED}❌ Директория out не найдена${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Проект собран${NC}"
echo ""

# Шаг 6: Установка Nginx
echo -e "${YELLOW}🌐 Проверка Nginx...${NC}"
if ! command -v nginx &> /dev/null; then
    echo -e "${YELLOW}Устанавливаю Nginx...${NC}"
    sudo apt-get update
    sudo apt-get install -y nginx
fi

echo -e "${GREEN}✅ Nginx установлен${NC}"
echo ""

# Шаг 7: Копирование файлов
echo -e "${YELLOW}📤 Копирование файлов в $WEB_DIR...${NC}"
sudo mkdir -p "$WEB_DIR"
sudo rm -rf "$WEB_DIR"/*
sudo cp -r out/* "$WEB_DIR"/
sudo chown -R www-data:www-data "$WEB_DIR"
sudo chmod -R 755 "$WEB_DIR"

echo -e "${GREEN}✅ Файлы скопированы${NC}"
echo ""

# Шаг 8: Настройка Nginx
echo -e "${YELLOW}⚙️  Настройка Nginx...${NC}"

# Проверяем, есть ли уже настроенный домен
CURRENT_DOMAIN=$(grep -oP 'server_name \K[^;]+' /etc/nginx/sites-available/altec 2>/dev/null | head -1 | xargs)

if [ -n "$CURRENT_DOMAIN" ] && [ "$CURRENT_DOMAIN" != "_" ]; then
    echo -e "${GREEN}✅ Домен уже настроен: $CURRENT_DOMAIN${NC}"
    echo -e "${YELLOW}Конфигурация Nginx не изменена${NC}"
else
    echo -e "${YELLOW}Создание базовой конфигурации...${NC}"
    sudo tee /etc/nginx/sites-available/altec > /dev/null << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/altec;
    index index.html;

    server_name _;

    location / {
        try_files $uri $uri.html $uri/ =404;
    }

    # Кэширование статических файлов
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Gzip сжатие
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript application/json;
}
EOF
fi

# Активация конфигурации
sudo ln -sf /etc/nginx/sites-available/altec /etc/nginx/sites-enabled/altec
sudo rm -f /etc/nginx/sites-enabled/default

# Проверка конфигурации
sudo nginx -t
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Ошибка в конфигурации Nginx${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Nginx настроен${NC}"
echo ""

# Шаг 9: Перезапуск Nginx
echo -e "${YELLOW}🔄 Перезапуск Nginx...${NC}"
sudo systemctl restart nginx
sudo systemctl enable nginx

echo -e "${GREEN}✅ Nginx перезапущен${NC}"
echo ""

# Получить IP адрес
IP=$(hostname -I | awk '{print $1}')
if [ -z "$IP" ]; then
    IP=$(curl -s ifconfig.me 2>/dev/null || echo "194.32.142.152")
fi

# Финал
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ ДЕПЛОЙ ЗАВЕРШЕН УСПЕШНО!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}🌐 Сайт доступен по адресу:${NC}"
echo -e "${GREEN}   http://$IP${NC}"
echo ""
echo -e "${YELLOW}📁 Файлы находятся в:${NC}"
echo -e "   $WEB_DIR"
echo ""
echo -e "${YELLOW}📝 Логи Nginx:${NC}"
echo -e "   sudo tail -f /var/log/nginx/error.log"
echo ""
echo -e "${YELLOW}🔄 Для обновления просто запустите снова:${NC}"
echo -e "   bash deploy-local.sh"
echo ""

