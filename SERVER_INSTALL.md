# 🔧 Установка Node.js на сервере

## Проблема
```
E: Unable to locate package npm
```

## Решение

### Вариант 1: Автоматическая установка (рекомендуется)

На сервере выполните:

```bash
# Скачайте скрипт
curl -o install-nodejs.sh https://raw.githubusercontent.com/YOUR_REPO/install-nodejs.sh

# Или скопируйте с локальной машины
# На локальной машине:
scp install-nodejs.sh ubuntu@194.32.142.152:~/

# На сервере:
cd ~
sudo bash install-nodejs.sh
```

### Вариант 2: Ручная установка

На сервере выполните команды:

```bash
# 1. Обновить систему
sudo apt-get update

# 2. Установить curl
sudo apt-get install -y curl

# 3. Добавить репозиторий Node.js 20.x (LTS)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -

# 4. Установить Node.js и npm
sudo apt-get install -y nodejs

# 5. Проверить установку
node --version
npm --version
```

## После установки Node.js

### Если проект уже на сервере (~/altec-landing):

```bash
cd ~/altec-landing

# Установить зависимости
npm install

# Собрать проект
npm run build

# Файлы будут в папке ./out
ls -la out/
```

### Если нужно скопировать проект на сервер:

На локальной машине:

```bash
# Вариант 1: Использовать наш скрипт деплоя
./deploy.sh

# Вариант 2: Скопировать вручную
rsync -avz --exclude 'node_modules' ./ ubuntu@194.32.142.152:~/altec-landing/
```

## Полный процесс с нуля

### На сервере:

```bash
# 1. Установить Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
sudo apt-get install -y nodejs

# 2. Проверить
node --version
npm --version

# 3. Перейти в проект
cd ~/altec-landing

# 4. Установить зависимости
npm install

# 5. Собрать проект
npm run build

# 6. Установить Nginx (если еще не установлен)
sudo apt-get install -y nginx

# 7. Скопировать файлы в директорию Nginx
sudo mkdir -p /var/www/altec
sudo cp -r out/* /var/www/altec/

# 8. Настроить Nginx
sudo nano /etc/nginx/sites-available/altec
```

Добавьте в файл:

```nginx
server {
    listen 80;
    server_name 194.32.142.152;
    
    root /var/www/altec;
    index index.html;
    
    location / {
        try_files $uri $uri.html $uri/ =404;
    }
    
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|webp)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

Затем:

```bash
# 9. Активировать конфигурацию
sudo ln -sf /etc/nginx/sites-available/altec /etc/nginx/sites-enabled/altec
sudo rm -f /etc/nginx/sites-enabled/default

# 10. Проверить конфигурацию
sudo nginx -t

# 11. Перезапустить Nginx
sudo systemctl restart nginx

# 12. Проверить статус
sudo systemctl status nginx
```

## Или используйте наш автоматический скрипт

### На локальной машине:

```bash
# 1. Скопируйте скрипт настройки на сервер
scp server-setup.sh ubuntu@194.32.142.152:~/

# 2. Запустите на сервере
ssh ubuntu@194.32.142.152 'sudo bash ~/server-setup.sh'

# 3. Теперь можно деплоить
./deploy.sh
```

## Проверка

После всех шагов откройте в браузере:

**http://194.32.142.152**

## Troubleshooting

### Node.js не устанавливается
```bash
# Попробуйте другую версию
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash -
sudo apt-get install -y nodejs
```

### npm install выдает ошибки
```bash
# Очистите кэш
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

### Нет прав на запись
```bash
# Измените владельца директории
sudo chown -R ubuntu:ubuntu ~/altec-landing
```

### Nginx не запускается
```bash
# Проверьте логи
sudo journalctl -u nginx -n 50
sudo tail -f /var/log/nginx/error.log
```

## Быстрая команда (все в одном)

На сервере выполните:

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash - && \
sudo apt-get install -y nodejs nginx && \
cd ~/altec-landing && \
npm install && \
npm run build && \
sudo mkdir -p /var/www/altec && \
sudo cp -r out/* /var/www/altec/ && \
sudo chown -R www-data:www-data /var/www/altec && \
echo "✅ Готово! Настройте Nginx конфигурацию"
```

