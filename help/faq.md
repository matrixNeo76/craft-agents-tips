<!-- v1.2.0 - last updated: 2026-05-01 -->

# FAQ — Domande Frequenti

Risposte rapide alle domande più comuni su Craft Agents OSS.

---

## Indice

- [Come installo Craft Agents?](#come-installo-craft-agents)
- [Come cambio provider LLM?](#come-cambio-provider-llm)
- [Come collego Gmail?](#come-collego-gmail)
- [Come collego GitHub?](#come-collego-github)
- [Come creo una skill?](#come-creo-una-skill)
- [Come imposto un reminder giornaliero?](#come-imposto-un-reminder-giornaliero)
- [Dove sono salvati i miei dati?](#dove-sono-salvati-i-miei-dati)
- [Le sessioni persistono tra riavvii?](#le-sessioni-persistono-tra-riavvii)
- [Come cambio permission mode?](#come-cambio-permission-mode)
- [Cos'è un workspace?](#cosè-un-workspace)
- [Come faccio backup dei miei dati?](#come-faccio-backup-dei-miei-dati)
- [Come debuggo un errore?](#come-debuggo-un-errore)
- [Come contribuisco al progetto?](#come-contribuisco-al-progetto)
- [Dove trovo i log?](#dove-trovo-i-log)

---

## Come installo Craft Agents?

**One-line (raccomandato):**

```bash
# macOS / Linux
curl -fsSL https://agents.craft.do/install-app.sh | bash

# Windows (PowerShell)
irm https://agents.craft.do/install-app.ps1 | iex
```

**Da sorgente:** vedi [Quickstart](quickstart.md#come-installo-craft-agents)

---

## Come cambio provider LLM?

Vai nelle **impostazioni del workspace** e seleziona un altro provider. Puoi usare:

- **Anthropic**: API key o Claude Max/Pro OAuth
- **Google AI Studio**: API key (Gemini con Google Search)
- **ChatGPT Plus/Pro**: Codex OAuth
- **GitHub Copilot**: OAuth device code
- **OpenRouter**: via Anthropic API key con base URL custom

*Il provider è per-workspace: workspace diversi possono usare provider diversi.*

---

## Come collego Gmail?

```
Collega la mia Gmail
```

L'agente ti guida nella creazione di un Google Cloud Project e nel flusso OAuth.

**Alternativa:** prepara Client ID e Client Secret da [Google Cloud Console](https://console.cloud.google.com) e l'agente li configurerà. Vedi [Sources Guide](sources-guide.md#come-configuro-google-oauth).

---

## Come collego GitHub?

```
Aggiungi GitHub come source
```

L'agente trova l'MCP server pubblico di GitHub e configura l'accesso.

**Se hai già un token:** digli `Configura GitHub con il mio token GITHUB_TOKEN` e te lo chiederà.

---

## Come creo una skill?

```
Crea una skill che mi aiuti a scrivere messaggi di commit conventional
```

L'agente genera la struttura `SKILL.md` con nome, descrizione e istruzioni. Poi la usi con `@nome-skill`.

Vedi [Skills Guide](skills-guide.md) per dettagli e best practices.

---

## Come imposto un reminder giornaliero?

```
Configura un briefing giornaliero ogni giorno feriale alle 9:00
```

L'agente configura un'automazione `SchedulerTick` nel tuo workspace. Vedi [Automations Guide](automations.md#come-configuro-un-promemoria-giornaliero).

---

## Dove sono salvati i miei dati?

Tutto in `~/.craft-agent/`:

| Cosa | Dove |
|------|------|
| Configurazione | `~/.craft-agent/config.json` |
| Credenziali (cifrate) | `~/.craft-agent/credentials.enc` |
| Sessioni | `~/.craft-agent/workspaces/{id}/sessions/*.jsonl` |
| Sources | `~/.craft-agent/workspaces/{id}/sources/` |
| Skills | `~/.craft-agent/workspaces/{id}/skills/` |
| Automazioni | `~/.craft-agent/workspaces/{id}/automations.json` |
| Tema | `~/.craft-agent/theme.json` |

---

## Le sessioni persistono tra riavvii?

**Sì.** Chiudi l'app, riapri dopo ore o giorni — tutte le sessioni sono lì. Salvate in formato JSONL, append-only, safe da crash.

---

## Come cambio permission mode?

Usa `Shift+Tab` durante la conversazione per ciclare tra:

1. 🛡️ **Explore** — sola lettura
2. ❓ **Ask to Edit** — chiede approvazione (default)
3. ⚡ **Auto** — auto-approva

Vedi [Security Guide](security-guide.md#come-funzionano-i-permission-modes).

---

## Cos'è un workspace?

Uno spazio di lavoro isolato con le proprie sources, skills, sessioni e automazioni. Puoi averne quanti vuoi. Utile per separare lavoro e progetti personali.

Vedi [Quickstart](quickstart.md#cosè-un-workspace-e-come-lo-creo).

---

## Come faccio backup dei miei dati?

**Backup completo:**
```bash
cp -r ~/.craft-agent ~/.craft-agent.backup-$(date +%Y%m%d)
```

**Ripristino:**
```bash
# Ferma Craft Agents
cp -r ~/.craft-agent.backup-YYYYMMDD ~/.craft-agent
# Riavvia l'app
```

**Cosa include il backup:**
- Tutte le sessioni (conversazioni complete)
- Credenziali cifrate
- Configurazione workspace
- Sources, skills, automazioni

---

## Come debuggo un errore?

1. **Leggi il messaggio di errore** — spesso è auto-esplicativo
2. **Consulta [Troubleshooting](troubleshooting.md)** — copre 20+ errori
3. **Avvia in debug mode:**
   ```bash
   # macOS
   /Applications/Craft\ Agents.app/Contents/MacOS/Craft\ Agents -- --debug
   # Windows
   & "$env:LOCALAPPDATA\Programs\@craft-agentelectron\Craft Agents.exe" -- --debug
   ```
4. **Controlla i log** (vedi sotto)

---

## Come contribuisco al progetto?

1. Fork del repo su [github.com/lukilabs/craft-agents-oss](https://github.com/lukilabs/craft-agents-oss)
2. Crea branch: `feature/nome` o `fix/nome`
3. Fai modifiche e apri Pull Request

Vedi [Development Guide](development-guide.md) e [CONTRIBUTING.md](https://github.com/lukilabs/craft-agents-oss/blob/main/CONTRIBUTING.md).

---

## Dove trovo i log?

| OS | Path |
|----|------|
| macOS | `~/Library/Logs/@craft-agent/electron/main.log` |
| Windows | `%APPDATA%\@craft-agent\electron\logs\main.log` |
| Linux | `~/.config/@craft-agent/electron/logs/main.log` |

Cerca con `grep 'ERROR' main.log` per errori, o `tail -f main.log` per log in tempo reale.

---

**Non trovi quello che cerchi?** Prova [Tips & Tricks](tips-and-tricks.md) | [Troubleshooting](troubleshooting.md) | [Indice completo](README.md)
