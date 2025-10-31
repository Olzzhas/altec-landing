# 🔄 Как обновить сайт на сервере

## Вариант 1: Автоматическое обновление (рекомендуется)

### На сервере просто запустите:

```bash
cd ~/altec-landing
bash deploy-local.sh
```

Скрипт автоматически:
1. ✅ Установит зависимости
2. ✅ Соберет проект
3. ✅ Скопирует файлы в `/var/www/altec`
4. ✅ Перезагрузит Nginx

**Готово! Сайт обновлен.**

---

## Вариант 2: Обновление с локальной машины

### Если вы внесли изменения локально:

```bash
# 1. Скопируйте изменения на сервер
rsync -avz --exclude 'node_modules' --exclude '.git' --exclude '.next' --exclude 'out' \
  ./ ubuntu@194.32.142.152:~/altec-landing/

# 2. Запустите деплой на сервере
ssh ubuntu@194.32.142.152 'cd ~/altec-landing && bash deploy-local.sh'
```

### Или одной командой:

```bash
rsync -avz --exclude 'node_modules' --exclude '.git' --exclude '.next' --exclude 'out' \
  ./ ubuntu@194.32.142.152:~/altec-landing/ && \
ssh ubuntu@194.32.142.152 'cd ~/altec-landing && bash deploy-local.sh'
```

---

## Вариант 3: Через Git (если используете)

### На сервере:

```bash
cd ~/altec-landing

# Получить последние изменения
git pull

# Запустить деплой
bash deploy-local.sh
```

---

## Вариант 4: Только обновление файлов (без пересборки)

Если вы изменили только статические файлы (картинки, тексты в HTML):

```bash
# На сервере
cd ~/altec-landing
sudo cp -r out/* /var/www/altec/
sudo systemctl reload nginx
```

---

## Быстрая шпаргалка

### Полное обновление (на сервере):
```bash
cd ~/altec-landing && bash deploy-local.sh
```

### С локальной машины:
```bash
rsync -avz --exclude 'node_modules' --exclude '.git' --exclude '.next' --exclude 'out' \
  ./ ubuntu@194.32.142.152:~/altec-landing/ && \
ssh ubuntu@194.32.142.152 'cd ~/altec-landing && bash deploy-local.sh'
```

### Через Git (на сервере):
```bash
cd ~/altec-landing && git pull && bash deploy-local.sh
```

---

## Проверка обновления

После обновления проверьте сайт:

```bash
# Проверить статус Nginx
sudo systemctl status nginx

# Посмотреть логи
sudo tail -f /var/log/nginx/error.log

# Открыть сайт
curl -I http://194.32.142.152
# или
curl -I https://td-altec.kz
```

---

## Troubleshooting

### Изменения не видны в браузере

Очистите кэш браузера:
- **Chrome/Edge**: Ctrl+Shift+R (Windows) или Cmd+Shift+R (Mac)
- **Firefox**: Ctrl+F5 (Windows) или Cmd+Shift+R (Mac)
- **Safari**: Cmd+Option+R

### Ошибка при сборке

```bash
# Удалите node_modules и пересоберите
cd ~/altec-landing
rm -rf node_modules .next out
npm install
npm run build
```

### Nginx не перезагружается

```bash
# Проверьте конфигурацию
sudo nginx -t

# Перезапустите Nginx
sudo systemctl restart nginx
```

---

## Создание скрипта для быстрого обновления

Создайте файл `update.sh` на локальной машине:

```bash
#!/bin/bash

echo "🔄 Обновление сайта на сервере..."

# Копирование файлов
rsync -avz --exclude 'node_modules' --exclude '.git' --exclude '.next' --exclude 'out' \
  ./ ubuntu@194.32.142.152:~/altec-landing/

# Деплой на сервере
ssh ubuntu@194.32.142.152 'cd ~/altec-landing && bash deploy-local.sh'

echo "✅ Готово!"
```

Сделайте исполняемым:
```bash
chmod +x update.sh
```

Используйте:
```bash
./update.sh
```

---

**Самый простой способ: просто запустите `bash deploy-local.sh` на сервере!**

