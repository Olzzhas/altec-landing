#!/bin/bash

# Скрипт для настройки домена
# Запускается на сервере

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🌐 Настройка домена для Altec${NC}"
echo ""

# Запрос домена
read -p "Введите ваш домен (например, example.com): " DOMAIN

if [ -z "$DOMAIN" ]; then
    echo -e "${RED}❌ Домен не указан${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Домен: $DOMAIN${NC}"
echo -e "${YELLOW}С www: www.$DOMAIN${NC}"
echo ""

read -p "Продолжить? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Отменено"
    exit 0
fi

echo ""

# Обновление конфигурации Nginx
echo -e "${YELLOW}⚙️  Обновление конфигурации Nginx...${NC}"

sudo tee /etc/nginx/sites-available/altec > /dev/null << EOF
server {
    listen 80;
    listen [::]:80;
    
    server_name $DOMAIN www.$DOMAIN;
    
    root /var/www/altec;
    index index.html;
    
    location / {
        try_files \$uri \$uri.html \$uri/ =404;
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

# Проверка конфигурации
echo -e "${YELLOW}✅ Проверка конфигурации...${NC}"
sudo nginx -t

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Ошибка в конфигурации Nginx${NC}"
    exit 1
fi

# Перезагрузка Nginx
echo -e "${YELLOW}🔄 Перезагрузка Nginx...${NC}"
sudo systemctl reload nginx

echo ""
echo -e "${GREEN}✅ Домен настроен!${NC}"
echo ""
echo -e "${YELLOW}🌐 Сайт доступен по адресу:${NC}"
echo -e "   http://$DOMAIN"
echo -e "   http://www.$DOMAIN"
echo ""
echo -e "${YELLOW}⚠️  Убедитесь, что DNS записи настроены:${NC}"
echo -e "   Тип: A"
echo -e "   Имя: @"
echo -e "   Значение: 194.32.142.152"
echo ""
echo -e "${YELLOW}   Тип: A"
echo -e "   Имя: www"
echo -e "   Значение: 194.32.142.152"
echo ""
echo -e "${YELLOW}🔒 Для установки SSL сертификата запустите:${NC}"
echo -e "   bash setup-ssl.sh"
echo ""

