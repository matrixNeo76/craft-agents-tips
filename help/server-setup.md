<!-- v1.1.0 - last updated: 2026-05-01 -->

# Server Setup Guide — Headless Server, Docker, TLS

Guida per configurare Craft Agents in modalità headless su un server remoto (VPS, Docker) e connettere il desktop client.

---

## Indice

- [Quando usare il server headless?](#quando-usare-il-server-headless)
- [Come avviare un server base?](#come-avviare-un-server-base)
- [Come configurare TLS?](#come-configurare-tls)
- [Come usare Docker?](#come-usare-docker)
- [Quali variabili d'ambiente servono?](#quali-variabili-dambiente-servono)
- [Come connettere il desktop client?](#come-connettere-il-desktop-client)
- [Come usare un reverse proxy?](#come-usare-un-reverse-proxy)
- [Best practices per server in produzione](#best-practices-per-server-in-produzione)
- [Troubleshooting server](#troubleshooting-server)

---

## Quando usare il server headless?

**Scenario ideale** per server headless:
- Sessioni long-running che devono sopravvivere alla chiusura del client
- Accesso da più macchine (es. laptop a casa + ufficio)
- Compute pesante su un server potente (VPS, dedicato)
- CI/CD e automazioni via CLI
- Team condiviso che usa lo stesso server

**Architettura thin-client:**
```
Desktop App (UI only) ←── WebSocket wss:// ──→ Headless Server (VPS/Docker)
                         Session loop, Tool execution, LLM calls
```

---

## Come avviare un server base?

```bash
# Genera un token di sicurezza
CRAFT_SERVER_TOKEN=$(openssl rand -hex 32)

# Avvia il server
CRAFT_SERVER_TOKEN=$CRAFT_SERVER_TOKEN bun run packages/server/src/index.ts
```

Il server stampa:
```
CRAFT_SERVER_URL=ws://203.0.113.5:9100
CRAFT_SERVER_TOKEN=<generated-token>
```

**Bind address predefinito**: `127.0.0.1` (solo locale). Per accesso remoto serve `0.0.0.0`.

---

## Come configurare TLS?

### Certificato self-signed (dev/test)

```bash
# Genera certificato (365 giorni)
./scripts/generate-dev-cert.sh
# Crea certs/cert.pem e certs/key.pem

# Avvia con TLS
CRAFT_SERVER_TOKEN=<token> \
CRAFT_RPC_HOST=0.0.0.0 \
CRAFT_RPC_TLS_CERT=certs/cert.pem \
CRAFT_RPC_TLS_KEY=certs/key.pem \
bun run packages/server/src/index.ts
```

### Certificato trusted (produzione)

Usa Let's Encrypt, Caddy o un reverse proxy con certificato valido.

```bash
# Con certificato Let's Encrypt
CRAFT_SERVER_TOKEN=<token> \
CRAFT_RPC_TLS_CERT=/etc/letsencrypt/live/example.com/fullchain.pem \
CRAFT_RPC_TLS_KEY=/etc/letsencrypt/live/example.com/privkey.pem \
bun run packages/server/src/index.ts
```

---

## Come usare Docker?

### Run base
```bash
docker run -d \
  -p 9100:9100 \
  -e CRAFT_SERVER_TOKEN=<token> \
  -e CRAFT_RPC_HOST=0.0.0.0 \
  -v craft-data:/root/.craft-agent \
  craft-agents-server
```

### Con TLS
```bash
docker run -d \
  -p 9100:9100 \
  -e CRAFT_SERVER_TOKEN=<token> \
  -e CRAFT_RPC_HOST=0.0.0.0 \
  -e CRAFT_RPC_TLS_CERT=/certs/cert.pem \
  -e CRAFT_RPC_TLS_KEY=/certs/key.pem \
  -v ./certs:/certs:ro \
  -v craft-data:/root/.craft-agent \
  craft-agents-server
```

### Build da sorgente
```bash
docker build -f Dockerfile.server -t craft-agents-server .
```

### Volume persistente
Il volume `craft-data:/root/.craft-agent` mantiene:
- Configurazione workspace
- Credenziali cifrate
- Sessioni salvate
- Sources configurati

Senza volume, tutto viene perso a ogni restart del container.

---

## Quali variabili d'ambiente servono?

| Variabile | Obbligatoria | Default | Descrizione |
|-----------|-------------|---------|-------------|
| `CRAFT_SERVER_TOKEN` | ✅ Sì | — | Token Bearer per autenticazione client |
| `CRAFT_RPC_HOST` | No | `127.0.0.1` | Bind address (`0.0.0.0` per remoto) |
| `CRAFT_RPC_PORT` | No | `9100` | Porta di ascolto |
| `CRAFT_RPC_TLS_CERT` | No | — | Path a file PEM del certificato (abilita wss://) |
| `CRAFT_RPC_TLS_KEY` | No | — | Path a file PEM della chiave privata |
| `CRAFT_RPC_TLS_CA` | No | — | Path a file PEM catena CA (per verifica client cert) |
| `CRAFT_DEBUG` | No | `false` | Logging verboso |

**Provider LLM**: servono anche le API key per i provider che intendi usare:
```bash
ANTHROPIC_API_KEY=sk-...
# oppure
OPENAI_API_KEY=...
# oppure
GOOGLE_API_KEY=...
```

---

## Come connettere il desktop client?

```bash
# macOS / Linux
CRAFT_SERVER_URL=wss://203.0.113.5:9100 \
CRAFT_SERVER_TOKEN=<token> \
bun run electron:start

# Windows (PowerShell)
$env:CRAFT_SERVER_URL="wss://203.0.113.5:9100"
$env:CRAFT_SERVER_TOKEN="<token>"
bun run electron:start
```

Il client diventa un **thin client**: tutta la UI rende l'interfaccia, ma session loop, tool execution e LLM calls girano sul server remoto.

---

## Come usare un reverse proxy?

### Con Caddy (consigliato — TLS automatico)
```caddy
wss://agents.example.com {
    reverse_proxy localhost:9100
}
```

### Con nginx
```nginx
map $http_upgrade $connection_upgrade {
    default  upgrade;
    ''       close;
}

server {
    listen 443 ssl;
    server_name agents.example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:9100;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Host $host;
    }
}
```

---

## Best practices per server in produzione

### 🔒 Sicurezza
- **Mai** esporre su `0.0.0.0` senza TLS
- Usa **sempre** TLS in produzione (`wss://`)
- Genera token con `openssl rand -hex 32` (256 bit)
- Considera un reverse proxy con rate limiting
- Isola le credenziali LLM sul server

### ⚡ Performance
- Docker volume persistente per `~/.craft-agent/`
- Server con almeno 4GB RAM (LLM calls consumano memoria)
- CPU: meglio single-core veloce che multi-core lento (il loop è sequenziale)

### 🔄 Manutenzione
- Log in `~/.craft-agent/logs/` sul server
- Monitora spazio su disco (sessioni JSONL crescono)
- Backup periodico del volume Docker

---

## Troubleshooting server

| Sintomo | Causa | Soluzione |
|---------|-------|-----------|
| Server non si avvia | Porta occupata | Cambia `CRAFT_RPC_PORT` o kill processo |
| `ECONNREFUSED` | Server non in ascolto su `0.0.0.0` | Imposta `CRAFT_RPC_HOST=0.0.0.0` |
| `SELF_SIGNED_CERT_IN_CHAIN` | Certificato non trustato | Usa `--tls-ca` sul client o certificato valido |
| Connessione cade dopo 60s | Timeout WebSocket | Verifica reverse proxy e firewall |
| Docker: sessioni perse | Volume non montato | Aggiungi `-v craft-data:/root/.craft-agent` |

---

**Vedi anche**: [CLI Guide](cli-guide.md) | [Architecture Overview](architecture-overview.md) | [Quickstart](quickstart.md)
