# ⚡ Быстрая шпаргалка

## 🚀 Первый деплой

### На сервере:
```bash
cd ~/altec-landing
bash deploy-local.sh
```

---

## 🔄 Обновление после изменений

### Вариант 1: На сервере (самый простой)
```bash
cd ~/altec-landing
bash deploy-local.sh
```

### Вариант 2: С локальной машины
```bash
./update.sh
```

---

## 🌐 Настройка домена

### 1. У регистратора добавьте A-записи:
```
Тип: A, Имя: @, Значение: 194.32.142.152
Тип: A, Имя: www, Значение: 194.32.142.152
```

### 2. На сервере:
```bash
cd ~/altec-landing
bash setup-domain.sh
bash setup-ssl.sh
```

---

## 📋 Полезные команды

### Проверка сайта:
```bash
curl -I https://td-altec.kz
```

### Логи Nginx:
```bash
sudo tail -f /var/log/nginx/error.log
```

### Перезапуск Nginx:
```bash
sudo systemctl restart nginx
```

### Статус Nginx:
```bash
sudo systemctl status nginx
```

---

## 📖 Подробные инструкции

- **[UPDATE.md](./UPDATE.md)** - Обновление сайта
- **[DOMAIN_QUICK.md](./DOMAIN_QUICK.md)** - Настройка домена
- **[DEPLOY_ON_SERVER.md](./DEPLOY_ON_SERVER.md)** - Деплой на сервере

---

**Самое главное: `bash deploy-local.sh` на сервере делает всё! 🚀**

