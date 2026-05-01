<!-- v1.1.0 - last updated: 2026-05-01 -->

# Craft Agents OSS — Sistema di Help

Benvenuto nel sistema di help contestuale per **Craft Agents OSS**. Questo sistema risponde alle domande frequenti su come installare, configurare, estendere e risolvere problemi con Craft Agents.

## Indice delle Guide

| Guida | Descrizione |
|-------|-------------|
| 🚀 [Quickstart](quickstart.md) | Primi passi: installazione, provider LLM, primo workspace, prima sessione |
| 🔌 [Sources Guide](sources-guide.md) | MCP server, API REST, Google/Microsoft/Slack OAuth, filesystem locali |
| 🛠️ [Skills Guide](skills-guide.md) | Creare, importare e gestire skills per estendere l'agente |
| ⏰ [Automations Guide](automations.md) | Automazioni, 12+ eventi, scheduler, governance, error handling |
| ⚡ [Tips & Tricks](tips-and-tricks.md) | Scorciatoie, produttività, trucchi avanzati, Docker, performance |
| 🩺 [Troubleshooting](troubleshooting.md) | Problemi comuni, errori, soluzioni (CLI, Docker, dev) |
| 🏗️ [Architecture Overview](architecture-overview.md) | Come funziona Craft Agents dentro, diagrammi |
| 💻 [CLI Guide](cli-guide.md) | Riferimento completo craft-cli per scripting e CI/CD |
| 🖥️ [Server Setup](server-setup.md) | Docker, TLS, reverse proxy, produzione |
| 🔒 [Security Guide](security-guide.md) | Credenziali, permessi, MCP env isolation |
| 🏷️ [Labels Guide](labels-guide.md) | Etichette, colori, auto-apply, gerarchie |
| 📂 [Sessions Guide](sessions-guide.md) | Organizzare inbox, flags, archivio, ricerca |
| ❓ [FAQ](faq.md) | Domande frequenti rapide |
| 🛠️ [Development Guide](development-guide.md) | Build, dev workflow, contribuire |

## Mappa Concettuale

```
┌─────────────────────────────────────────────────┐
│                  CRAFT AGENTS                     │
├─────────────────────────────────────────────────┤
│                                                   │
│   ┌───────────┐     ┌──────────┐                  │
│   │ INSTALLAZIONE│───→│ WORKSPACE │                  │
│   └───────────┘     └────┬─────┘                  │
│                          │                         │
│            ┌─────────────┼─────────────┐           │
│            ▼             ▼             ▼           │
│   ┌─────────────┐ ┌──────────┐ ┌──────────┐      │
│   │   PROVIDER   │ │  SOURCES │ │  SKILLS  │      │
│   │   LLM       │ │ (MCP/API)│ │custom    │      │
│   └─────────────┘ └──────────┘ └──────────┘      │
│                                                   │
│            ┌─────────────┬─────────────┐           │
│            ▼             ▼             ▼           │
│   ┌─────────────┐ ┌──────────┐ ┌──────────┐      │
│   │  SESSIONI    │ │AUTOMAZIONI│ │ THEMES   │      │
│   └─────────────┘ └──────────┘ └──────────┘      │
│                                                   │
└─────────────────────────────────────────────────┘
```

## Come Usare Questo Sistema

1. **Nuovo utente?** Inizia da [Quickstart](quickstart.md)
2. **Vuoi connettere un servizio?** Vai a [Sources Guide](sources-guide.md)
3. **Cerchi un trucco?** Vai a [Tips & Tricks](tips-and-tricks.md)
4. **Hai un errore?** Vai a [Troubleshooting](troubleshooting.md)
5. **Vuoi capire l'architettura?** Vai a [Architecture Overview](architecture-overview.md)
6. **Usi la CLI?** Vai a [CLI Guide](cli-guide.md)
7. **Setup server/Docker?** Vai a [Server Setup](server-setup.md)
8. **Label o auto-apply?** Vai a [Labels Guide](labels-guide.md)
9. **Organizzare sessioni?** Vai a [Sessions Guide](sessions-guide.md)
10. **Sviluppo/contribuire?** Vai a [Development Guide](development-guide.md)
