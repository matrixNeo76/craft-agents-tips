# 💡 Craft Agents Tips

> **Guide pratiche, tips & troubleshooting per [Craft Agents OSS](https://github.com/lukilabs/craft-agents-oss).**
> 103 domande coperte, 69 esempi con codice, diagrammi e search integrata.

---

## Cos'è

Craft Agents Tips è un sistema di help contestuale per Craft Agents OSS. Invece di cercare su Google o sfogliare manuali, **l'agente stesso consulta queste guide** quando gli chiedi come si fa qualcosa.

### Cosa copre

| Guida | Cosa trovi |
|-------|------------|
| 🚀 [Quickstart](help/quickstart.md) | Installazione one-line, provider LLM, primo workspace, prima chat |
| 🔌 [Sources Guide](help/sources-guide.md) | MCP server (pubblico/locale), API REST (Gmail, Slack), Google OAuth, filesystem locale (Obsidian, git) |
| 🛠️ [Skills Guide](help/skills-guide.md) | Creare skill custom, @mention, import da Claude Code, best practices |
| ⏰ [Automations Guide](help/automations.md) | Scheduler cron, eventi (LabelAdd, SessionStart), governance PreToolUse, esempi JSON |
| ⚡ [Tips & Tricks](help/tips-and-tricks.md) | Keyboard shortcuts, permission modes, deep linking, debug, theme system |
| 🩺 [Troubleshooting](help/troubleshooting.md) | 16 problemi risolti: SDK path, OAuth, MCP, WebSocket, AgentEvent type mismatches |
| 🏗️ [Architecture Overview](help/architecture-overview.md) | Monorepo, session loop, Pi SDK vs Claude SDK, RPC, crittografia AES-256-GCM |
| 📋 [Indice](help/README.md) | Mappa concettuale completa |

---

## Come Integrare in Craft Agents

### Opzione 1: Source + Skill (raccomandata)

1. **Aggiungi il Source** — basta chiedere all'agente:
   ```
   Aggiungi ~/repos/craft-agents-tips come source locale
   ```

2. **Installa la Skill** — copia in:
   ```
   ~/.craft-agent/workspaces/{tuo-workspace}/skills/craft-agents-help/SKILL.md
   ```

3. **Fatto!** Quando chiedi _"Come si configura una automazione scheduled?"_ l'agente apre `help/automations.md` e ti risponde.

### Opzione 2: Solo lettura

Leggi direttamente i file nella directory `help/`. Ogni guida ha un indice all'inizio con link rapidi alle sezioni.

### Opzione 3: Query via CLI

```bash
./scripts/search-help.sh "errore OAuth"     # Cerca nelle guide
./scripts/search-help.sh --list              # Elenca tutte le guide
```

---

## Funzionalità

- ✅ **103 domande frequenti** — copertura completa
- ✅ **69 esempi con codice** — JSON, bash, TypeScript pronti all'uso
- ✅ **5 diagrammi Mermaid** — visuali (monorepo, session loop, OAuth flow, thin-client, event flow)
- ✅ **llms.txt** — discoverabile da qualsiasi LLM/agente AI
- ✅ **Search script** — `scripts/search-help.sh` per ricerca full-text
- ✅ **Skill integrata** — trigger su 80+ pattern linguistici
- ✅ **guide.md** — istruzioni per l'agente su come usare il Source
- ✅ **Cross-link** — ogni guida linka ad almeno 2 altre guide
- ✅ **Versionato** — version header in ogni file + CHANGELOG

---

## Stats

| Metrica | Valore |
|---------|--------|
| Guide | 8 |
| Domande | 103 |
| Esempi con codice | 69 |
| Diagrammi Mermaid | 5 |
| Trigger skill | 80+ |
| Problemi risolti | 16 |

---

## Changelog

Vedi [CHANGELOG.md](CHANGELOG.md) per la cronologia completa delle versioni.

---

## Licenza

Apache 2.0 — vedi [LICENSE](LICENSE) per i dettagli.
