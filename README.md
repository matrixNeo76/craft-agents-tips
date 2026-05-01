# Craft Agents Tips

Sistema di help, tips & tricks per [Craft Agents OSS](https://github.com/lukilabs/craft-agents-oss).

Risponde a domande frequenti su installazione, configurazione, sources, skills, automazioni, troubleshooting e architettura.

## Guide

| Guida | Descrizione |
|-------|-------------|
| [Quickstart](help/quickstart.md) | Installazione, provider LLM, primo workspace |
| [Sources Guide](help/sources-guide.md) | MCP server, API REST, Google OAuth, filesystem locale |
| [Skills Guide](help/skills-guide.md) | Creare e gestire skills |
| [Automations Guide](help/automations.md) | Scheduler, eventi, governance |
| [Tips & Tricks](help/tips-and-tricks.md) | Scorciatoie, produttività, debug |
| [Troubleshooting](help/troubleshooting.md) | Errori comuni e soluzioni |
| [Architecture Overview](help/architecture-overview.md) | Struttura interna di Craft Agents |

## Installazione in Craft Agents

1. Aggiungi questo repo come **Source** in Craft Agents (GitHub o Local Folder)
2. Copia la skill `.agents/skills/craft-agents-help/SKILL.md` nel tuo workspace:
   ```
   ~/.craft-agent/workspaces/{tuo-workspace}/skills/craft-agents-help/SKILL.md
   ```
3. L'agente consulterà automaticamente le guide quando chiedi aiuto

## Metriche

- **103** domande coperte
- **69** esempi con codice
- **8** guide cross-linkate
