---
name: craft-agents-help
description: Sistema di help contestuale per Craft Agents OSS. Fornisce risposte a domande frequenti su installazione, configurazione, sources, skills, automazioni, troubleshooting e architettura. Attiva quando l'utente chiede "help", "aiuto", "come si fa", "guida", "documentazione", "tips", o "troubleshooting" su Craft Agents.
---

# Craft Agents OSS — Help Skill

Quando l'utente chiede aiuto su Craft Agents OSS, consulta la guida appropriata dalla directory `help/` nella root del repository.

## Guide Disponibili

| Argomento | File |
|-----------|------|
| Guida rapida iniziale | `help/quickstart.md` |
| Sources (MCP, API, filesystem) | `help/sources-guide.md` |
| Skills | `help/skills-guide.md` |
| Automazioni | `help/automations.md` |
| Tips & Tricks | `help/tips-and-tricks.md` |
| Troubleshooting | `help/troubleshooting.md` |
| Architettura | `help/architecture-overview.md` |

## Come Rispondere

1. **Identifica il topic** dalla richiesta dell'utente
2. **Leggi il file** `help/{topic}.md` corrispondente
3. **Rispondi** con la sezione pertinente, citando la fonte
4. Se la domanda è generica, suggerisci l'indice di `help/README.md`

## Esempi di Mapping Domanda → File

| Domanda | File | Sezione |
|---------|------|---------|
| "Come installo Craft Agents?" | quickstart.md | Come installo Craft Agents? |
| "Come collego Gmail?" | sources-guide.md | Come configuro Google OAuth? |
| "Crea una skill" | skills-guide.md | Come creo una skill? |
| "Ogni giorno alle 9" | automations.md | Come configuro un promemoria giornaliero? |
| "Shortcut da tastiera" | tips-and-tricks.md | Keyboard Shortcuts Complete |
| "Errore API key" | troubleshooting.md | API Key non riconosciuta |
| "Com'è fatto dentro?" | architecture-overview.md | Com'è strutturato il monorepo |
