#!/bin/bash

# Скрипт для первоначальной настройки сервера
# Запускается ОДИН РАЗ на сервере для подготовки к деплою

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔧 Настройка сервера для деплоя${NC}"
echo ""

# Проверка, что скрипт запущен с правами root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Запустите скрипт с правами root: sudo ./server-setup.sh${NC}"
    exit 1
fi

# Обновление системы
echo -e "${YELLOW}📦 Обновление системы...${NC}"
apt-get update
apt-get upgrade -y

# Установка необходимых пакетов
echo -e "${YELLOW}📦 Установка необходимых пакетов...${NC}"
apt-get install -y nginx curl wget git ufw

# Настройка firewall
echo -e "${YELLOW}🔥 Настройка firewall...${NC}"
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
echo "y" | ufw enable

# Создание директории для сайта
echo -e "${YELLOW}📁 Создание директории для сайта...${NC}"
mkdir -p /var/www/altec
chown -R www-data:www-data /var/www/altec
chmod -R 755 /var/www/altec

# Создание тестовой страницы
echo -e "${YELLOW}📄 Создание тестовой страницы...${NC}"
cat > /var/www/altec/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Altec - Сервер готов</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            text-align: center;
            padding: 40px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            backdrop-filter: blur(10px);
        }
        h1 { font-size: 48px; margin: 0 0 20px 0; }
        p { font-size: 24px; margin: 10px 0; }
        .status { color: #4ade80; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Altec</h1>
        <p class="status">✅ Сервер готов к деплою</p>
        <p>Запустите ./deploy.sh на локальной машине</p>
    </div>
</body>
</html>
EOF

# Настройка Nginx
echo -e "${YELLOW}🌐 Настройка Nginx...${NC}"
cat > /etc/nginx/sites-available/altec << 'EOF'
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

# Активация конфигурации
ln -sf /etc/nginx/sites-available/altec /etc/nginx/sites-enabled/altec
rm -f /etc/nginx/sites-enabled/default

# Проверка конфигурации Nginx
echo -e "${YELLOW}✅ Проверка конфигурации Nginx...${NC}"
nginx -t

if [ $? -eq 0 ]; then
    # Перезапуск Nginx
    systemctl restart nginx
    systemctl enable nginx
    
    echo ""
    echo -e "${GREEN}✅ Сервер успешно настроен!${NC}"
    echo ""
    echo -e "${GREEN}Что дальше:${NC}"
    echo -e "1. Откройте http://$(curl -s ifconfig.me) в браузере"
    echo -e "2. Вы должны увидеть тестовую страницу"
    echo -e "3. На локальной машине запустите: ./deploy.sh"
    echo ""
    echo -e "${YELLOW}Полезная информация:${NC}"
    echo -e "IP адрес сервера: $(curl -s ifconfig.me)"
    echo -e "Директория сайта: /var/www/altec"
    echo -e "Конфигурация Nginx: /etc/nginx/sites-available/altec"
    echo -e "Логи Nginx: /var/log/nginx/"
    echo ""
    echo -e "${YELLOW}Статус служб:${NC}"
    systemctl status nginx --no-pager -l
else
    echo -e "${RED}❌ Ошибка в конфигурации Nginx${NC}"
    exit 1
fi

