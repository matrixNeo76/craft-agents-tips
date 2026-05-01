---
name: craft-agents-help
description: >
  Guida su come usare Craft Agents OSS. Attivami quando l'utente chiede come
  si fa qualcosa con Craft Agents OSS, come si configura, o ha dubbi su
  installazione, sources, MCP, skills, automazioni, permessi, temi, CLI,
  server remoto, troubleshooting, o architettura.
  Trigger: "craft agents", "craft agents oss", "help", "aiuto", "come si fa",
  "come si usa", "come configuro", "guida", "tutorial", "non funziona",
  "errore", "troubleshooting", "tips", "trucchi", "scorciatoia",
  "installazione", "source", "mcp", "skill", "automazione", "scheduler",
  "oauth", "workspace", "provider llm", "cli", "server remoto", "thin-client",
  "architettura", "monorepo", "tip", "trick", "come collego", "come connetto",
  "perché non", "non capisco", "spiegami", "dimmi di più", "cos'è",
  "che cos'è", "cosa fa", "vorrei sapere", "dov'è", "dove si trova",
  "non riesco", "fallisce", "non parte", "non si avvia", "si blocca",
  "lento", "rallenta", "permesso", "autorizzazione", "token", "api key",
  "chiave", "segreto", "config", "configurazione", "impostazione",
  "personalizzare", "cambiare", "modificare", "aggiungere", "rimuovere",
  "eliminare", "installare", "aggiornare", "build", "compilare",
  "deploy", "distribuire", "pubblicare", "condividere", "esportare",
  "backup", "salvare", "recuperare", "ripristinare", "migrare",
  "docker", "tls", "wss", "reverse proxy", "label", "etichetta",
  "flag", "sessione", "inbox", "archivio"
alwaysRun: false
---

# Craft Agents OSS — Help System

Guide in `help/` directory. Source: `@craft-agents-tips`.

## Comportamento
1. Identifica il topic dalla richiesta
2. Leggi solo la sezione pertinente del file
3. Rispondi in modo conciso
4. Suggerisci guide correlate quando pertinente

## Mapping Argomento → File

| Argomento | File |
|-----------|------|
| Installazione, provider LLM, workspace | `help/quickstart.md` |
| MCP, API REST, OAuth, filesystem | `help/sources-guide.md` |
| Skill, @mention, best practices | `help/skills-guide.md` |
| Automazioni, scheduler, governance | `help/automations.md` |
| Shortcut, produttività, debug | `help/tips-and-tricks.md` |
| Errori e soluzioni | `help/troubleshooting.md` |
| Architettura, diagrammi | `help/architecture-overview.md` |
| CLI, scripting, CI/CD | `help/cli-guide.md` |
| Server, Docker, TLS | `help/server-setup.md` |
| Sicurezza, permessi | `help/security-guide.md` |
| Label, colori, auto-apply | `help/labels-guide.md` |
| Sessioni, inbox, flags | `help/sessions-guide.md` |
| Build, dev, contribuire | `help/development-guide.md` |
| Panoramica | `help/README.md` |

## Suggerimenti Proattivi

| Se emerge... | Suggerisci... |
|---|---|
| Configurazione MCP/API | sources-guide.md |
| Creazione skill | skills-guide.md |
| Automazioni/reminder | automations.md |
| Errori OAuth/connessione | troubleshooting.md |
| Architettura/codice | architecture-overview.md |
| Shortcut | tips-and-tricks.md |
| Docker/TLS/server | server-setup.md |
| CLI/scripting | cli-guide.md |
| Label/auto-apply | labels-guide.md |
