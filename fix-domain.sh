#!/bin/bash

# Скрипт для восстановления домена
# Запускается на СЕРВЕРЕ

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DOMAIN="td-altec.kz"

echo -e "${GREEN}🔧 Восстановление домена: $DOMAIN${NC}"
echo ""

# Проверка текущей конфигурации
echo -e "${YELLOW}📋 Текущая конфигурация Nginx:${NC}"
if [ -f /etc/nginx/sites-available/altec ]; then
    grep "server_name" /etc/nginx/sites-available/altec
else
    echo -e "${RED}❌ Файл конфигурации не найден${NC}"
fi
echo ""

# Обновление конфигурации
echo -e "${YELLOW}⚙️  Обновление конфигурации Nginx...${NC}"

sudo tee /etc/nginx/sites-available/altec > /dev/null << 'EOF'
server {
    listen 80;
    listen [::]:80;
    
    server_name td-altec.kz www.td-altec.kz;
    
    root /var/www/altec;
    index index.html;
    
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

echo -e "${GREEN}✅ Конфигурация обновлена${NC}"
echo ""

# Проверка конфигурации
echo -e "${YELLOW}✅ Проверка конфигурации...${NC}"
sudo nginx -t

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Ошибка в конфигурации Nginx${NC}"
    exit 1
fi

echo ""

# Перезагрузка Nginx
echo -e "${YELLOW}🔄 Перезагрузка Nginx...${NC}"
sudo systemctl reload nginx

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ ДОМЕН ВОССТАНОВЛЕН!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}🌐 Сайт доступен по адресам:${NC}"
    echo -e "   http://$DOMAIN"
    echo -e "   http://www.$DOMAIN"
    echo ""
    echo -e "${YELLOW}📋 Новая конфигурация:${NC}"
    grep "server_name" /etc/nginx/sites-available/altec
    echo ""
    
    # Проверка доступности
    echo -e "${YELLOW}🔍 Проверка доступности...${NC}"
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://$DOMAIN" 2>/dev/null)
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "301" ] || [ "$HTTP_CODE" = "302" ]; then
        echo -e "${GREEN}✅ Сайт доступен (HTTP $HTTP_CODE)${NC}"
    else
        echo -e "${YELLOW}⚠️  HTTP код: $HTTP_CODE${NC}"
    fi
    echo ""
else
    echo -e "${RED}❌ Ошибка при перезагрузке Nginx${NC}"
    exit 1
fi

