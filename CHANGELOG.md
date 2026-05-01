# Changelog

## [1.1.0] — 2026-05-01

### Added
- MF-1: `guide.md` per il Source `craft-agents-tips` (istruzioni per l'agente)
- MF-1: `source-guide.md` nella root del repo per utenti esterni
- MF-2: Diagrammi Mermaid in 3 guide (architecture, automations, OAuth flow)
- MF-3: `llms.txt` per AI discovery del contenuto del repo
- MF-4: Skill `craft-agents-help` migliorata con trigger words estesi e suggerimenti proattivi
- MF-6: `scripts/search-help.sh` per ricerca full-text nelle guide
- MF-7: Questo `CHANGELOG.md` + version headers nei file

### Changed
- Skill workspace (auresys-backend): trigger words da ~30 a ~80+
- Skill repository: allineata alla versione workspace
- `architecture-overview.md`: sostituiti ASCII diagram con Mermaid
- `automations.md`: aggiunto diagramma flusso eventi
- `sources-guide.md`: aggiunto diagramma flusso OAuth

## [1.0.0] — 2026-05-01

### Added
- 8 guide markdown nella directory `help/`
- 103 domande coperte
- 69 esempi con codice
- Source `craft-agents-tips` nel workspace
- Skill `craft-agents-help` iniziale
- Cross-link tra tutte le guide (≥2 per file)

### Guide
- `help/README.md` — Indice e mappa concettuale
- `help/quickstart.md` — Installazione, provider LLM, primo workspace
- `help/sources-guide.md` — MCP, API REST, OAuth, filesystem
- `help/skills-guide.md` — Creazione e gestione skill
- `help/automations.md` — Eventi, scheduler, governance
- `help/tips-and-tricks.md` — Scorciatoie, produttività, debug
- `help/troubleshooting.md` — Errori comuni e soluzioni
- `help/architecture-overview.md` — Architettura interna
