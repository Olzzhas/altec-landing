# 🚀 Деплой прямо на сервере

## Как использовать

### 1. Скопируйте скрипт на сервер

```bash
scp deploy-local.sh ubuntu@194.32.142.152:~/altec-landing/
```

### 2. Запустите на сервере

```bash
ssh ubuntu@194.32.142.152
cd ~/altec-landing
bash deploy-local.sh
```

## Или одной командой

```bash
scp deploy-local.sh ubuntu@194.32.142.152:~/altec-landing/ && \
ssh ubuntu@194.32.142.152 'cd ~/altec-landing && bash deploy-local.sh'
```

## Что делает скрипт

1. ✅ Проверяет и устанавливает Node.js (если нужно)
2. ✅ Устанавливает зависимости (`npm install`)
3. ✅ Собирает проект (`npm run build`)
4. ✅ Устанавливает и настраивает Nginx
5. ✅ Копирует файлы в `/var/www/altec`
6. ✅ Перезапускает Nginx
7. ✅ Готово!

## Для обновления

Просто запустите скрипт снова:

```bash
ssh ubuntu@194.32.142.152 'cd ~/altec-landing && bash deploy-local.sh'
```

## Результат

Сайт будет доступен по адресу: **http://194.32.142.152**

---

**Это самый простой способ - просто запустите скрипт на сервере и всё!**

