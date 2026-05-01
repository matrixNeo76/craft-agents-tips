<!-- v1.0.0 - last updated: 2026-05-01 -->

# Tips & Tricks — Scorciatoie, Produttività, "Did You Know"

Raccolta di consigli pratici per usare Craft Agents al massimo.

---

## Indice

### Keyboard & UI
- [Keyboard Shortcuts Complete](#keyboard-shortcuts-complete)
- [Permission Modes: come e quando usarli](#permission-modes-come-e-quando-usarli)
- [Deep Linking: craftagents://](#deep-linking-craftagents)
- [SHIFT+TAB: ciclo rapido permessi](#shifttab-ciclo-rapido-permessi)

### Sessioni & Chat
- [Come cambiare provider LLM a metà sessione](#come-cambiare-provider-llm-a-metà-sessione)
- [File Attachments: cosa puoi allegare](#file-attachments-cosa-puoi-allegare)
- [Multi-File Diff: visualizzare cambiamenti](#multi-file-diff-visualizzare-cambiamenti)
- [Background Tasks: operazioni lunghe](#background-tasks-operazioni-lunghe)
- [Session Flags e Status Workflow](#session-flags-e-status-workflow)

### Configurazione
- [Theme System: ereditarietà app → workspace → agente](#theme-system-ereditarietà-app--workspace--agente)
- [Session Persistence: dove vengono salvate le chat](#session-persistence-dove-vengono-salvate-le-chat)
- [Compressione risposte grandi >60KB](#compressione-risposte-grandi-60kb)
- [Multi-Provider: workspace diversi, provider diversi](#multi-provider-workspace-diversi-provider-diversi)

### Debug
- [Debug Mode: log avanzati](#debug-mode-log-avanzati)
- [Log paths per OS](#log-paths-per-os)

### Avanzati
- [Everything is Instant: no restart needed](#everything-is-instant-no-restart-needed)
- [Agent-Native Philosophy](#agent-native-philosophy)
- [Craft MCP Integration: 32+ tools](#craft-mcp-integration-32-tools)

---

## Keyboard Shortcuts Complete

| Shortcut | Azione |
|----------|--------|
| `Cmd+N` | Nuova chat |
| `Cmd+1` | Focus sidebar (sessione in alto) |
| `Cmd+2` | Focus lista sessioni |
| `Cmd+3` | Focus chat |
| `Cmd+/` | Dialogo scorciatoie da tastiera |
| `Shift+Tab` | Cicla permission modes |
| `Enter` | Invia messaggio |
| `Shift+Enter` | Nuova linea (senza inviare) |

---

## Permission Modes: come e quando usarli

| Mode | Icona | Comportamento |
|------|-------|---------------|
| `safe` (Explore) | 🛡️ | Sola lettura, blocca tutte le scritture |
| `ask` (Ask to Edit) | ❓ | Chiede approvazione prima di ogni azione (default) |
| `allow-all` (Auto) | ⚡ | Auto-approva tutti i comandi |

**Quando usare cosa:**
- **Explore**: navigazione, lettura file, ricerca — nessun rischio
- **Ask to Edit**: sviluppo normale — vuoi vedere cosa fa l'agente
- **Auto**: task ripetitivi, automazioni fidate, operazioni bulk — velocità massima

**Tips:**
- `Shift+Tab` per ciclare rapidamente durante la sessione
- Le automazioni possono avere un permission mode diverso dalla sessione
- Il mode è visibile nell'header della chat

---

## Deep Linking: craftagents://

Puoi navigare a schermate specifiche usando URL:

```
craftagents://settings                         → Impostazioni
craftagents://allSessions                       → Tutte le sessioni
craftagents://allSessions/session/session123    → Sessione specifica
craftagents://sources/source/github             → Info source
craftagents://action/new-chat                   → Nuova chat
craftagents://workspace/{id}/allSessions/session/abc123
```

Integrabile in script, automazioni, o condiviso.

---

## SHIFT+TAB: ciclo rapido permessi

Il modo più veloce per cambiare permission mode durante una conversazione:

- `Shift+Tab` → cicla: Explore → Ask to Edit → Auto → Explore...
- Utile quando passi da "leggere" a "modificare"
- Visibile nell'interfaccia — nessun dubbio su quale mode è attivo

---

## Come cambiare provider LLM a metà sessione?

Puoi cambiare provider in qualsiasi momento dalle **impostazioni del workspace**.

**Quando conviene:**
- Task semplice → passa a un modello più economico/veloce
- Task complesso → passa a Claude Opus o GPT-4o
- Vuoi testare la stessa risposta su modelli diversi

**Nota**: il provider è per-workspace, non per-sessione.

---

## File Attachments: cosa puoi allegare

Trascina e rilascia file nella chat:

- **Immagini**: PNG, JPG, WEBP, GIF
- **PDF**: vengono letti e processati
- **Documenti Office**: DOCX, XLSX — convertiti automaticamente
- **Codice**: qualsiasi file di testo

**Tips:**
- Le immagini vengono visualizzate inline nella chat
- I PDF vengono estratti come testo per l'agente
- I file Office vengono convertiti automaticamente

---

## Multi-File Diff: visualizzare cambiamenti

Quando l'agente modifica più file, puoi vedere un **diff stile VS Code** di tutti i file in un colpo solo.

- Apri dal pulsante "Changes" dopo un turno
- Vedi aggiunte/rimozioni per ogni file
- Permette di revieware rapidamente prima di approvare

---

## Background Tasks: operazioni lunghe

Le operazioni che richiedono tempo (download, analisi grandi dataset) girano in **background**:

- Puoi continuare a chattare mentre l'operazione procede
- Una barra di progresso mostra lo stato
- Ricevi una notifica quando l'operazione è completa
- Visibile in una sezione dedicata dell'interfaccia

---

## Session Flags e Status Workflow

Le sessioni hanno un **workflow di stato** personalizzabile:

**Default states:** Todo → In Progress → Needs Review → Done

**Flagging:** segna sessioni importanti per accesso rapido

**Configurazione:**
- Gli stati sono configurabili per workspace
- I flags sono una proprietà toggle per sessione
- Le automazioni possono reagire ai cambi di stato

**Tips:**
- Usa i flags per sessioni che richiedono attenzione
- Personalizza gli stati per matchare il tuo workflow
- Le sessioni flaggate appaiono in una sezione dedicata

---

## Theme System: ereditarietà app → workspace → agente

Il tema segue una **cascata**:

1. **App Theme** → base (tutte le finestre)
2. **Workspace Theme** → sovrascrive specifiche del workspace
3. **Agent Theme** → (futuro) per-agent

**File:**
- `~/.craft-agent/theme.json` — tema globale
- `~/.craft-agent/workspaces/{id}/theme.json` — override per workspace

**Tips:**
- Usa temi diversi per workspace lavoro/personale
- Il tema workspace non richiede restart
- Supporta modalità chiara/scura

---

## Session Persistence: dove vengono salvate le chat

Tutte le sessioni sono salvate su disco in formato **JSONL**:

```
~/.craft-agent/workspaces/{id}/sessions/
├── {session-id}.jsonl
├── {session-id}.jsonl
└── ...
```

**Vantaggi:**
- Persistenza completa — niente si perde tra un'avvio e l'altro
- Formato append-only — safe da crash
- Recuperabile manualmente se serve

---

## Compressione risposte grandi >60KB

Quando le risposte dei tool superano ~60KB, vengono **automaticamente riassunte** usando Claude Haiku.

- L'`_intent` field nei tool MCP preserva il focus della summarization
- Le risposte rimangono utilizzabili dall'agente senza esplodere il contesto
- Trasparente — non devi fare nulla

---

## Multi-Provider: workspace diversi, provider diversi

Ogni workspace può avere un **provider LLM diverso**:

- Workspace "Lavoro" → Anthropic (Claude Sonnet)
- Workspace "Personale" → Google AI Studio (Gemini)
- Workspace "Test" → OpenAI via OpenRouter

**Come:**
1. Crea un workspace
2. Vai nelle impostazioni
3. Seleziona provider e modello
4. Fatto — ogni chat in quel workspace usa quel provider

---

## Debug Mode: log avanzati

Per avviare con logging verboso:

**macOS:**
```bash
/Applications/Craft\ Agents.app/Contents/MacOS/Craft\ Agents -- --debug
```

**Windows (PowerShell):**
```powershell
& "$env:LOCALAPPDATA\Programs\@craft-agentelectron\Craft Agents.exe" -- --debug
```

**Linux:**
```bash
./craft-agents -- --debug
```

---

## Log paths per OS

| OS | Path |
|----|------|
| **macOS** | `~/Library/Logs/@craft-agent/electron/main.log` |
| **Windows** | `%APPDATA%\@craft-agent\electron\logs\main.log` |
| **Linux** | `~/.config/@craft-agent/electron/logs/main.log` |

**Prefix chiave:**
- `[SessionManager]` — ciclo di vita sessione, auth
- `[IPC]` — comunicazione inter-processo

---

## Everything is Instant: no restart needed

Una delle caratteristiche più potenti: **tutto è immediato**.

- Aggiungi un source con `@source` → funziona subito
- Crea una skill → disponibile immediatamente
- Cambia configurazione → effetto istantaneo
- Nessun rebuild, nessun deploy, nessun restart

Questo è possibile perché Craft Agents è costruito con principi **agent-native**: l'agente riconfigura il sistema al volo.

---

## Agent-Native Philosophy

Craft Agents è progettato per essere usato **da agenti AI**, non solo da umani:

- **Descrivi, non configura** — "aggiungi GitHub" invece di cercare tutorial
- **Tutto è modificabile** — l'agente può cambiare qualsiasi cosa su richiesta
- **Interfaccia conversazionale** — non serve un manuale, basta chiedere

**Implicazioni pratiche:**
- Se non sai come fare qualcosa, **chiedi all'agente**
- Se vuoi cambiare qualcosa, **descrivi cosa vuoi**
- Se qualcosa non funziona, **descrivi il problema** — l'agente debugga da solo

---

## Craft MCP Integration: 32+ tools

Se usi Craft (craft.do), hai accesso a 32+ strumenti MCP:

- **Blocks**: crea, modifica, organizza blocchi
- **Collections**: gestisci raccolte
- **Search**: cerca nel workspace Craft
- **Tasks**: gestisci task

**Esempi di prompt:**
```
@craft Cerca nel mio workspace i documenti su "architettura"
@craft Crea una nuova collection per i meeting notes
```

---

**Vedi anche**:
- [Troubleshooting](troubleshooting.md) — risoluzione problemi
- [Quickstart](quickstart.md) — guida iniziale
- [Automations Guide](automations.md) — workflow automatici
- [Sources Guide](sources-guide.md) — connettere servizi esterni
