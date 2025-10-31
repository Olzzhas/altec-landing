#!/bin/bash

# Скрипт для установки SSL сертификата
# Запускается на сервере ПОСЛЕ настройки домена

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔒 Установка SSL сертификата${NC}"
echo ""

# Запрос домена
read -p "Введите ваш домен (например, example.com): " DOMAIN

if [ -z "$DOMAIN" ]; then
    echo -e "${RED}❌ Домен не указан${NC}"
    exit 1
fi

# Запрос email
read -p "Введите ваш email: " EMAIL

if [ -z "$EMAIL" ]; then
    echo -e "${RED}❌ Email не указан${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Домен: $DOMAIN${NC}"
echo -e "${YELLOW}Email: $EMAIL${NC}"
echo ""

read -p "Продолжить? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Отменено"
    exit 0
fi

echo ""

# Проверка, что домен доступен
echo -e "${YELLOW}🔍 Проверка доступности домена...${NC}"
if curl -s -o /dev/null -w "%{http_code}" "http://$DOMAIN" | grep -q "200\|301\|302"; then
    echo -e "${GREEN}✅ Домен доступен${NC}"
else
    echo -e "${RED}❌ Домен недоступен${NC}"
    echo -e "${YELLOW}Убедитесь, что:${NC}"
    echo -e "  1. DNS записи настроены"
    echo -e "  2. Прошло достаточно времени (5-30 минут)"
    echo -e "  3. Nginx запущен и работает"
    echo ""
    read -p "Продолжить всё равно? (y/n): " force
    if [ "$force" != "y" ] && [ "$force" != "Y" ]; then
        exit 1
    fi
fi

echo ""

# Установка Certbot
echo -e "${YELLOW}📦 Установка Certbot...${NC}"
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Ошибка при установке Certbot${NC}"
    exit 1
fi

echo ""

# Получение сертификата
echo -e "${YELLOW}🔒 Получение SSL сертификата...${NC}"
echo -e "${YELLOW}Это может занять минуту...${NC}"
echo ""

sudo certbot --nginx \
    -d "$DOMAIN" \
    -d "www.$DOMAIN" \
    --non-interactive \
    --agree-tos \
    --email "$EMAIL" \
    --redirect

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ SSL СЕРТИФИКАТ УСТАНОВЛЕН!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}🌐 Ваш сайт доступен по адресам:${NC}"
    echo -e "   ${GREEN}https://$DOMAIN${NC}"
    echo -e "   ${GREEN}https://www.$DOMAIN${NC}"
    echo ""
    echo -e "${YELLOW}🔒 Сертификат действителен 90 дней${NC}"
    echo -e "${YELLOW}🔄 Автоматическое продление настроено${NC}"
    echo ""
    echo -e "${YELLOW}Проверка автопродления:${NC}"
    echo -e "   sudo certbot renew --dry-run"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Ошибка при получении сертификата${NC}"
    echo ""
    echo -e "${YELLOW}Возможные причины:${NC}"
    echo -e "  1. DNS записи еще не обновились (подождите 5-30 минут)"
    echo -e "  2. Домен недоступен по HTTP"
    echo -e "  3. Порты 80 и 443 закрыты"
    echo ""
    echo -e "${YELLOW}Проверьте:${NC}"
    echo -e "  curl http://$DOMAIN"
    echo -e "  sudo ufw status"
    echo ""
    exit 1
fi

