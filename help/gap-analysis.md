# Audit: Gap Analysis & Improvement Plan per le Guide Help

## Stato Attuale (baseline)

| Guida | Righe | Sezioni | Domande | Esempi | Priorità attuale |
|-------|-------|---------|---------|--------|-----------------|
| quickstart | 185 | 9 | 8 | 8 | Media |
| sources-guide | 263 | 13 | 16 | 9 | Alta |
| skills-guide | 164 | 9 | 12 | 9 | Bassa |
| automations | 256 | 9 | 12 | 11 | Media |
| tips-and-tricks | 320 | 19 | 22 | 6 | Media |
| troubleshooting | 383 | 18 | 20 | 20 | Alta |
| architecture-overview | 311 | 10 | 13 | 7 | Bassa |

---

## Gap Analysis

### Gap 1 — Argomenti COMPLETAMENTE ASSENTI

| Argomento Mancante | Perché serve | Dove metterlo |
|---|---|---|
| **CLI Reference** | Il README upstream dedica 100+ righe alla CLI. Noi abbiamo zero. Serve per scripting e CI/CD | Nuovo file: `help/cli-guide.md` |
| **Server Setup Guide** | Docker, TLS, reverse proxy, env vars per server remoto. È una delle feature più complesse | Nuovo file: `help/server-setup.md` |
| **Security & Best Practices** | Credential management, MCP env isolation, permission modes deep-dive. Tema trasversale citato solo in parte | Nuovo file: `help/security-guide.md` |
| **Provider LLM Deep-Dive** | Anche se menzionati in quickstart, mancano dettagli operativi (es. "come ottenere API key", "come settare OpenRouter") | Ampliare `help/quickstart.md` con sezione dedicata |
| **Development & Contributing** | Come buildare da source, dev workflow, hot reload, typecheck. Utile per chi vuole contribuire | Nuovo file: `help/development-guide.md` |
| **Labels System** | Hierarchical labels, auto-apply rules, regex patterns | Nuovo file: `help/labels-guide.md` |
| **Session Management** | Organizzare sessioni, archivio, search, flag workflow. È una feature desktop chiave | Nuovo file: `help/sessions-guide.md` |

### Gap 2 — Guide Esistenti da AMPLIARE SIGNIFICATIVAMENTE

| Guida | Cosa manca | Impatto |
|---|---|---|
| **sources-guide.md** | Microsoft OAuth (Outlook, Teams), Slack OAuth, environment variables per provider, gestire più sources, rimuovere/disable sources | Alto — è la guida più consultata |
| **automations.md** | Solo 4 eventi su 12+ descritti in dettaglio. Mancano: SessionEnd, FlagChange, PostToolUse, PermissionModeChange. Error handling, monitoring | Alto — automazioni sono complesse |
| **troubleshooting.md** | Manca: CLI-specific errors (PROTOCOL_VERSION_UNSUPPORTED, AUTH_FAILED, Connection timeout), Docker issues, dev environment, proxy/network config | Alto — troubleshooting deve coprire tutto |
| **tips-and-tricks.md** | Manca: Large Response Handling (60KB summarization), Docker usage, development workflow, performance optimization, integration patterns | Medio — sono "tips", ogni nuovo tip è valore |

### Gap 3 — Guide Esistenti da MIGLIORARE (aggiustamenti minori)

| Guida | Cosa aggiungere |
|---|---|
| **quickstart.md** | Video link, Docker setup, "things that just work" philosophy, esempio di prima automazione |
| **skills-guide.md** | Frontmatter fields spiegati nel dettaglio, condividere skill tra workspace, testare una skill |
| **architecture-overview.md** | Credential encryption deep-dive, doc-links.ts details, estensioni points |
| **help/README.md** | Aggiornare indice con nuovi file |

---

## Piano di Esecuzione — 4 Micro-Fasi

### MF-A: Nuove Guide Prioritarie (3 nuovi file)

| File | Contenuto | Dipende da |
|---|---|---|
| `help/cli-guide.md` | Tutti i comandi CLI, flag, esempi scripting, piping, TLS, validate-server | Nessuna |
| `help/server-setup.md` | Docker, TLS, env vars, reverse proxy, Dockerfile.server, troubleshooting server | Nessuna |
| `help/security-guide.md` | Credential encryption, MCP env filtering, permission modes, best practices | Nessuna |

### MF-B: Ampliamento Guide Esistenti

| File | Cosa aggiungere |
|---|---|
| `help/sources-guide.md` | +Microsoft OAuth, +Slack OAuth, +gestione multi-source, +remove/disable |
| `help/automations.md` | +tutti gli eventi (da 4 a 12+), +error handling, +monitoring, +pattern avanzati |
| `help/troubleshooting.md` | +CLI errors, +Docker, +dev env, +proxy, +aggiornamenti/codici specifici |
| `help/tips-and-tricks.md` | +Large Response Handling, +Docker, +development workflow, +performance |

### MF-C: Guide Secondarie (3 nuovi file a priorità media)

| File | Contenuto |
|---|---|
| `help/development-guide.md` | Build, dev workflow, hot reload, typecheck, contribute |
| `help/labels-guide.md` | Labels system, auto-apply, regex, gerarchie |
| `help/sessions-guide.md` | Session management, flag, archive, search |

### MF-D: Ritocchi Finali

| Cosa fare |
|---|
| Aggiornare `help/README.md` indice con nuovi file |
| Aggiornare `llms.txt` con nuovi file |
| Aggiornare `scripts/search-help.sh` se necessario |
| Aggiornare `CHANGELOG.md` |
| Aggiornare la skill `craft-agents-help` con nuovi mapping argomento → file |
| Commit e push finale |

---

## Stima Impatto

| Fase | Nuove righe stimate | Nuove domande | Nuovi esempi |
|------|--------------------|--------------|-------------|
| MF-A: 3 nuove guide | ~500-700 | ~30-40 | ~15-20 |
| MF-B: ampliamenti | ~400-600 | ~25-35 | ~15-20 |
| MF-C: 3 guide secondarie | ~300-500 | ~15-25 | ~10-15 |
| MF-D: ritocchi | ~100-200 | ~5-10 | ~5 |
| **Totale** | **~1300-2000** | **~75-110** | **~45-60** |

Obiettivo finale: **~180-210 domande totali**, **~115-130 esempi totali**, **14-17 file**.
