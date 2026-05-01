# Craft Agents Tips — Guida all'Uso

Guide, tips e troubleshooting per Craft Agents OSS.

## Directory Guida

- `help/quickstart.md` — Installazione, provider LLM, primo workspace
- `help/sources-guide.md` — Connettere MCP server, API REST, Google OAuth, filesystem locale
- `help/skills-guide.md` — Creare e gestire skills custom
- `help/automations.md` — Automazioni event-driven: scheduler, label, governance
- `help/tips-and-tricks.md` — Scorciatoie, produttività, debug, trucchi avanzati
- `help/troubleshooting.md` — Problemi comuni: SDK path, OAuth, MCP, WebSocket
- `help/architecture-overview.md` — Struttura monorepo, session loop, RPC, crittografia
- `help/README.md` — Indice generale e mappa concettuale

## Come Integrare in Craft Agents

1. Aggiungi questo repo come **Source** di tipo Local Folder
2. Installa la skill `.agents/skills/craft-agents-help/SKILL.md` nel workspace
3. L'agente consulterà automaticamente le guide quando l'utente chiede aiuto

## Raccomandazioni per l'Agente

- Quando un utente chiede "come si fa X in Craft Agents", consulta `help/{argomento}.md`
- Usa l'indice all'inizio di ogni file per trovare rapidamente la sezione
- Rispondi con la sezione pertinente, non l'intero file
- Se la domanda è generica, suggerisci l'indice in `help/README.md`
