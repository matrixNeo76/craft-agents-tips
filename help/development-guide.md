<!-- v1.1.0 - last updated: 2026-05-01 -->

# Development Guide — Build, Dev Workflow, Contribuire

Guida per sviluppatori che vogliono buildare, contribuire o estendere Craft Agents OSS.

---

## Indice

- [Come si imposta l'ambiente di sviluppo?](#come-si-imposta-lambiente-di-sviluppo)
- [Come si builda l'app?](#come-si-builda-lapp)
- [Come funziona l'hot reload?](#come-funziona-lhot-reload)
- [Come eseguire il type checking?](#come-eseguire-il-type-checking)
- [Come contribuire al progetto?](#come-contribuire-al-progetto)
- [Quali sono le regole per i branch?](#quali-sono-le-regole-per-i-branch)
- [Troubleshooting sviluppo](#troubleshooting-sviluppo)

---

## Come si imposta l'ambiente di sviluppo?

**Prerequisiti:**
- [Bun](https://bun.sh/) runtime
- Node.js 18+ (per alcuni tool)
- macOS, Linux o Windows

**Setup:**
```bash
git clone https://github.com/lukilabs/craft-agents-oss.git
cd craft-agents-oss
bun install
cp .env.example .env   # Modifica .env con le tue credenziali
```

---

## Come si builda l'app?

### Build completa
```bash
bun run electron:build
```

Questo esegue in sequenza:
1. `electron:build:main` — bundle main process (esbuild)
2. `electron:build:preload` — bundle preload script (esbuild)
3. `electron:build:renderer` — bundle React app (Vite)
4. `electron:build:resources` — copia icone e risorse

### Build singoli componenti
```bash
bun run electron:build:main       # Solo main process
bun run electron:build:preload    # Solo preload
bun run electron:build:renderer   # Solo renderer
```

---

## Come funziona l'hot reload?

```bash
bun run electron:dev
```

Avvia l'app in modalità sviluppo con hot reload:
- Il renderer (React + Vite) si ricarica automaticamente a ogni modifica
- Il main process va ricostruito manualmente con `electron:build:main`
- I log sono visibili nel terminale dove hai lanciato `electron:dev`

**Prefix log chiave:**
- `[SessionManager]` — ciclo di vita sessione, auth
- `[IPC]` — comunicazione inter-processo

---

## Come eseguire il type checking?

```bash
# Su tutto il progetto
bun run typecheck:all

# Su un package specifico
cd packages/shared && bun run typecheck
```

Il typecheck controlla tutta la codebase TypeScript per errori di tipo.

---

## Come contribuire al progetto?

Vedi [CONTRIBUTING.md](https://github.com/lukilabs/craft-agents-oss/blob/main/CONTRIBUTING.md):

1. Fai un fork del repo
2. Crea un branch: `feature/nome-feature` o `fix/nome-fix`
3. Fai le modifiche
4. Assicurati che `typecheck:all` passi
5. Crea una Pull Request

---

## Quali sono le regole per i branch?

| Prefix | Uso | Esempio |
|--------|-----|---------|
| `feature/` | Nuove funzionalità | `feature/add-new-tool` |
| `fix/` | Bug fix | `fix/resolve-auth-issue` |
| `refactor/` | Refactoring | `refactor/simplify-agent-loop` |
| `docs/` | Documentazione | `docs/update-readme` |

---

## Troubleshooting sviluppo

| Problema | Causa | Soluzione |
|----------|-------|-----------|
| Typecheck fallisce | Errore di tipo TypeScript | `bun run typecheck:all` per vedere l'errore |
| Build fallisce | Moduli mancanti | `rm -rf node_modules bun.lock && bun install` |
| Hot reload non funziona | Main process non ricostruito | `bun run electron:build:main` |
| Errore su porta 9100 già in uso | Altra istanza in esecuzione | Kill o cambia `CRAFT_RPC_PORT` |

---

**Vedi anche**: [Architecture Overview](architecture-overview.md) | [CLI Guide](cli-guide.md) | [Contributing Guide](../CONTRIBUTING.md)
