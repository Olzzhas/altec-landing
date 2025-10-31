#!/bin/bash

# Скрипт для проверки статуса сервера

# Загрузка конфигурации
if [ -f .env.deploy ]; then
    export $(cat .env.deploy | grep -v '^#' | xargs)
fi

SERVER_IP="${DEPLOY_SERVER_IP:-194.32.142.152}"
SERVER_USER="${DEPLOY_SERVER_USER:-root}"
REMOTE_DIR="${DEPLOY_REMOTE_DIR:-/var/www/altec}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔍 Проверка статуса сервера ${SERVER_IP}${NC}"
echo ""

# Проверка доступности сервера
echo -e "${YELLOW}📡 Проверка доступности сервера...${NC}"
if ping -c 1 ${SERVER_IP} &> /dev/null; then
    echo -e "${GREEN}✅ Сервер доступен${NC}"
else
    echo -e "${RED}❌ Сервер недоступен${NC}"
    exit 1
fi

# Проверка SSH подключения
echo -e "${YELLOW}🔐 Проверка SSH подключения...${NC}"
if ssh -o ConnectTimeout=5 ${SERVER_USER}@${SERVER_IP} "echo 'OK'" &> /dev/null; then
    echo -e "${GREEN}✅ SSH подключение работает${NC}"
else
    echo -e "${RED}❌ SSH подключение не работает${NC}"
    exit 1
fi

# Проверка статуса Nginx
echo -e "${YELLOW}🌐 Статус Nginx...${NC}"
ssh ${SERVER_USER}@${SERVER_IP} << 'ENDSSH'
if systemctl is-active --quiet nginx; then
    echo "✅ Nginx запущен"
else
    echo "❌ Nginx не запущен"
fi
ENDSSH

# Проверка файлов на сервере
echo -e "${YELLOW}📁 Файлы на сервере...${NC}"
ssh ${SERVER_USER}@${SERVER_IP} << ENDSSH
if [ -d "${REMOTE_DIR}" ]; then
    echo "✅ Директория ${REMOTE_DIR} существует"
    echo "📊 Количество файлов: \$(find ${REMOTE_DIR} -type f | wc -l)"
    echo "💾 Размер: \$(du -sh ${REMOTE_DIR} | cut -f1)"
    echo ""
    echo "📄 Последние измененные файлы:"
    ls -lht ${REMOTE_DIR} | head -6
else
    echo "❌ Директория ${REMOTE_DIR} не существует"
fi
ENDSSH

# Проверка доступности сайта
echo ""
echo -e "${YELLOW}🌍 Проверка доступности сайта...${NC}"
if curl -s -o /dev/null -w "%{http_code}" http://${SERVER_IP} | grep -q "200"; then
    echo -e "${GREEN}✅ Сайт доступен: http://${SERVER_IP}${NC}"
else
    echo -e "${RED}❌ Сайт недоступен${NC}"
    echo -e "${YELLOW}Проверьте логи: ssh ${SERVER_USER}@${SERVER_IP} 'tail -20 /var/log/nginx/error.log'${NC}"
fi

echo ""
echo -e "${GREEN}✅ Проверка завершена${NC}"

