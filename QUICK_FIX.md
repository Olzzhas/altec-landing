# ⚡ Быстрое решение: npm не найден

## Проблема
```
E: Unable to locate package npm
```

## Решение (выполните на сервере)

### Вариант 1: Одна команда (рекомендуется)

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash - && sudo apt-get install -y nodejs
```

Проверьте:
```bash
node --version
npm --version
```

### Вариант 2: Пошагово

```bash
# 1. Установить curl
sudo apt-get update
sudo apt-get install -y curl

# 2. Добавить репозиторий Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -

# 3. Установить Node.js и npm
sudo apt-get install -y nodejs

# 4. Проверить
node --version
npm --version
```

## После установки Node.js

```bash
# Перейти в проект
cd ~/altec-landing

# Установить зависимости
npm install

# Собрать проект
npm run build

# Проверить результат
ls -la out/
```

## Готово!

Теперь можно использовать скрипты деплоя с локальной машины:

```bash
./deploy.sh
```

---

**Подробная инструкция:** [SERVER_INSTALL.md](./SERVER_INSTALL.md)

