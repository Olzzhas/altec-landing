# 🔧 Восстановление домена td-altec.kz

## Проблема
После запуска `deploy-local.sh` сайт недоступен по домену.

## ⚡ Быстрое решение

### На сервере выполните:

```bash
cd ~/altec-landing
bash fix-domain.sh
```

Скрипт автоматически:
1. ✅ Восстановит конфигурацию с доменом td-altec.kz
2. ✅ Перезагрузит Nginx
3. ✅ Проверит доступность

---

## Или вручную:

### 1. Проверьте текущую конфигурацию:
```bash
sudo cat /etc/nginx/sites-available/altec | grep server_name
```

### 2. Если там `server_name _;` вместо домена, исправьте:
```bash
sudo nano /etc/nginx/sites-available/altec
```

Измените строку на:
```nginx
server_name td-altec.kz www.td-altec.kz;
```

Сохраните (Ctrl+O, Enter, Ctrl+X)

### 3. Проверьте и перезагрузите:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

### 4. Проверьте доступность:
```bash
curl -I http://td-altec.kz
```

---

## Почему это произошло?

Скрипт `deploy-local.sh` проверяет наличие домена в конфигурации, но иногда может не распознать его правильно.

---

## Как избежать в будущем?

После запуска `deploy-local.sh` всегда проверяйте:

```bash
# Проверить конфигурацию
sudo cat /etc/nginx/sites-available/altec | grep server_name

# Если нужно - восстановить домен
bash fix-domain.sh
```

---

## Если SSL был настроен

Если у вас был настроен SSL (HTTPS), после восстановления домена запустите:

```bash
bash setup-ssl.sh
```

Это восстановит HTTPS.

---

**Просто запустите `bash fix-domain.sh` на сервере! 🚀**

