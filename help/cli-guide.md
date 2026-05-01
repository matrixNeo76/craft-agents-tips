<!-- v1.1.0 - last updated: 2026-05-01 -->

# CLI Guide — Riferimento Completo per craft-cli

Guida al terminal client di Craft Agents. Connette via WebSocket a un server headless per scripting, CI/CD e automazioni.

---

## Indice

- [Come installare la CLI?](#come-installare-la-cli)
- [Come connettersi a un server?](#come-connettersi-a-un-server)
- [Quali comandi sono disponibili?](#quali-comandi-sono-disponibili)
- [Come inviare un messaggio e streamare la risposta?](#come-inviare-un-messaggio-e-streamare-la-risposta)
- [Come usare il comando run (self-contained)?](#come-usare-il-comando-run-self-contained)
- [Come specificare provider e modello?](#come-specificare-provider-e-modello)
- [Come validare il server?](#come-validare-il-server)
- [Come usare la CLI in script e CI/CD?](#come-usare-la-cli-in-script-e-cicd)
- [Come gestire TLS e certificati self-signed?](#come-gestire-tls-e-certificati-self-signed)
- [Troubleshooting CLI](#troubleshooting-cli)

---

## Come installare la CLI?

**Prerequisiti**: [Bun](https://bun.sh/) runtime.

**Opzione A — Da monorepo:**
```bash
git clone https://github.com/lukilabs/craft-agents-oss.git
cd craft-agents-oss
bun install
bun run apps/cli/src/index.ts --help
```

**Opzione B — Alias globale:**
```bash
alias craft-cli="bun run $(pwd)/apps/cli/src/index.ts"
```

---

## Come connettersi a un server?

### Connessione base
```bash
# Via flags
craft-cli --url ws://127.0.0.1:9100 --token <token> ping

# Via environment variables
export CRAFT_SERVER_URL=ws://127.0.0.1:9100
export CRAFT_SERVER_TOKEN=<token>
craft-cli ping
```

### Opzioni di connessione

| Flag | Env var | Default | Descrizione |
|------|---------|---------|-------------|
| `--url <ws[s]://...>` | `CRAFT_SERVER_URL` | — | URL WebSocket del server |
| `--token <secret>` | `CRAFT_SERVER_TOKEN` | — | Token di autenticazione |
| `--workspace <id>` | — | auto-detect | ID workspace |
| `--timeout <ms>` | — | `10000` | Timeout richiesta |
| `--tls-ca <path>` | `CRAFT_TLS_CA` | — | Certificato CA custom per self-signed TLS |
| `--json` | — | `false` | Output JSON per scripting |
| `--send-timeout <ms>` | — | `300000` | Timeout per comando send |

---

## Quali comandi sono disponibili?

### Info & Health
```bash
craft-cli ping              # Verifica connettività (clientId + latenza)
craft-cli health            # Stato credential store
craft-cli versions          # Versioni runtime del server
```

### Resource Listing
```bash
craft-cli workspaces        # Lista workspace
craft-cli sessions          # Lista sessioni nel workspace
craft-cli connections       # Lista connessioni LLM
craft-cli sources           # Lista sources configurati
```

### Session Operations
```bash
craft-cli session create --name "Test" --mode ask  # Crea sessione
craft-cli session messages <id>                    # Storia messaggi
craft-cli session delete <id>                      # Elimina sessione
craft-cli cancel <id>                              # Cancella elaborazione
```

---

## Come inviare un messaggio e streamare la risposta?

```bash
craft-cli send <session-id> <message>
```

**Streaming events:**
- `text_delta` — testo in tempo reale
- `tool_start` — `[tool: nome]` marker
- `tool_result` — output tool (troncato a 200 caratteri)
- `error` — stampato su stderr, exit code 1
- `complete` — exit code 0
- `interrupted` — exit code 130

**Pipe da stdin:**
```bash
echo "Summarize this" | craft-cli send <session-id>
cat error.log | craft-cli send <session-id>
```

---

## Come usare il comando run (self-contained)?

Il comando `run` è **auto-contenuto**: spawna un server headless, crea una sessione, invia il prompt, streama la risposta ed esce.

```bash
# Base
craft-cli run "Summarize the README"

# Con workspace e source
craft-cli run --workspace-dir ./my-project --source github "List open PRs"

# Pipe da stdin
echo "Cosa c'è in questo file?" | craft-cli run
cat error.log | craft-cli run "What's causing these errors?"
```

### Flags specifici di run

| Flag | Default | Descrizione |
|------|---------|-------------|
| `--workspace-dir <path>` | — | Registra directory workspace |
| `--source <slug>` | — | Abilita un source (ripetibile) |
| `--output-format <fmt>` | `text` | `text` o `stream-json` |
| `--mode <mode>` | `allow-all` | Permission mode |
| `--no-cleanup` | `false` | Non eliminare la sessione all'uscita |
| `--server-entry <path>` | — | Entry point server custom |

---

## Come specificare provider e modello?

```bash
# Provider specifico
craft-cli run --provider openai --model gpt-4o "Ciao"
craft-cli run --provider google --model gemini-2.0-flash "Ciao"

# Custom base URL (OpenRouter, proxy, self-hosted)
craft-cli run --provider anthropic \
  --base-url https://openrouter.ai/api/v1 \
  --api-key $OR_KEY "Ciao"

# API key da environment variable
GOOGLE_API_KEY=... craft-cli run --provider google "Ciao"
```

| Flag | Env Fallback | Default | Descrizione |
|------|-------------|---------|-------------|
| `--provider <name>` | `LLM_PROVIDER` | `anthropic` | `anthropic`, `openai`, `google`, `openrouter`, `groq`, `mistral`, `xai`... |
| `--model <id>` | `LLM_MODEL` | default provider | `claude-sonnet-4`, `gpt-4o`, `gemini-2.0-flash` |
| `--api-key <key>` | `LLM_API_KEY` | env provider | Check anche `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`... |
| `--base-url <url>` | `LLM_BASE_URL` | — | Endpoint custom |

---

## Come validare il server?

Il comando `--validate-server` esegue un test di integrazione in **21 step**:

```bash
# Contro un server in esecuzione
craft-cli --validate-server --url ws://127.0.0.1:9100 --token <token>

# Auto-contenuto (spawna server locale)
craft-cli --validate-server
```

**Cosa testa:**
1. Connect + handshake
2. Health check credenziali
3. Versioni sistema
4. Home directory
5. Workspace listing
6. Sessione: crea, invia messaggio, streama risposta
7. Tool use (Bash tool)
8. Source: crea, usa, elimina
9. Skill: crea, menziona, elimina
10. Disconnect

---

## Come usare la CLI in script e CI/CD?

### Ottenere workspace IDs
```bash
WORKSPACES=$(craft-cli --json workspaces | jq -r '.[].id')
```

### Contare sessioni per workspace
```bash
for ws in $WORKSPACES; do
  COUNT=$(craft-cli --json --workspace "$ws" sessions | jq length)
  echo "$ws: $COUNT sessions"
done
```

### Creare sessione, inviare messaggio, pulire
```bash
SESSION_ID=$(craft-cli --json session create --name "CI Run" | jq -r '.id')
craft-cli send "$SESSION_ID" "Run the test suite"
craft-cli session delete "$SESSION_ID"
```

### Output JSON per machine-readable
```bash
craft-cli --json workspaces | jq '.[].name'
```

---

## Come gestire TLS e certificati self-signed?

```bash
# Certificato trusted (Let's Encrypt)
craft-cli --url wss://server.example.com:9100 ping

# Self-signed certificate
craft-cli --url wss://server.example.com:9100 --tls-ca /path/to/ca.pem ping
```

`--tls-ca` setta `NODE_EXTRA_CA_CERTS` prima di connettersi. Alternativa via env:
```bash
export CRAFT_TLS_CA=/path/to/ca.pem
```

---

## Troubleshooting CLI

| Sintomo | Causa | Soluzione |
|---------|-------|-----------|
| `Connection timeout` | Server non raggiungibile | Verifica server, URL, firewall |
| `AUTH_FAILED` | Token sbagliato | Controlla `CRAFT_SERVER_TOKEN` matcha server |
| `PROTOCOL_VERSION_UNSUPPORTED` | Version mismatch | Aggiorna CLI e server alla stessa versione |
| `WebSocket connection error` | Problema di rete o TLS | Per self-signed usa `--tls-ca` |
| `No workspace available` | Workspace non creato | Crealo via app desktop o API |

---

**Vedi anche**: [Quickstart](quickstart.md) | [Server Setup](server-setup.md) | [Troubleshooting](troubleshooting.md)
