# Bybit Multi-Dashboard Setup

Tato konfigurace umožňuje spustit 3 samostatné Bybit dashboardy v Dockeru s přístupem přes HTTPS subdomény.

## Struktura projektu

```
futuresboard/
├── config/
│   ├── config1.json          # Dashboard 1 - Bybit API #1
│   ├── config2.json          # Dashboard 2 - Bybit API #2
│   ├── config3.json          # Dashboard 3 - Bybit API #3
│   └── config.json.example
├── nginx/
│   ├── nginx.conf            # Nginx reverse proxy konfigurace
│   └── ssl/
│       ├── fullchain.pem     # SSL certifikát (vytvořte pomocí certbot)
│       ├── privkey.pem       # SSL privátní klíč
│       └── README.md
├── data1/                    # Databáze pro Dashboard 1
├── data2/                    # Databáze pro Dashboard 2
├── data3/                    # Databáze pro Dashboard 3
├── docker-compose.yaml
└── Dockerfile
```

## Konfigurace

### 1. Získejte Bybit Demo API klíče

1. Přihlaste se na [Bybit](https://www.bybit.com)
2. Přejděte na Demo trading
3. V Demo účtu vytvořte API klíče (Settings > API Management)
4. Vytvořte 3 sady API klíčů pro každý dashboard

### 2. Nastavte API klíče

Upravte soubory `config/config1.json`, `config/config2.json`, `config/config3.json`:

```json
{
    "EXCHANGE": "bybit",
    "TEST_MODE": false,
    "DEMO_MODE": true,
    "API_KEY": "VÁŠ_BYBIT_DEMO_API_KEY",
    "API_SECRET": "VÁŠ_BYBIT_DEMO_API_SECRET",
    ...
}
```

**Důležité:** 
- `"EXCHANGE": "bybit"` - používá Bybit API
- `"TEST_MODE": false` - vypne testnet
- `"DEMO_MODE": true` - aktivuje demo režim (https://api-demo.bybit.com)

### 3. SSL Certifikáty

#### Produkční SSL (Let's Encrypt)

```bash
# Na serveru nainstalujte certbot
sudo apt update
sudo apt install certbot

# Vygenerujte certifikát pro všechny subdomény
sudo certbot certonly --standalone \
  -d ppanchov-takserver.eu \
  -d dashboard1.ppanchov-takserver.eu \
  -d dashboard2.ppanchov-takserver.eu \
  -d dashboard3.ppanchov-takserver.eu

# Zkopírujte certifikáty do projektu
cd /home/martin/dashboard/futuresboard
sudo cp /etc/letsencrypt/live/ppanchov-takserver.eu/fullchain.pem nginx/ssl/
sudo cp /etc/letsencrypt/live/ppanchov-takserver.eu/privkey.pem nginx/ssl/
sudo chmod 644 nginx/ssl/*.pem
```

#### Testovací SSL (self-signed)

```bash
cd /home/martin/dashboard/futuresboard/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout privkey.pem \
  -out fullchain.pem \
  -subj "/C=CZ/ST=Prague/L=Prague/O=Dev/CN=*.ppanchov-takserver.eu"
```

### 4. DNS Konfigurace

Nastavte A záznamy ve vaší DNS:

```
ppanchov-takserver.eu           A    IP_VAŠEHO_SERVERU
dashboard1.ppanchov-takserver.eu A    IP_VAŠEHO_SERVERU
dashboard2.ppanchov-takserver.eu A    IP_VAŠEHO_SERVERU
dashboard3.ppanchov-takserver.eu A    IP_VAŠEHO_SERVERU
```

## Spuštění

### Prvotní build a spuštění

```bash
cd /home/martin/dashboard/futuresboard

# Build Docker obrazu
docker compose build

# Spuštění všech služeb
docker compose up -d
```

### Kontrola stavu

```bash
# Zobrazit běžící kontejnery
docker compose ps

# Zobrazit logy
docker compose logs -f

# Logy konkrétního dashboardu
docker compose logs -f futuresboard1
docker compose logs -f futuresboard2
docker compose logs -f futuresboard3
docker compose logs -f nginx
```

### Správa služeb

```bash
# Zastavit služby
docker compose down

# Restart služby
docker compose restart futuresboard1

# Rebuild po změnách
docker compose build --no-cache
docker compose up -d
```

## Přístup k dashboardům

Po spuštění budou dashboardy dostupné na:

- **Dashboard 1:** https://dashboard1.ppanchov-takserver.eu
- **Dashboard 2:** https://dashboard2.ppanchov-takserver.eu
- **Dashboard 3:** https://dashboard3.ppanchov-takserver.eu
- **Hlavní doména:** https://ppanchov-takserver.eu → přesměruje na Dashboard 1

## Porty

- **5001** - Dashboard 1 (interní)
- **5002** - Dashboard 2 (interní)
- **5003** - Dashboard 3 (interní)
- **80** - HTTP (přesměruje na HTTPS)
- **443** - HTTPS (veřejný přístup)

## Customizace

### Změna barev dashboardů

V `config/configX.json` upravte:

```json
{
    "CUSTOM": {
        "NAVBAR_TITLE": "Vlastní název",
        "NAVBAR_BG": "bg-primary",  // bg-primary, bg-success, bg-info, bg-danger, bg-warning
        "PROJECTIONS": [1.003, 1.005, 1.01, 1.012]
    }
}
```

### Změna intervalu scrapování

```json
{
    "AUTO_SCRAPE_INTERVAL": 300  // v sekundách (60-3600)
}
```

## Firewall konfigurace

Otevřete porty na serveru:

```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

## Troubleshooting

### Dashboard se nezobrazuje

```bash
# Zkontrolujte logy
docker compose logs futuresboard1

# Zkontrolujte, zda běží
docker compose ps

# Restart
docker compose restart futuresboard1
```

### SSL chyby

```bash
# Zkontrolujte certifikáty
ls -la nginx/ssl/

# Zkontrolujte nginx konfiguraci
docker compose exec nginx nginx -t

# Restart nginx
docker compose restart nginx
```

### API chyby

- Zkontrolujte, zda máte správné API klíče v `config/configX.json`
- Ověřte, že používáte **Demo API** klíče (ne produkční)
- Zkontrolujte, že API klíče mají potřebná oprávnění (Read-only stačí)

### Databáze chyby

```bash
# Smažte databáze a nechte je znovu vytvořit
rm -rf data1/* data2/* data3/*
docker compose restart
```

## Údržba

### Auto-restart po restartu serveru

Docker-compose je nakonfigurován s `restart: unless-stopped`, takže služby se automaticky spustí po restartu serveru.

### Obnovení SSL certifikátů

Let's Encrypt certifikáty vyprší po 90 dnech:

```bash
# Obnovení
sudo certbot renew

# Zkopírování nových certifikátů
sudo cp /etc/letsencrypt/live/ppanchov-takserver.eu/fullchain.pem nginx/ssl/
sudo cp /etc/letsencrypt/live/ppanchov-takserver.eu/privkey.pem nginx/ssl/

# Restart nginx
docker compose restart nginx
```

### Automatická obnova SSL

Nastavte cron job:

```bash
sudo crontab -e
```

Přidejte:

```
0 0 * * 0 certbot renew && cp /etc/letsencrypt/live/ppanchov-takserver.eu/*.pem /home/martin/dashboard/futuresboard/nginx/ssl/ && cd /home/martin/dashboard/futuresboard && docker compose restart nginx
```

## Bezpečnost

1. **Nikdy nesdílejte API klíče** - Jsou uloženy pouze v `config/configX.json`
2. **Používejte pouze demo API klíče** - Pro testování a development
3. **Nastavte read-only oprávnění** - API klíče by měly mít pouze práva ke čtení
4. **Pravidelně obnovujte SSL** - Používejte Let's Encrypt pro automatickou obnovu
5. **Firewall** - Otevřete pouze porty 80 a 443

## Podpora

Pro více informací o projektu navštivte:
- [Futuresboard GitHub](https://github.com/ecoppen/futuresboard)
- [Bybit API Documentation](https://bybit-exchange.github.io/docs/v5/intro)
