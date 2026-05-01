<!-- v1.0.0 - last updated: 2026-05-01 -->

# Quickstart — Primi Passi con Craft Agents

Guida rapida per installare, configurare e fare la prima sessione con Craft Agents OSS.

---

## Indice delle Domande

- [Come installo Craft Agents?](#come-installo-craft-agents)
- [Come avvio l'app per la prima volta?](#come-avvio-lapp-per-la-prima-volta)
- [Come scelgo un provider LLM?](#come-scelgo-un-provider-llm)
- [Cos'è un workspace e come lo creo?](#cosè-un-workspace-e-come-lo-creo)
- [Come faccio la prima domanda?](#come-faccio-la-prima-domanda)
- [Cosa significa "agent-native"?](#cosa-significa-agent-native)
- [Come connetto un servizio esterno?](#come-connetto-un-servizio-esterno)
- [Quali sono i comandi base della CLI?](#quali-sono-i-comandi-base-della-cli)

---

## Come installo Craft Agents?

Guarda la [demo video](https://www.youtube.com/watch?v=xQouiAIilvU) per capire cosa fa Craft Agents prima di installarlo.

### Installazione One-Line (Raccomandata)

**macOS / Linux:**
```bash
curl -fsSL https://agents.craft.do/install-app.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://agents.craft.do/install-app.ps1 | iex
```

### Build da Sorgente

```bash
git clone https://github.com/lukilabs/craft-agents-oss.git
cd craft-agents-oss
bun install
bun run electron:start
```

**Prerequisiti**: [Bun](https://bun.sh/) runtime.

---

## Come avvio l'app per la prima volta?

Dopo l'installazione:

1. **Lancia l'app** dal tuo Application Launcher (macOS) / Start Menu (Windows)
2. Ti verrà chiesto di **scegliere un provider LLM** (vedi sotto)
3. Crea un **workspace** — dai un nome al tuo spazio di lavoro
4. Sei pronto! Il tuo workspace si apre con una chat vuota

**Tips:**
- Puoi creare più workspace per progetti diversi
- I workspace sono indipendenti: ognuno ha le proprie sources, skills e sessioni
- La configurazione vive in `~/.craft-agent/`

---

## Come scelgo un provider LLM?

Craft Agents supporta più modi di connettersi:

### Connessioni Dirette

| Provider | Auth | Modelli |
|----------|------|---------|
| **Anthropic** | API key o Claude Max/Pro OAuth | Claude (Sonnet, Opus, Haiku) |
| **Google AI Studio** | API key | Gemini (con Google Search grounding) |
| **ChatGPT Plus/Pro** | Codex OAuth | OpenAI Codex models |
| **GitHub Copilot** | OAuth (device code) | Modelli Copilot |

### Provider Third-Party

Tramite la connessione **Anthropic API Key** con endpoint custom:

| Provider | Endpoint | Note |
|----------|----------|------|
| **OpenRouter** | `https://openrouter.ai/api` | `anthropic/claude-opus-4.7`, `gpt-4o`, `gemini-2.0-flash`... |
| **Vercel AI Gateway** | `https://ai-gateway.vercel.sh` | Observability + caching built-in |
| **Ollama** | `http://localhost:11434` | Modelli open-source locali |
| **Custom** | Qualsiasi URL | Endpoint OpenAI-compatible o Anthropic-compatible |

**Tips:**
- Puoi cambiare provider in qualsiasi momento dalle impostazioni
- Il provider è per-workspace: workspace diversi possono usare provider diversi
- Per OpenRouter, usa il formato `provider/modello` (es. `anthropic/claude-sonnet-4-20250514`)

---

## Cos'è un workspace e come lo creo?

Un **workspace** è uno spazio di lavoro isolato con la propria configurazione:

- **Sources** connessi (MCP, API, filesystem)
- **Skills** custom
- **Automazioni** e scheduler
- **Sessioni** (cronologia chat)
- **Tema** personalizzato
- **Status workflow** personalizzabili

**Struttura su disco:**
```
~/.craft-agent/workspaces/{id}/
├── config.json           # Impostazioni workspace
├── theme.json            # Tema workspace (sovrascrive app)
├── automations.json      # Automazioni event-driven
├── sessions/             # Storico sessioni (JSONL)
├── sources/              # Sources connessi
├── skills/               # Skills custom
└── statuses/             # Stati personalizzati
```

**Per crearlo**: basta seguire le istruzioni dell'agente al primo avvio.

---

## Come faccio la prima domanda?

Una volta nel workspace, scrivi un messaggio nella chat come faresti con qualsiasi AI:

```
Cosa puoi fare?
```

**Esempi di prime domande:**
```
Quali sources sono disponibili nel mio workspace?
Aggiungi GitHub come source
Crea una skill che mi aiuti a scrivere commit message
```

**Tips:**
- Usa `@` per menzionare sources e skills nella chat
- Premi `Cmd+N` per una nuova chat
- Premi `Cmd+/` per vedere tutte le scorciatoie da tastiera
- Usa `Shift+Tab` per ciclare tra i permission modes

---

## Cosa significa "agent-native"?

"Agent-native" significa che **l'interfaccia è disegnata per essere usata da un agente AI**, non solo da umani. In pratica:

- **Non servi un editor di codice** per customizzare Craft Agents — basta chiedere
- **Tutto è istantaneo** — menzioni nuove skills/sources con `@` e funzionano subito, senza restart
- **Descrivi cosa vuoi**, l'agente capisce come farlo
- **Configurazione zero** — l'agente configura sources, OAuth, MCP server da solo

---

## Come connetto un servizio esterno?

Vedi la [Sources Guide](sources-guide.md) per la guida completa.

**Esempio rapido**: aggiungere GitHub
```
Aggiungi GitHub come source
```
L'agente troverà l'MCP server, guiderà nella configurazione e lo attiverà.

---

## Quali sono i comandi base della CLI?

Se usi la CLI (`craft-cli`), i comandi principali:

```bash
craft-cli ping                  # Verifica connessione
craft-cli workspaces            # Lista workspace
craft-cli sessions              # Lista sessioni
craft-cli send <id> <msg>       # Invia messaggio
craft-cli run "prompt"          # Esecuzione autonoma
```

Vedi [CLI docs](../docs/cli.md) per il riferimento completo.

---

**Prossimo passo**: [Sources Guide →](sources-guide.md)
