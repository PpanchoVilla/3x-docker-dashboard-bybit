
<h1 align="center">3x Docker Dashboard Bybit</h1>
<p align="center">
🚀 Three Bybit Demo Dashboards Running in Docker with HTTPS Access<br>
Modified version for monitoring multiple Bybit Futures demo accounts simultaneously
</p>
<p align="center">
<img alt="Python 3.12" src="https://img.shields.io/badge/python-3.12-blue.svg">
<img alt="Docker" src="https://img.shields.io/badge/docker-enabled-2496ED.svg">
<img alt="Bybit" src="https://img.shields.io/badge/exchange-bybit-yellow.svg">
<a href="https://github.com/PpanchoVilla/3x-docker-dashboard-bybit/blob/main/LICENSE"><img alt="License: GPL v3" src="https://img.shields.io/badge/License-GPLv3-blue.svg">
</p>

---

## ⚡ Quick Start

```bash
# 1. Get 3× Bybit Demo API keys
#    see: BYBIT_API_SETUP.md

# 2. Edit config/config1.json, config2.json, config3.json
#    Add your API keys

# 3. Run
docker compose build
docker compose up -d
# or
./start.sh
```

**Hotovo!** Přístup na http://localhost:5001, 5002, 5003

---

## 📋 Co je nového v této verzi

### ✅ 3 samostatné Bybit Demo dashboardy
- Každý dashboard = vlastní Bybit demo účet
- Vlastní databáze pro každý dashboard
- Různé barvy pro snadné rozlišení

### ✅ Docker s Python 3.12
- Modernizovaný Dockerfile (Python 3.12-bookworm)
- Přidána podpora pro `pybit` knihovnu
- Multi-container setup s docker-compose

### ✅ HTTPS s Nginx reverse proxy
- Přístup přes subdomény (dashboard1/2/3.ppanchov-takserver.eu)
- SSL/TLS podpora (Let's Encrypt nebo self-signed)
- Automatický HTTP → HTTPS redirect

### ✅ Bybit Demo API režim
- `DEMO_MODE: true` - používá api-demo.bybit.com
- `TEST_MODE: false` - vypnutý testnet
- Virtuální peníze pro bezpečné testování

---

## 🏗️ Architektura

```
┌─────────────────────────────────────────────┐
│          Nginx Reverse Proxy (SSL)          │
│                Port 443 (HTTPS)             │
└──────┬──────────────┬──────────────┬────────┘
       │              │              │
   ┌───▼───┐      ┌───▼───┐      ┌───▼───┐
   │ DB 1  │      │ DB 2  │      │ DB 3  │
   │ 5001  │      │ 5002  │      │ 5003  │
   └───┬───┘      └───┬───┘      └───┬───┘
       │              │              │
   ┌───▼───────────────▼──────────────▼────┐
   │   Bybit Demo API (api-demo.bybit.com) │
   │         3 samostatné účty              │
   └────────────────────────────────────────┘
```

---

## 📖 Dokumentace

- **[QUICKSTART.md](QUICKSTART.md)** → Rychlý start v 3 krocích
- **[SETUP.md](SETUP.md)** → Kompletní setup guide
- **[BYBIT_API_SETUP.md](BYBIT_API_SETUP.md)** → Jak získat API klíče
- **[CHANGES.md](CHANGES.md)** → Souhrn všech změn

---

## 🎯 Funkce


Každý dashboard zobrazuje:
- 📈 **Positions** - Aktuální pozice a P&L
- 📊 **History** - Historie obchodů a příjmů
- 💰 **Account** - Stav účtu a wallet balance
- 📉 **Charts** - Grafy výkonnosti (1h, 24h, 7d)
- 📅 **Calendar** - Denní/měsíční přehledy
- 🎯 **Projections** - Projekce růstu účtu

---

## 🛠️ Make příkazy

```bash
make help          # Zobrazí všechny příkazy
make install       # Kompletní instalace
make start         # Spustí služby
make stop          # Zastaví služby
make restart       # Restartuje služby
make logs          # Zobrazí logy
make status        # Status služeb
make clean         # Vyčistí databáze
make check         # Kontrola konfigurace
make ssl           # Vygeneruje SSL (testovací)
make ssl-prod      # Let's Encrypt SSL
make backup        # Zálohuje databáze
```

---

## 🌐 Přístup k dashboardům

### Lokálně (bez SSL)
- Dashboard 1: http://localhost:5001
- Dashboard 2: http://localhost:5002
- Dashboard 3: http://localhost:5003

### Přes doménu (s SSL)
- Dashboard 1: https://dashboard1.ppanchov-takserver.eu
- Dashboard 2: https://dashboard2.ppanchov-takserver.eu
- Dashboard 3: https://dashboard3.ppanchov-takserver.eu

---

## 📁 Struktura projektu

```
futuresboard/
├── config/
│   ├── config1.json          # Dashboard 1 - Bybit API
│   ├── config2.json          # Dashboard 2 - Bybit API
│   ├── config3.json          # Dashboard 3 - Bybit API
│   └── config.json.example
├── nginx/
│   ├── nginx.conf            # Reverse proxy konfigurace
│   └── ssl/                  # SSL certifikáty
├── data1/, data2/, data3/    # Databáze pro každý dashboard
├── docker-compose.yaml       # Multi-container setup
├── Dockerfile               # Python 3.12 + dependencies
├── Makefile                 # Make příkazy
├── start.sh                 # Startovací skript
├── check-config.sh          # Validace konfigurace
└── QUICKSTART.md            # Rychlý start guide
```

---

## ⚙️ Konfigurace

### config/config1.json (příklad)

```json
{
    "EXCHANGE": "bybit",
    "TEST_MODE": false,
    "DEMO_MODE": true,
    "API_KEY": "VÁŠ_BYBIT_API_KEY",
    "API_SECRET": "VÁŠ_BYBIT_API_SECRET",
    "AUTO_SCRAPE_INTERVAL": 300,
    "PORT": 5001,
    "CUSTOM": {
        "NAVBAR_TITLE": "Bybit Dashboard 1",
        "NAVBAR_BG": "bg-primary",
        "PROJECTIONS": [1.003, 1.005, 1.01, 1.012]
    }
}
```

### Důležité parametry:
- **EXCHANGE**: `"bybit"` - burza
- **DEMO_MODE**: `true` - demo režim (api-demo.bybit.com)
- **TEST_MODE**: `false` - vypnuto (ne testnet)
- **AUTO_SCRAPE_INTERVAL**: 60-3600 sekund

---

## 🔒 Bezpečnost

### Co používáme:
✅ Bybit **Demo** API (api-demo.bybit.com)  
✅ Virtuální peníze (fake USDT)  
✅ Read-only API klíče (doporučeno)  
✅ SSL/TLS šifrování  
✅ Config soubory v .gitignore  

### Co NEDĚLÁME:
❌ Produkční API klíče  
❌ Skutečné peníze  
❌ Publikování API klíčů  

---

## 🚨 Troubleshooting

### Dashboard se nespustí
```bash
make logs-1  # Zkontrolujte logy
make check   # Validujte konfiguraci
```

### "Invalid API Key"
- Ověřte, že používáte **Demo** API klíče (z testnet.bybit.com)
- Zkontrolujte `"DEMO_MODE": true` v config.json
- API klíč musí mít **Contract** permissions

### SSL chyby
```bash
make ssl  # Vygeneruje testovací certifikát
```

---

## 📊 Screenshots

<img width="600" alt="dashboard" src="https://user-images.githubusercontent.com/51025241/147236951-c87d1b2e-9eee-49bb-bc44-1769b9756f45.png">
<img width="600" alt="positions" src="https://user-images.githubusercontent.com/51025241/147236958-160a4cd8-c461-46d2-87d1-560d89207a93.png">
<img width="600" alt="history" src="https://user-images.githubusercontent.com/51025241/147236956-7b427c72-0a8b-443b-bd24-3eaef3246895.png">

---

## 🔄 Aktualizace

```bash
# Po změnách v kódu
make update

# Rebuild bez cache
make rebuild && make start
```

---

## 💾 Záloha

```bash
# Záloha databází
make backup

# Najdete v: backups/backup-YYYYMMDD-HHMMSS.tar.gz
```

---

## 📝 Licence

GPL-3.0 (stejná jako původní futuresboard projekt)

---

## 🙏 Poděkování

Projekt založen na [futuresboard](https://github.com/ecoppen/futuresboard) od [@ecoppen](https://github.com/ecoppen)

---

## 🔗 Užitečné odkazy

- [Bybit Demo Trading](https://testnet.bybit.com)
- [Bybit API Docs](https://bybit-exchange.github.io/docs/v5/intro)
- [Původní Futuresboard](https://github.com/ecoppen/futuresboard)
- [Docker Documentation](https://docs.docker.com)
- [Let's Encrypt](https://letsencrypt.org)

---

## 💡 Tip

Chcete testovat různé trading strategie současně?  
→ Každý dashboard může používat jiný Bybit demo účet  
→ Porovnejte výsledky v reálném čase  
→ Vše bezpečně na virtuálních penězích

---

**Vytvořeno pro:** Monitoring více Bybit Futures demo účtů  
**Stack:** Python 3.12 + Flask + Docker + Nginx  
**Přístup:** HTTPS přes subdomény nebo localhost
- Clone this repository: `git clone https://github.com/ecoppen/futuresboard.git`
- Navigate to the futuresboard directory: `cd futuresboard`
- Install dependencies `python -m pip install .`. For developing, `python -m pip install -e .[dev]`
- Copy `config/config.json.example` to `config/config.json` and add your new api key and secret: `nano config.json`
- Collect your current trades by running `futuresboard --scrape-only`. If you want to monitor the weight usage (see below).
- By default, when launching the futuresboard web application, a separate thread is also started to continuously collect new trades.
  Alternatively, setup the scraper on a crontab or alternative to keep the database up-to-date: `crontab -e` then `*/5 * * * * futuresboard --scrape-only` (example is every 5 minutes, change to your needs)
  In this case, don't forget to pass `--disable-auto-scraper`.
- Start a screen or alternative if you want the webserver to persist: `screen -S futuresboard`
- Start the futuresboard web application `futuresboard`
- Navigate to the IP address shown e.g. `http://127.0.0.1:5000/`. These settings can be changed by passing `--host` and/or `--port` when running the above command

Currently only Binance and Bybit Futures are supported - as those are supported by passivbot.

## API weight usage - Binance

- Reminder: Binance API allows you to consume up to `1200 weight / minute / IP`.
- Account: Fetching account information costs `5` weight per run
- Income: Fetching income information costs `30` weight per 1000 (initial run will build database, afterwards only new income will be fetched)
- Orders: Fetching open order information costs `40` weight per run
- The scraper will sleep for a minute when the rate exceeds `800 within a minute`

## API weight usage - Bybit
- Account/Income/Positions: Fetching account information or positions costs `1` weight per run with a maximum combination allowed of `120/min`. Income can be fetched in batches of 50 (initial run will build database, afters only new income will be fetched)
- Orders: Fetching open order information costs `1` weight per symbol with a maximum allowed of `600/min`
- The scraper will sleep for a minute when the rate exceeds `100 within a minute`

## Customising the dashboard
The `/config/config.json` file allows you to customise the look and feel of your dashboard as follows:
- `AUTO_SCRAPE_INTERVAL` is set to 300 seconds, this value can be adjusted between `60` and `3600`
- `NAVBAR_TITLE` changes the branding in the top left of the navigation (see below)
- `NAVBAR_BG` changes the colour of the navigation bar, acceptable values are: `bg-primary`, `bg-secondary`, `bg-success`, `bg-danger`, `bg-warning`, `bg-info` and the default `bg-dark`
- `PROJECTIONS` changes the percentage values on the projections page. `1.003` equates to `0.3%` daily and `1.01` equates to `1%` daily.

For example, setting `"NAVBAR_TITLE": "Custom title"` and `"NAVBAR_BG": "bg-primary",` would result in:
<img width="1314" src="https://user-images.githubusercontent.com/51025241/145480528-408dff64-1742-41ea-baac-89bb5458d406.png">
<img width="500" src="https://user-images.githubusercontent.com/51025241/145609351-631db009-ac04-47c9-ae82-0d76af0362d2.png">
## Screenshots
<img width="600" alt="dashboard" src="https://user-images.githubusercontent.com/51025241/147236951-c87d1b2e-9eee-49bb-bc44-1769b9756f45.png">
<img width="600" alt="calendar" src="https://user-images.githubusercontent.com/51025241/147236947-426ee144-fe30-4041-93b0-36a3073a9233.png">
<img width="550" alt="coin" src="https://user-images.githubusercontent.com/51025241/147359139-e2ba33c9-0d10-4b09-a235-c9979658dd9b.png">
<img width="600" alt="1h chart" src="https://user-images.githubusercontent.com/51025241/147358812-b860f5db-a867-4bf4-b98e-b467bb928a25.png">
<img width="600" alt="history" src="https://user-images.githubusercontent.com/51025241/147236956-7b427c72-0a8b-443b-bd24-3eaef3246895.png">
<img width="600" alt="positions" src="https://user-images.githubusercontent.com/51025241/147236958-160a4cd8-c461-46d2-87d1-560d89207a93.png">
<img width="600" alt="projection" src="https://user-images.githubusercontent.com/51025241/147236959-7ca52391-f6bb-496e-bba2-5b914ee333c7.png">


inspirovano : https://github.com/ecoppen/futuresboard.git 
diky

## License
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fecoppen%2Ffuturesboard.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fecoppen%2Ffuturesboard?ref=badge_large)

## Alternative dashboards
- https://github.com/hoeckxer/exchanges_dashboard
- https://github.com/SH-Stark/trading-dashboard
