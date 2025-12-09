# Git Setup Instructions

## Inicializace Git repository

```bash
cd /home/martin/dashboard/futuresboard/3x-docker-dashboard-bybit

# Inicializace Git
git init

# Přidat remote repository
git remote add origin https://github.com/PpanchoVilla/3x-docker-dashboard-bybit.git

# Přidat všechny soubory
git add .

# První commit
git commit -m "Initial commit: 3x Bybit Demo Dashboards with Docker"

# Push do GitHubu
git branch -M main
git push -u origin main
```

## Před push - Zabezpečení API klíčů

**DŮLEŽITÉ:** Před push do GitHubu odstraňte API klíče z config souborů!

```bash
# Vytvořte template z config1.json
cd config

# Nahraďte skutečné API klíče placeholdery
sed -i 's/"API_KEY": ".*"/"API_KEY": "YOUR_BYBIT_DEMO_API_KEY_1"/g' config1.json
sed -i 's/"API_SECRET": ".*"/"API_SECRET": "YOUR_BYBIT_DEMO_API_SECRET_1"/g' config1.json

sed -i 's/"API_KEY": ".*"/"API_KEY": "YOUR_BYBIT_DEMO_API_KEY_2"/g' config2.json
sed -i 's/"API_SECRET": ".*"/"API_SECRET": "YOUR_BYBIT_DEMO_API_SECRET_2"/g' config2.json

sed -i 's/"API_KEY": ".*"/"API_KEY": "YOUR_BYBIT_DEMO_API_KEY_3"/g' config3.json
sed -i 's/"API_SECRET": ".*"/"API_SECRET": "YOUR_BYBIT_DEMO_API_SECRET_3"/g' config3.json
```

## Struktura souborů v repository

```
3x-docker-dashboard-bybit/
├── .gitignore                    # Git ignore pravidla
├── README.md                     # Hlavní dokumentace (EN)
├── README_CZ.md                  # Česká dokumentace
├── LICENSE                       # GPL v3 licence
├── QUICKSTART.md                 # Rychlý start
├── SETUP.md                      # Kompletní setup
├── BYBIT_API_SETUP.md           # Návod na API klíče
├── BYBIT_DEMO_FIX.md            # Technické poznámky
├── CHANGES.md                   # Seznam změn
├── Dockerfile                   # Docker image
├── docker-compose.yaml          # Docker orchestrace
├── requirements.txt             # Python dependencies
├── setup.py                     # Python setup
├── setup.cfg                    # Python konfigurace
├── Makefile                     # Make příkazy
├── start.sh                     # Spouštěcí skript
├── check-config.sh              # Kontrolní skript
├── config/
│   ├── config.json.example      # Příklad konfigurace
│   ├── config1.json             # Dashboard 1 (bez API klíčů!)
│   ├── config2.json             # Dashboard 2 (bez API klíčů!)
│   └── config3.json             # Dashboard 3 (bez API klíčů!)
├── nginx/
│   ├── nginx.conf               # Nginx konfigurace
│   └── ssl/
│       └── README.md            # SSL návod
└── src/
    └── futuresboard/            # Zdrojový kód aplikace
```

## .gitignore kontrola

Ujistěte se, že `.gitignore` obsahuje:
```
# Databáze
*.db
*.db-journal
data1/
data2/
data3/

# Python
__pycache__/
*.py[cod]
*.egg-info/
build/
dist/

# SSL certifikáty
nginx/ssl/*.pem

# Environment
.env
```

## Po naklonování repository

Uživatelé po klonování repository musí:

1. Upravit config soubory s vlastními API klíči
2. Vygenerovat SSL certifikáty (pokud potřebují HTTPS)
3. Spustit `docker compose build && docker compose up -d`

## Alternativní metoda - GitHub CLI

```bash
# Přihlášení do GitHub
gh auth login

# Vytvoření repository
gh repo create PpanchoVilla/3x-docker-dashboard-bybit --public --source=. --remote=origin

# Push
git add .
git commit -m "Initial commit: 3x Bybit Demo Dashboards"
git push -u origin main
```
