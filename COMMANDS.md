# 📋 Все команды для деплоя

## 🚀 Деплой

### Первый раз (с настройкой сервера)
```bash
./deploy.sh
# или
npm run deploy
```

### Быстрое обновление (когда сервер уже настроен)
```bash
./quick-deploy.sh
# или
npm run deploy:quick
```

## 🔍 Проверка сервера

### Проверить статус всего
```bash
./check-server.sh
# или
npm run server:check
```

### Проверить только Nginx
```bash
ssh root@194.32.142.152 'systemctl status nginx'
```

### Посмотреть логи ошибок
```bash
ssh root@194.32.142.152 'tail -f /var/log/nginx/error.log'
```

### Посмотреть логи доступа
```bash
ssh root@194.32.142.152 'tail -f /var/log/nginx/access.log'
```

## 🔧 Управление Nginx

### Перезапустить Nginx
```bash
ssh root@194.32.142.152 'systemctl restart nginx'
```

### Перезагрузить конфигурацию (без остановки)
```bash
ssh root@194.32.142.152 'systemctl reload nginx'
```

### Проверить конфигурацию
```bash
ssh root@194.32.142.152 'nginx -t'
```

### Остановить Nginx
```bash
ssh root@194.32.142.152 'systemctl stop nginx'
```

### Запустить Nginx
```bash
ssh root@194.32.142.152 'systemctl start nginx'
```

## 📁 Работа с файлами на сервере

### Посмотреть файлы
```bash
ssh root@194.32.142.152 'ls -la /var/www/altec'
```

### Посмотреть размер директории
```bash
ssh root@194.32.142.152 'du -sh /var/www/altec'
```

### Удалить все файлы (осторожно!)
```bash
ssh root@194.32.142.152 'rm -rf /var/www/altec/*'
```

### Скопировать файлы вручную
```bash
rsync -avz --delete ./out/ root@194.32.142.152:/var/www/altec/
```

## 🔐 SSH

### Настроить SSH ключ (один раз)
```bash
ssh-copy-id root@194.32.142.152
```

### Подключиться к серверу
```bash
ssh root@194.32.142.152
```

### Выполнить команду на сервере
```bash
ssh root@194.32.142.152 'команда'
```

## 🛠️ Локальная разработка

### Запустить dev сервер
```bash
npm run dev
```

### Собрать проект
```bash
npm run build
```

### Запустить production сервер локально
```bash
npm run start
```

## 🌐 Проверка сайта

### Открыть сайт
```bash
open http://194.32.142.152
```

### Проверить доступность
```bash
curl -I http://194.32.142.152
```

### Проверить время ответа
```bash
curl -o /dev/null -s -w 'Total: %{time_total}s\n' http://194.32.142.152
```

## 📊 Мониторинг

### Посмотреть использование диска
```bash
ssh root@194.32.142.152 'df -h'
```

### Посмотреть использование памяти
```bash
ssh root@194.32.142.152 'free -h'
```

### Посмотреть процессы
```bash
ssh root@194.32.142.152 'top -bn1 | head -20'
```

### Посмотреть активные соединения
```bash
ssh root@194.32.142.152 'netstat -tuln | grep :80'
```

## 🔄 Откат изменений

### Если что-то пошло не так, можно откатить Nginx к дефолтной конфигурации
```bash
ssh root@194.32.142.152 << 'EOF'
rm /etc/nginx/sites-enabled/altec
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
systemctl restart nginx
EOF
```

## 📝 Редактирование конфигурации Nginx

### Открыть конфигурацию для редактирования
```bash
ssh root@194.32.142.152 'nano /etc/nginx/sites-available/altec'
```

### После редактирования проверить и перезагрузить
```bash
ssh root@194.32.142.152 'nginx -t && systemctl reload nginx'
```

## 🎯 Полезные алиасы (добавьте в ~/.bashrc или ~/.zshrc)

```bash
# Добавьте эти строки в ваш ~/.bashrc или ~/.zshrc
alias deploy='npm run deploy:quick'
alias deploy-full='npm run deploy'
alias server-check='npm run server:check'
alias server-ssh='ssh root@194.32.142.152'
alias server-logs='ssh root@194.32.142.152 "tail -f /var/log/nginx/error.log"'
```

После добавления выполните:
```bash
source ~/.bashrc  # или source ~/.zshrc
```

Теперь можно использовать короткие команды:
```bash
deploy              # Быстрый деплой
deploy-full         # Полный деплой
server-check        # Проверка сервера
server-ssh          # Подключение к серверу
server-logs         # Просмотр логов
```

