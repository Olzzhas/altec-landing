# 🌐 Привязка домена к серверу

## Шаг 1: Настройка DNS записей

У вашего регистратора домена (например, Cloudflare, Namecheap, GoDaddy) добавьте A-запись:

```
Тип: A
Имя: @ (или оставьте пустым для корневого домена)
Значение: 194.32.142.152
TTL: Auto или 3600
```

Если нужен поддомен (например, www):
```
Тип: A
Имя: www
Значение: 194.32.142.152
TTL: Auto или 3600
```

### Примеры для популярных регистраторов:

#### Cloudflare
1. Войдите в Cloudflare
2. Выберите ваш домен
3. DNS → Add record
4. Type: A
5. Name: @ (для example.com) или www (для www.example.com)
6. IPv4 address: 194.32.142.152
7. Proxy status: DNS only (серый облачок)
8. Save

#### Namecheap
1. Domain List → Manage
2. Advanced DNS
3. Add New Record
4. Type: A Record
5. Host: @ или www
6. Value: 194.32.142.152
7. TTL: Automatic
8. Save

#### GoDaddy
1. My Products → DNS
2. Add → A
3. Name: @ или www
4. Value: 194.32.142.152
5. TTL: 1 Hour
6. Save

---

## Шаг 2: Обновление конфигурации Nginx на сервере

### Вариант 1: Автоматический скрипт

Создайте файл `setup-domain.sh` на сервере:

```bash
#!/bin/bash

# Замените на ваш домен
DOMAIN="td-altec.kz"

echo "🌐 Настройка домена: $DOMAIN"

# Обновление конфигурации Nginx
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
sudo nginx -t

# Перезагрузка Nginx
sudo systemctl reload nginx

echo "✅ Домен настроен!"
echo "🌐 Сайт доступен по адресу: http://$DOMAIN"
```

Запустите:
```bash
# Замените example.com на ваш домен
sed -i 's/example.com/ваш-домен.com/g' setup-domain.sh
bash setup-domain.sh
```

### Вариант 2: Вручную

На сервере выполните:

```bash
# Откройте конфигурацию Nginx
sudo nano /etc/nginx/sites-available/altec
```

Измените строку `server_name`:
```nginx
server {
    listen 80;
    listen [::]:80;
    
    # Замените на ваш домен
    server_name example.com www.example.com;
    
    root /var/www/altec;
    index index.html;
    
    location / {
        try_files $uri $uri.html $uri/ =404;
    }
    
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript application/json;
}
```

Сохраните (Ctrl+O, Enter, Ctrl+X) и перезагрузите Nginx:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## Шаг 3: Установка SSL сертификата (HTTPS)

### Автоматическая установка с Let's Encrypt (рекомендуется)

```bash
# Установка Certbot
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx

# Получение сертификата (замените на ваш домен)
sudo certbot --nginx -d example.com -d www.example.com

# Следуйте инструкциям:
# 1. Введите email
# 2. Согласитесь с условиями (Y)
# 3. Выберите редирект на HTTPS (2)
```

Certbot автоматически:
- Получит SSL сертификат
- Обновит конфигурацию Nginx
- Настроит автоматическое продление

### Проверка автопродления

```bash
sudo certbot renew --dry-run
```

---

## Шаг 4: Проверка

### Проверить DNS
```bash
# На локальной машине
dig example.com
nslookup example.com
```

Должно показать IP: 194.32.142.152

### Проверить сайт
Откройте в браузере:
- http://example.com
- http://www.example.com
- https://example.com (после установки SSL)
- https://www.example.com (после установки SSL)

---

## Полный скрипт для настройки домена + SSL

Создайте `domain-ssl-setup.sh`:

```bash
#!/bin/bash

# НАСТРОЙКИ - ИЗМЕНИТЕ НА СВОИ
DOMAIN="example.com"
EMAIL="your-email@example.com"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🌐 Настройка домена: $DOMAIN${NC}"
echo ""

# 1. Обновление конфигурации Nginx
echo -e "${YELLOW}⚙️  Обновление Nginx конфигурации...${NC}"
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
    
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript application/json;
}
EOF

sudo nginx -t && sudo systemctl reload nginx
echo -e "${GREEN}✅ Nginx обновлен${NC}"
echo ""

# 2. Установка Certbot
echo -e "${YELLOW}📦 Установка Certbot...${NC}"
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx
echo ""

# 3. Получение SSL сертификата
echo -e "${YELLOW}🔒 Получение SSL сертификата...${NC}"
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email $EMAIL --redirect
echo ""

# 4. Проверка
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ ДОМЕН НАСТРОЕН!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}🌐 Ваш сайт доступен по адресам:${NC}"
echo -e "   https://$DOMAIN"
echo -e "   https://www.$DOMAIN"
echo ""
echo -e "${YELLOW}🔒 SSL сертификат установлен${NC}"
echo -e "${YELLOW}🔄 Автопродление настроено${NC}"
echo ""
```

Использование:
```bash
# 1. Измените DOMAIN и EMAIL в скрипте
nano domain-ssl-setup.sh

# 2. Запустите
bash domain-ssl-setup.sh
```

---

## Troubleshooting

### DNS не обновился
- Подождите 5-30 минут (время распространения DNS)
- Проверьте: `dig example.com` или `nslookup example.com`
- Очистите DNS кэш на компьютере:
  - Windows: `ipconfig /flushdns`
  - Mac: `sudo dscacheutil -flushcache`
  - Linux: `sudo systemd-resolve --flush-caches`

### Certbot выдает ошибку
- Убедитесь, что DNS уже обновился
- Проверьте, что порты 80 и 443 открыты:
  ```bash
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  ```
- Проверьте, что домен доступен по HTTP перед установкой SSL

### Сайт не открывается
```bash
# Проверьте статус Nginx
sudo systemctl status nginx

# Проверьте логи
sudo tail -f /var/log/nginx/error.log

# Проверьте конфигурацию
sudo nginx -t
```

---

## Быстрая шпаргалка

```bash
# 1. Добавьте A-запись у регистратора
# Тип: A, Имя: @, Значение: 194.32.142.152

# 2. На сервере обновите Nginx
sudo nano /etc/nginx/sites-available/altec
# Измените server_name на ваш домен

# 3. Перезагрузите Nginx
sudo nginx -t && sudo systemctl reload nginx

# 4. Установите SSL
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d example.com -d www.example.com

# 5. Готово!
# https://example.com
```

