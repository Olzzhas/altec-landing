#!/bin/bash

# Загрузка конфигурации из .env.deploy если файл существует
if [ -f .env.deploy ]; then
    export $(cat .env.deploy | grep -v '^#' | xargs)
fi

# Конфигурация (можно переопределить через .env.deploy)
SERVER_IP="${DEPLOY_SERVER_IP:-194.32.142.152}"
SERVER_USER="${DEPLOY_SERVER_USER:-root}"
REMOTE_DIR="${DEPLOY_REMOTE_DIR:-/var/www/altec}"
BUILD_DIR="${DEPLOY_BUILD_DIR:-./out}"

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Начинаем деплой лендинга на сервер ${SERVER_IP}${NC}"

# Шаг 1: Проверка наличия билда
echo -e "${YELLOW}📦 Проверка наличия билда...${NC}"
if [ ! -d "$BUILD_DIR" ]; then
    echo -e "${YELLOW}Билд не найден. Создаем новый билд...${NC}"
    npm run build
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Ошибка при сборке проекта${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Билд найден${NC}"
    read -p "Пересобрать проект? (y/n): " rebuild
    if [ "$rebuild" = "y" ] || [ "$rebuild" = "Y" ]; then
        npm run build
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Ошибка при сборке проекта${NC}"
            exit 1
        fi
    fi
fi

# Шаг 2: Создание директории на сервере
echo -e "${YELLOW}📁 Создание директории на сервере...${NC}"
ssh ${SERVER_USER}@${SERVER_IP} "mkdir -p ${REMOTE_DIR}"
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Ошибка при подключении к серверу${NC}"
    exit 1
fi

# Шаг 3: Копирование файлов на сервер
echo -e "${YELLOW}📤 Копирование файлов на сервер...${NC}"
rsync -avz --delete ${BUILD_DIR}/ ${SERVER_USER}@${SERVER_IP}:${REMOTE_DIR}/
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Ошибка при копировании файлов${NC}"
    exit 1
fi

# Шаг 4: Настройка Nginx (если еще не настроен)
echo -e "${YELLOW}🔧 Проверка конфигурации Nginx...${NC}"
ssh ${SERVER_USER}@${SERVER_IP} << 'ENDSSH'
# Проверяем, установлен ли Nginx
if ! command -v nginx &> /dev/null; then
    echo "Nginx не установлен. Устанавливаем..."
    apt-get update
    apt-get install -y nginx
fi

# Создаем конфигурацию Nginx, если её нет
NGINX_CONFIG="/etc/nginx/sites-available/altec"
if [ ! -f "$NGINX_CONFIG" ]; then
    echo "Создаем конфигурацию Nginx..."
    cat > $NGINX_CONFIG << 'EOF'
server {
    listen 80;
    server_name 194.32.142.152;
    
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
    
    # Создаем символическую ссылку
    ln -sf $NGINX_CONFIG /etc/nginx/sites-enabled/altec
    
    # Удаляем дефолтную конфигурацию, если она есть
    rm -f /etc/nginx/sites-enabled/default
    
    # Проверяем конфигурацию
    nginx -t
    
    # Перезапускаем Nginx
    systemctl restart nginx
    systemctl enable nginx
    
    echo "✅ Nginx настроен и запущен"
else
    echo "✅ Конфигурация Nginx уже существует"
    # Перезагружаем Nginx для применения изменений
    nginx -t && systemctl reload nginx
fi

# Устанавливаем правильные права доступа
chown -R www-data:www-data /var/www/altec
chmod -R 755 /var/www/altec

echo "✅ Права доступа установлены"
ENDSSH

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Ошибка при настройке сервера${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Деплой успешно завершен!${NC}"
echo -e "${GREEN}🌐 Сайт доступен по адресу: http://${SERVER_IP}${NC}"
echo ""
echo -e "${YELLOW}Полезные команды:${NC}"
echo -e "  Проверить статус Nginx: ssh ${SERVER_USER}@${SERVER_IP} 'systemctl status nginx'"
echo -e "  Посмотреть логи Nginx: ssh ${SERVER_USER}@${SERVER_IP} 'tail -f /var/log/nginx/error.log'"
echo -e "  Перезапустить Nginx: ssh ${SERVER_USER}@${SERVER_IP} 'systemctl restart nginx'"

