<!-- v1.0.0 - last updated: 2026-05-01 -->

# Troubleshooting — Problemi Comuni e Soluzioni

Guida diagnostica per risolvere i problemi più frequenti con Craft Agents OSS.

---

## Indice dei Problemi

### Avvio & Installazione
- [SDK Path Resolution Error: "The path argument must be of type string"](#sdk-path-resolution-error-the-path-argument-must-be-of-type-string)
- [Errore: "Cannot find module" o build fallita](#errore-cannot-find-module-o-build-fallita)
- [App non si avvia su Windows/macOS](#app-non-si-avvia-su-windowsmacos)

### Autenticazione
- [Errore OAuth: token scaduto o non valido](#errore-oauth-token-scaduto-o-non-valido)
- [API Key non riconosciuta](#api-key-non-riconosciuta)
- [GitHub Copilot OAuth fallisce](#github-copilot-oauth-fallisce)

### MCP Server
- [MCP server locale non si connette](#mcp-server-locale-non-si-connette)
- [Errore: "env var not passed to MCP subprocess"](#errore-env-var-not-passed-to-mcp-subprocess)
- [MCP server HTTP remoto non raggiungibile](#mcp-server-http-remoto-non-raggiungibile)

### Connessione & Rete
- [WebSocket: errore di connessione al server remoto](#websocket-errore-di-connessione-al-server-remoto)
- [Self-signed TLS certificate non accettato](#self-signed-tls-certificate-non-accettato)

### Agente & Sessioni
- [AgentEvent Type Mismatches: proprietà sbagliate](#agentevent-type-mismatches-proprietà-sbagliate)
- [Le risposte sono troncate/incomplete](#le-risposte-sono-troncate-incomplete)
- [La sessione non persiste tra riavvii](#la-sessione-non-persiste-tra-riavvii)

### Build & Sviluppo
- [esbuild failure: external modules](#esbuild-failure-external-modules)
- [Errore "AgentEvent type mismatch" in codice custom](#errore-agentevent-type-mismatch-in-codice-custom)

---

## SDK Path Resolution Error: "The path argument must be of type string"

**Sintomo:**
```
Error: The "path" argument must be of type string or an instance of URL. Received undefined
```

**Causa:**
Il Claude Agent SDK usa `import.meta.url` per trovare `cli.js`. Dopo il bundle esbuild, questo path è invalido.

**Soluzione:**
Imposta il path esplicitamente prima di creare agent:
```typescript
import { setPathToClaudeCodeExecutable } from '../../../src/agent/options'

const cliPath = join(process.cwd(), 'node_modules', '@anthropic-ai', 'claude-agent-sdk', 'cli.js')
setPathToClaudeCodeExecutable(cliPath)
```

**Riferimento:** README.md, Key Learnings & Gotchas #1.

---

## Errore: "Cannot find module" o build fallita

**Sintomo:**
```
Error: Cannot find module '@anthropic-ai/claude-agent-sdk'
```

**Causa:**
Dipendenza mancante o `bun install` non eseguito.

**Soluzioni:**
```bash
bun install
# Oppure:
bun install --force
```

**Se persiste:**
```bash
rm -rf node_modules bun.lock
bun install
```

---

## App non si avvia su Windows/macOS

**Sintomo:**
L'app si chiude immediatamente o non parte.

**Causa comune 1:** Variabili d'ambiente mancanti per OAuth.
**Soluzione:**
```bash
# Crea .env e popola
cp .env.example .env
# Edita .env con le tue credenziali
```

**Causa comune 2:** Porta già in uso (per server locale).
**Soluzione:** Controlla se un'altra istanza è in esecuzione.

**Causa comune 3:** Permessi insufficienti su `~/.craft-agent/`.
**Soluzione:**
```bash
chmod -R 755 ~/.craft-agent/
```

**Debug:**
```bash
./craft-agents -- --debug
# Controlla i log (vedi [Log paths](#log-paths-per-os))
```

---

## Errore OAuth: token scaduto o non valido

**Sintomo:**
L'agente mostra errori 401/403 su chiamate API (Gmail, Slack, etc.).

**Causa:**
Token OAuth scaduto. I token di refresh potrebbero non essere riusciti.

**Soluzione:**
1. Vai nelle impostazioni del source
2. Disconnetti e riconnetti il source OAuth
3. Oppure: `rimuovi Gmail e riconnettilo`

**Prevenzione:**
- I token vengono refreshati automaticamente, ma se non usi un source per molto tempo potrebbero scadere
- Riconnetti periodicamente i source che usi raramente

---

## API Key non riconosciuta

**Sintomo:**
```
Error: 401 Unauthorized - API key invalid
```

**Cause comuni e soluzioni:**
1. **API key errata** → verifica nella dashboard del provider
2. **Provider sbagliato** → stai usando un API key Anthropic con un provider OpenAI
3. **Endpoint sbagliato** → per third-party (OpenRouter) serve l'endpoint corretto
4. **Variabile d'ambiente** se usi la CLI: `ANTHROPIC_API_KEY=sk-...` o `$LLM_API_KEY`

---

## GitHub Copilot OAuth fallisce

**Sintomo:**
Il dispositivo code flow si blocca o dà errore.

**Soluzione:**
1. Assicurati di avere un abbonamento GitHub Copilot attivo
2. Riavvia il flusso OAuth
3. Verifica che il browser non blocchi i popup
4. Se persiste, prova dalla CLI:
```bash
craft-cli run --provider copilot "Hello"
```

---

## MCP server locale non si connette

**Sintomo:**
L'agente dice "MCP server not reachable" o non trova i tools.

**Diagnostica:**
1. **Il comando esiste?** Verifica manualmente:
   ```bash
   npx -y @modelcontextprotocol/server-github --version
   ```
2. **Dipendenze installate?** Per MCP Python: `pip install -r requirements.txt`
3. **Porta occupata?** Se l'MCP usa una porta fissa, controlla conflitti
4. **Debug:** avvia l'MCP manualmente in un terminale per vedere errori:
   ```bash
   npx -y @modelcontextprotocol/server-github
   ```

**Soluzioni comuni:**
- Usa `npx -y` invece di `npx` per evitare il prompt di installazione
- Per MCP Python, specifica il path completo di `python`
- Verifica che l'MCP sia raggiungibile prima di configurarlo in Craft Agents

---

## Errore: "env var not passed to MCP subprocess"

**Sintomo:**
Un MCP locale non riesce ad autenticarsi perché manca una variabile d'ambiente.

**Causa:**
Craft Agents filtra automaticamente le variabili d'ambiente sensibili per sicurezza.

**Soluzione:**
Aggiungi la variabile manualmente nella configurazione del source:
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-github"],
  "env": {
    "GITHUB_TOKEN": "il-tuo-token"
  }
}
```

**Lista variabili filtrate:**
`ANTHROPIC_API_KEY`, `CLAUDE_CODE_OAUTH_TOKEN`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, `GITHUB_TOKEN`, `GH_TOKEN`, `OPENAI_API_KEY`, `GOOGLE_API_KEY`, `STRIPE_SECRET_KEY`, `NPM_TOKEN`.

---

## MCP server HTTP remoto non raggiungibile

**Sintomo:**
`Error: connect ECONNREFUSED` o timeout.

**Soluzioni:**
1. **Il server è in esecuzione?** Verifica sul server remoto
2. **Firewall?** Controlla che la porta sia aperta
3. **TLS?** Se usi `wss://`, servono certificati validi
4. **Bind address?** Il server deve essere su `0.0.0.0` (non `127.0.0.1`) per accesso remoto:
   ```bash
   CRAFT_RPC_HOST=0.0.0.0 bun run packages/server/src/index.ts
   ```

---

## WebSocket: errore di connessione al server remoto

**Sintomo:**
`Error: WebSocket connection failed`

**Soluzioni:**
1. **URL corretto?** Usa `ws://` per non-TLS, `wss://` per TLS
2. **Token valido?** `CRAFT_SERVER_TOKEN` deve matchare server e client
3. **Self-signed cert?** Usa `--tls-ca <path>` o `CRAFT_TLS_CA`
4. **Firewall?** Porta 9100 (default) aperta?
5. **Timeout?** Aumenta con `--timeout 30000`

---

## Self-signed TLS certificate non accettato

**Sintomo:**
`Error: self-signed certificate in certificate chain`

**Soluzione:**
```bash
craft-cli --url wss://tuo-server:9100 --token <token> --tls-ca certs/cert.pem ping
```

O setta la variabile d'ambiente:
```bash
export CRAFT_TLS_CA=/path/to/cert.pem
```

---

## AgentEvent Type Mismatches: proprietà sbagliate

**Sintomo:**
Nel codice custom, le proprietà degli eventi non corrispondono a quanto documentato.

**Causa:**
I tipi `AgentEvent` usano nomi di proprietà diversi da quanto ci si aspetterebbe.

**Tabella corretta:**

| Event Type | Proprietà SBAGLIATA | Proprietà CORRETTA |
|------------|---------------------|---------------------|
| `text_delta` | `event.delta` | `event.text` |
| `error` | `event.error` | `event.message` |
| `tool_result` | `event.toolName` | Solo `event.toolUseId` |

**Workaround per tool_result:**
Tieni traccia del mapping `toolUseId → toolName`:
```typescript
// In tool_start handler:
managedSession.pendingTools.set(event.toolUseId, event.toolName)

// In tool_result handler:
const toolName = managedSession.pendingTools.get(event.toolUseId) || 'unknown'
managedSession.pendingTools.delete(event.toolUseId)
```

---

## Le risposte sono troncate/incomplete

**Causa:**
Tool responses oltre ~60KB vengono automaticamente riassunte.

**Se hai bisogno del contenuto completo:**
1. Chiedi esplicitamente all'agente di non riassumere
2. Per dati critici, salva su file e leggili separatamente
3. Verifica che `_intent` field sia corretto negli MCP tool schemas

---

## La sessione non persiste tra riavvii

**Sintomo:**
Dopo aver chiuso e riaperto l'app, le sessioni precedenti non ci sono.

**Soluzioni:**
1. Controlla `~/.craft-agent/workspaces/{id}/sessions/` — i file JSONL ci sono?
2. Se no, permessi sulla directory
3. Se sì, problema di caricamento — riavvia in debug mode
4. Verifica che il workspace configurato sia quello giusto

---

## esbuild failure: external modules

**Sintomo:**
Errore di build: `Error: Could not resolve "@anthropic-ai/claude-agent-sdk"`

**Causa:**
Solo `electron` è externalizzato in esbuild. L'SDK è bundlelizzato.

**Soluzione:**
Non c'è — è voluto. SDK code viene inlined (~950KB).

**Se vuoi externalizzare:**
```json
"electron:build:main": "esbuild ... --external:electron --external:@anthropic-ai/claude-agent-sdk"
```
Poi assicurati che il modulo sia disponibile a runtime.

---

## Errore AgentEvent type mismatch in codice custom

Vedi [AgentEvent Type Mismatches](#agentevent-type-mismatches-proprietà-sbagliate) sopra.

**Riepilogo rapido:**
- Usa `event.text`, non `event.delta` per text_delta
- Usa `event.message`, non `event.error` per error
- Traccia `toolUseId → toolName` manualmente per tool_result

---

## Dove Trovare i Log

| OS | Path |
|----|------|
| **macOS** | `~/Library/Logs/@craft-agent/electron/main.log` |
| **Windows** | `%APPDATA%\@craft-agent\electron\logs\main.log` |
| **Linux** | `~/.config/@craft-agent/electron/logs/main.log` |

**Prefix chiave per cercare:**
```bash
grep '\[SessionManager\]' main.log    # Session lifecycle
grep '\[IPC\]' main.log               # Communication
grep 'ERROR' main.log                 # Errori
grep 'WARN' main.log                  # Warning
```

**Log in tempo reale (macOS/Linux):**
```bash
tail -f ~/Library/Logs/@craft-agent/electron/main.log
```

---

**Se il tuo problema non è elencato qui**, prova a:
1. Chiedere all'agente: "Debugga questo problema: ..."
2. Aprire una [issue su GitHub](https://github.com/lukilabs/craft-agents-oss/issues)
3. Contribuire con una soluzione — [CONTRIBUTING.md](../CONTRIBUTING.md)

---

**Vedi anche**:
- [Architecture Overview](architecture-overview.md) — capire come funziona dentro
- [Tips & Tricks](tips-and-tricks.md) — debug mode e log
- [Sources Guide](sources-guide.md) — troubleshooting fonti dati
- [Quickstart](quickstart.md) — verificare installazione
