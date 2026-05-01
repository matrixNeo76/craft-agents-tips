<!-- v1.1.0 - last updated: 2026-05-01 -->

# Security Guide — Credenziali, Permessi, Best Practices

Guida alla sicurezza in Craft Agents: gestione credenziali, isolamento MCP, permessi e best practices.

---

## Indice

- [Come vengono salvate le credenziali?](#come-vengono-salvate-le-credenziali)
- [Quali variabili d'ambiente sono filtrate per gli MCP locali?](#quali-variabili-dambiente-sono-filtrate-per-gli-mcp-locali)
- [Come passare una variabile d'ambiente a un MCP locale?](#come-passare-una-variabile-dambiente-a-un-mcp-locale)
- [Come funzionano i permission modes?](#come-funzionano-i-permission-modes)
- [Quando usare Explore vs Ask to Edit vs Auto?](#quando-usare-explore-vs-ask-to-edit-vs-auto)
- [Come proteggere il server remoto?](#come-proteggere-il-server-remoto)
- [Best practices per le API key](#best-practices-per-le-api-key)
- [Cosa NON fare](#cosa-non-fare)

---

## Come vengono salvate le credenziali?

Le credenziali sono salvate in `~/.craft-agent/credentials.enc`:

- **Algoritmo**: AES-256-GCM (Advanced Encryption Standard, 256-bit, Galois/Counter Mode)
- **Cifratura autenticata**: rileva manomissioni — se qualcuno modifica il file, non decifra
- **Chiave**: derivata dal sistema operativo, non da una password utente
- **Contenuti**: OAuth tokens, API keys, secret di configurazione
- **Formato**: file binario cifrato, non leggibile

**Quindi:**
- ✅ Le credenziali non sono mai in chiaro su disco
- ✅ Se qualcuno ruba il file, non può leggerlo
- ✅ Trasparente per l'utente — l'agente gestisce tutto

---

## Quali variabili d'ambiente sono filtrate per gli MCP locali?

Per prevenire fughe di credenziali, queste variabili sono **bloccate** automaticamente dall'essere passate ai subprocessi MCP:

```bash
# Credenziali AI
ANTHROPIC_API_KEY
CLAUDE_CODE_OAUTH_TOKEN
OPENAI_API_KEY
GOOGLE_API_KEY

# Cloud
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN

# SCM / Package
GITHUB_TOKEN
GH_TOKEN
NPM_TOKEN

# Payment
STRIPE_SECRET_KEY
```

Se un MCP locale ha bisogno di una di queste, va passata esplicitamente via `env`.

---

## Come passare una variabile d'ambiente a un MCP locale?

Configura il source con il campo `env`:

```json
{
  "type": "mcp",
  "config": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": {
      "GITHUB_TOKEN": "il-tuo-token"
    }
  }
}
```

Basta chiedere all'agente:
```
Configura GitHub come MCP passando il mio token
```

---

## Come funzionano i permission modes?

| Mode | Nome UI | Comportamento | Quando usare |
|------|---------|---------------|-------------|
| `safe` | 🛡️ Explore | Sola lettura, blocca tutte le scritture | Navigazione, ricerca, lettura file |
| `ask` | ❓ Ask to Edit | Chiede approvazione prima di ogni azione | Sviluppo normale (default) |
| `allow-all` | ⚡ Auto | Auto-approva tutti i comandi | Task fidati, automazioni, operazioni bulk |

### Come cambiano
- `Shift+Tab` — cicla velocemente durante la sessione
- Visibile nell'header della chat
- Le automazioni possono avere un mode diverso dalla sessione

### Esempio pratico
1. Esplori il filesystem in **Explore** (sicuro, nessun rischio)
2. Trovi il file da modificare → passi a **Ask to Edit**
3. Modifichi → passi a **Auto** per velocità

---

## Quando usare Explore vs Ask to Edit vs Auto?

| Scenario | Mode | Perché |
|----------|------|--------|
| Leggere documentazione | `safe` (Explore) | Solo lettura, zero rischi |
| Cercare file nel filesystem | `safe` (Explore) | Non serve scrivere |
| Sviluppare una feature | `ask` (Ask to Edit) | Vedi ogni modifica prima che avvenga |
| Refactoring bulk | `ask` (Ask to Edit) | Controlli ogni cambiamento |
| Task ripetitivo fidato | `allow-all` (Auto) | L'agente va veloce senza interruzioni |
| Automazione schedulata | `allow-all` (Auto) | Non c'è nessuno ad approvare |
| Backup o sync automatico | `allow-all` (Auto) | Operazione programmata |

**Regola generale**: parti da **Explore**, passa a **Ask** quando devi modificare, usa **Auto** solo per operazioni che faresti comunque.

---

## Come proteggere il server remoto?

1. **TLS obbligatorio** — mai esporre `ws://` su Internet. Usa `wss://`
2. **Token forte** — genera con `openssl rand -hex 32`
3. **Reverse proxy** — Caddy o nginx per rate limiting e HTTPS
4. **Firewall** — limita l'accesso alla porta 9100 a IP fidati
5. **Volume persistente** — le credenziali cifrate vivono nel volume Docker

```bash
# Token sicuro
CRAFT_SERVER_TOKEN=$(openssl rand -hex 32)

# Mai esporre 0.0.0.0 senza TLS
CRAFT_RPC_HOST=0.0.0.0  # ✅ solo con TLS configurato
```

Vedi la [Server Setup Guide](server-setup.md) per configurazione completa.

---

## Best practices per le API key

- **MAI** committare API key in un repository
- **MAI** condividere API key in chat o email
- Usa **variabili d'ambiente** per le API key
- Usa un **password manager** (1Password, Bitwarden) per gestirle
- Ruota le chiavi periodicamente
- Usa chiavi con **scope limitato** (solo quello che serve)
- Craft Agents le salva cifrate in `credentials.enc` — non serve inserirle ogni volta

---

## Cosa NON fare

| ❌ Non fare | Perché | ✅ Invece |
|-------------|--------|-----------|
| Lasciare Explore quando modifichi | L'agente non può fare nulla | Passa ad Ask o Auto |
| Usare Auto per operazioni sconosciute | L'agente potrebbe fare danni | Usa Ask per vedere ogni mossa |
| Esporre ws:// su Internet | Chiunque può connettersi | Usa wss:// con TLS |
| Configurare MCP senza env filtrate | Le credenziali potrebbero essere esposte al MCP | Usa il campo `env` esplicito |
| Salvare API key in file di config | In chiaro su disco | Lascia che Craft Agents le cifri |
| Dimenticare il volume Docker | Sessioni e credenziali perse a ogni restart | Monta `-v craft-data:/root/.craft-agent` |

---

**Vedi anche**: [Server Setup](server-setup.md) | [Tips & Tricks](tips-and-tricks.md) | [Troubleshooting](troubleshooting.md)
