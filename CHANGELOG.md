# Changelog

## [2.0.0] — 2026-05-01

### Added
- MF-A: 3 nuove guide prioritarie
  - `cli-guide.md` — Riferimento completo craft-cli (comandi, scripting, TLS, validate-server)
  - `server-setup.md` — Docker, TLS, reverse proxy, produzione
  - `security-guide.md` — Credenziali, permission modes, MCP env isolation
- MF-B: Ampliamento guide esistenti
  - `sources-guide.md`: Microsoft OAuth, Slack OAuth, multi-source, remove/disable
  - `automations.md`: da 4 a 12+ eventi, error handling, monitoring, pattern avanzati
  - `troubleshooting.md`: CLI errors (timeout, AUTH_FAILED, PROTOCOL_VERSION), Docker, proxy
  - `tips-and-tricks.md`: Large Response Handling, Docker, compressione 60KB
- MF-C: 3 guide secondarie
  - `development-guide.md` — Build, hot reload, typecheck, contribuire
  - `sessions-guide.md` — Organizzare inbox, flags, archivio, ricerca
  - `labels-guide.md` — Etichette, colori, auto-apply con regex, gerarchie

### Changed
- `help/README.md`: aggiornato indice con 14 guide
- `README.md`: stats aggiornate
- Skill workspace e repository: nuovi mapping per le guide aggiunte
- `llms.txt`: aggiornato con tutte le nuove guide

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
