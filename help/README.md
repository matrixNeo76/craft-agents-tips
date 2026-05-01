<!-- v1.1.0 - last updated: 2026-05-01 -->

# Craft Agents OSS — Sistema di Help

Benvenuto nel sistema di help contestuale per **Craft Agents OSS**. Questo sistema risponde alle domande frequenti su come installare, configurare, estendere e risolvere problemi con Craft Agents.

## Indice delle Guide

| Guida | Descrizione |
|-------|-------------|
| [Quickstart](quickstart.md) | Primi passi: installazione, provider LLM, primo workspace, prima sessione |
| [Sources Guide](sources-guide.md) | Connettere MCP server, API REST, filesystem locali |
| [Skills Guide](skills-guide.md) | Creare, importare e gestire skills per estendere l'agente |
| [Automations Guide](automations.md) | Automazioni, scheduler, event-driven workflow |
| [Tips & Tricks](tips-and-tricks.md) | Scorciatoie, produttività, trucchi avanzati |
| [Troubleshooting](troubleshooting.md) | Problemi comuni, errori, soluzioni |
| [Architecture Overview](architecture-overview.md) | Come funziona Craft Agents dentro |

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
