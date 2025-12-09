# SSL certifikáty
Tato složka obsahuje SSL certifikáty pro HTTPS přístup.

## Generování SSL certifikátů pomocí Let's Encrypt (Certbot)

Na vašem serveru s doménou ppanchov-takserver.eu spusťte:

```bash
# Nainstalujte certbot
sudo apt update
sudo apt install certbot

# Vygenerujte certifikát (nginx musí být vypnutý)
sudo certbot certonly --standalone -d ppanchov-takserver.eu -d dashboard1.ppanchov-takserver.eu -d dashboard2.ppanchov-takserver.eu -d dashboard3.ppanchov-takserver.eu

# Zkopírujte certifikáty do této složky
sudo cp /etc/letsencrypt/live/ppanchov-takserver.eu/fullchain.pem ./
sudo cp /etc/letsencrypt/live/ppanchov-takserver.eu/privkey.pem ./
sudo chmod 644 fullchain.pem privkey.pem
```

## Pro testování (self-signed certifikát)

```bash
# Vygenerujte self-signed certifikát
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout privkey.pem \
  -out fullchain.pem \
  -subj "/C=CZ/ST=Prague/L=Prague/O=Dev/CN=ppanchov-takserver.eu"
```

## Požadované soubory

- `fullchain.pem` - Celý řetězec certifikátů
- `privkey.pem` - Soukromý klíč
