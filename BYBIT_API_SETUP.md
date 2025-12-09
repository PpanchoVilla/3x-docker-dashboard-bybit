# Jak získat Bybit Demo API klíče

## Krok 1: Registrace na Bybit

1. Přejděte na [Bybit.com](https://www.bybit.com)
2. Zaregistrujte se nebo se přihlaste

## Krok 2: Aktivace Demo Trading

1. V hlavním menu klikněte na **"Demo Trading"** nebo přejděte na [testnet.bybit.com](https://testnet.bybit.com)
2. Přepněte se do **Demo režimu** (vpravo nahoře)
3. Demo účet má virtuální USDT pro testování

## Krok 3: Vytvoření API klíčů

### Pro každý dashboard budete potřebovat samostatný API klíč:

1. Přihlaste se do **Demo Trading** módu
2. Klikněte na svůj profil → **API Management** (nebo přejděte na [testnet.bybit.com/app/user/api-management](https://testnet.bybit.com/app/user/api-management))
3. Klikněte na **Create New Key**

### Nastavení API klíče:

- **API Key Type:** System-generated API Keys
- **API Key Name:** `Dashboard1` (nebo Dashboard2, Dashboard3)
- **Permissions:** 
  - ✅ **Read-Write** (nebo jen **Read** pokud chcete pouze zobrazení)
  - ✅ **Contract** (důležité pro futures trading)
- **IP Restriction:** Ponechte prázdné pro testování (nebo přidejte IP vašeho serveru)

4. Klikněte na **Submit**
5. **Důležité:** Zkopírujte a uložte si:
   - **API Key**
   - **Secret Key** (zobrazí se pouze jednou!)

6. Opakujte pro další dva dashboardy (celkem 3× API klíče)

## Krok 4: Vložení API klíčů do konfigurace

Upravte soubory v `config/`:

### config/config1.json
```json
{
    "EXCHANGE": "bybit",
    "TEST_MODE": false,
    "DEMO_MODE": true,
    "API_KEY": "VÁŠ_PRVNÍ_API_KEY",
    "API_SECRET": "VÁŠ_PRVNÍ_API_SECRET",
    ...
}
```

### config/config2.json
```json
{
    "EXCHANGE": "bybit",
    "TEST_MODE": false,
    "DEMO_MODE": true,
    "API_KEY": "VÁŠ_DRUHÝ_API_KEY",
    "API_SECRET": "VÁŠ_DRUHÝ_API_SECRET",
    ...
}
```

### config/config3.json
```json
{
    "EXCHANGE": "bybit",
    "TEST_MODE": false,
    "DEMO_MODE": true,
    "API_KEY": "VÁŠ_TŘETÍ_API_KEY",
    "API_SECRET": "VÁŠ_TŘETÍ_API_SECRET",
    ...
}
```

## Krok 5: Ověření konfigurace

```bash
# Zkontrolujte, že jste správně vyplnili všechny API klíče
grep -A 1 "API_KEY" config/config*.json
```

## Důležité poznámky

### Demo vs Testnet vs Production

- **Demo (api-demo.bybit.com):** Virtuální účet s fake penězi - **TO POUŽÍVÁME** ✅
  - Nejbezpečnější pro testování
  - Virtuální USDT
  - Reálná tržní data
  - `"DEMO_MODE": true`

- **Testnet (api-testnet.bybit.com):** Testovací síť Bybit
  - `"TEST_MODE": true, "DEMO_MODE": false`

- **Production (api.bybit.com):** Skutečné peníze - **NEPOUŽÍVAT!** ❌
  - `"TEST_MODE": false, "DEMO_MODE": false`

### Konfigurace v našem projektu:

```json
{
    "EXCHANGE": "bybit",
    "TEST_MODE": false,      // ← Vypnuto (ne testnet)
    "DEMO_MODE": true,       // ← Zapnuto (demo režim)
    ...
}
```

Toto nastavení použije **https://api-demo.bybit.com** endpoint.

## Bezpečnostní tipy

1. **Nikdy nepoužívejte produkční API klíče** pro testování
2. **Používejte read-only API klíče** pokud nepotřebujete obchodovat
3. **Chraňte své API klíče** - nepublikujte je na GitHub
4. **IP Restriction** - v produkci nastavte IP whitelist
5. **Pravidelně rotujte klíče** - zvláště pokud byly kompromitovány

## Troubleshooting

### "Invalid API Key" chyba

- Zkontrolujte, že používáte **Demo API klíče** (ne produkční)
- Ověřte, že klíče jsou správně zkopírované (bez mezer)
- Zkontrolujte, že `"DEMO_MODE": true` v config.json

### "Permission denied" chyba

- Ujistěte se, že API klíč má **Contract** permissions
- Pro zobrazení dat stačí **Read** oprávnění
- Pro trading potřebujete **Read-Write**

### "Rate limit exceeded"

- Bybit Demo má limit 120 requestů/min
- Dashboard automaticky čeká při dosažení limitu
- Můžete zvýšit `AUTO_SCRAPE_INTERVAL` v config.json

## Další zdroje

- [Bybit API Documentation](https://bybit-exchange.github.io/docs/v5/intro)
- [Bybit Demo Trading](https://testnet.bybit.com)
- [Bybit API Management](https://testnet.bybit.com/app/user/api-management)
