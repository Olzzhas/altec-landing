# 🌐 Быстрая настройка домена

## Шаг 1: Настройте DNS (у регистратора домена)

Добавьте две A-записи:

```
Тип: A
Имя: @
Значение: 194.32.142.152

Тип: A  
Имя: www
Значение: 194.32.142.152
```

**Подождите 5-30 минут** пока DNS обновится.

---

## Шаг 2: Настройте домен на сервере

### Вариант 1: Автоматический скрипт (рекомендуется)

```bash
# Скопируйте скрипты на сервер
scp setup-domain.sh setup-ssl.sh ubuntu@194.32.142.152:~/altec-landing/

# Подключитесь к серверу
ssh ubuntu@194.32.142.152

# Настройте домен
cd ~/altec-landing
bash setup-domain.sh

# Установите SSL
bash setup-ssl.sh
```

### Вариант 2: Вручную

```bash
# На сервере
sudo nano /etc/nginx/sites-available/altec
```

Измените `server_name`:
```nginx
server_name ваш-домен.com www.ваш-домен.com;
```

Сохраните и перезагрузите:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

Установите SSL:
```bash
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d ваш-домен.com -d www.ваш-домен.com
```

---

## Готово!

Ваш сайт доступен по адресу:
- **https://ваш-домен.com**
- **https://www.ваш-домен.com**

---

## Проверка

```bash
# Проверить DNS
dig ваш-домен.com

# Проверить сайт
curl -I https://ваш-домен.com
```

---

## Troubleshooting

### DNS не обновился
Подождите 5-30 минут и проверьте:
```bash
nslookup ваш-домен.com
```

### SSL не устанавливается
Убедитесь что:
1. DNS уже обновился
2. Сайт доступен по HTTP
3. Порты открыты:
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

---

**Подробная инструкция:** [DOMAIN_SETUP.md](./DOMAIN_SETUP.md)

