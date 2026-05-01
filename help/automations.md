<!-- v1.1.0 - last updated: 2026-05-01 -->

# Automations Guide — Eventi, Scheduler e Workflow

Guida per creare automazioni event-driven in Craft Agents.

---

## Indice delle Domande

- [Cosa sono le automazioni?](#cosa-sono-le-automazioni)
- [Quali eventi sono supportati?](#quali-eventi-sono-supportati)
- [Dove si configurano le automazioni?](#dove-si-configurano-le-automazioni)
- [Come configuro un promemoria giornaliero?](#come-configuro-un-promemoria-giornaliero)
- [Come faccio scattare un'azione quando un label viene aggiunto?](#come-faccio-scattare-unazione-quando-un-label-viene-aggiunto)
- [Quali variabili d'ambiente sono disponibili?](#quali-variabili-dambiente-sono-disponibili)
- [Come funziona PreToolUse per governance?](#come-funziona-pretooluse-per-governance)
- [Best practices per le automazioni](#best-practices-per-le-automazioni)

---

## Cosa sono le automazioni?

Le **automazioni** permettono di eseguire azioni automatiche in risposta a eventi.

```mermaid
flowchart LR
    E[Evento] -->|SchedulerTick\ncron match| C{Check Config}
    E -->|LabelAdd\nregex match| M{Matcher Match?}
    E -->|SessionStart| A[Auto Action]
    M -->|Sì| P[Esegui Prompt]
    M -->|No| X[Ignora]
    C -->|Schedulato| P
    P --> CS[Nuova Sessione Agente]
    CS --> AG[Esegue azione con @mentions]
    AG --> RS[Risultato salvato]
``` Quando un evento si verifica (es. un label viene aggiunto, uno scheduler ticka), Craft Agents crea una nuova sessione che esegue il prompt configurato.

**Casistiche d'uso:**
- "Ogni mattina alle 9, controlla le nuove issue su GitHub"
- "Quando una sessione è marcata urgente, notifyami"
- "Ogni venerdì, riassumi i task completati della settimana"

---

## Quali eventi sono supportati?

Craft Agents supporta **12+ eventi** per triggerare automazioni:

### Eventi di Sessione
| Evento | Descrizione | Quando usarlo |
|--------|-------------|---------------|
| `SessionStart` | Nuova sessione creata | Setup automatico, benvenuto, template |
| `SessionEnd` | Sessione terminata | Riassunto, salvataggio, cleanup |
| `SessionStatusChange` | Stato cambiato (todo → in_progress → done) | Notifiche su avanzamento |

### Eventi di Label
| Evento | Descrizione |
|--------|-------------|
| `LabelAdd` | Label aggiunto a una sessione |
| `LabelRemove` | Label rimosso da una sessione |

### Eventi di Modifica
| Evento | Descrizione |
|--------|-------------|
| `PermissionModeChange` | Cambio del permission mode |
| `FlagChange` | Sessione flaggata/deflaggata |

### Eventi di Tool
| Evento | Descrizione | Quando usarlo |
|--------|-------------|---------------|
| `PreToolUse` | **Prima** che un tool venga eseguito | Governance, sicurezza, logging |
| `PostToolUse` | **Dopo** che un tool è stato eseguito | Audit, notifiche su azioni |

### Eventi Temporizzati
| Evento | Descrizione |
|--------|-------------|
| `SchedulerTick` | Attivato a intervalli cron (minimo: 1 minuto) |

### Quando usare ogni evento

| Scenario | Evento | Esempio |
|----------|--------|--------|
| Reminder giornaliero | `SchedulerTick` | Ogni mattina alle 9, controlla issue |
| Notifica urgenza | `LabelAdd` | Se label=urgente, notifyami |
| Fine sessione | `SessionEnd` | Riassumi cosa è stato fatto |
| Cambio stato | `SessionStatusChange` | Avvisa quando in review |
| Policy sicurezza | `PreToolUse` | Blocca comandi pericolosi |
| Audit | `PostToolUse` | Logga ogni tool eseguito |
| `SessionStatusChange` | Stato sessione cambia (todo → in_progress → done) |
| `SessionStart` | Una nuova sessione viene creata |
| `SessionEnd` | Una sessione termina |
| `PreToolUse` | Prima che un tool venga eseguito |
| `PostToolUse` | Dopo che un tool è stato eseguito |

---

## Dove si configurano le automazioni?

File: `~/.craft-agent/workspaces/{id}/automations.json`

**Formato:**
```json
{
  "version": 2,
  "automations": {
    "SchedulerTick": [
      { "...": "configurazione evento" }
    ],
    "LabelAdd": [
      { "...": "configurazione evento" }
    ]
  }
}
```

Il modo più semplice è chiedere all'agente:

```
Configura un promemoria giornaliero alle 9 di mattina
```

---

## Come configuro un promemoria giornaliero?

**Prompt all'agente:**
```
Configura un briefing giornaliero ogni giorno feriale alle 9:00 ET
che controlla le nuove issue su GitHub
```

**Configurazione generata:**
```json
{
  "version": 2,
  "automations": {
    "SchedulerTick": [
      {
        "cron": "0 9 * * 1-5",
        "timezone": "America/New_York",
        "labels": ["Scheduled", "daily-briefing"],
        "actions": [
          {
            "type": "prompt",
            "prompt": "Check @github per nuove issue assegnate a me e riassumile"
          }
        ]
      }
    ]
  }
}
```

**I prompt actions** supportano:
- `@mentions` per sources e skills
- Variabili d'ambiente automaticamente espanse (vedi sotto)

---

## Come faccio scattare un'azione quando un label viene aggiunto?

**Prompt all'agente:**
```
Quando una sessione viene marcata come urgente, riassumi cosa c'è da fare
```

**Configurazione generata:**
```json
{
  "version": 2,
  "automations": {
    "LabelAdd": [
      {
        "matcher": "^urgente$|^urgent$",
        "actions": [
          {
            "type": "prompt",
            "prompt": "Un label urgente è stato aggiunto alla sessione. Analizza la sessione e riassumi cosa richiede attenzione immediata."
          }
        ]
      }
    ]
  }
}
```

**Tips:**
- `matcher` è un'espressione regolare
- Puoi avere più automazioni per lo stesso evento con matcher diversi
- Le azioni vengono eseguite in sessioni separate, non bloccano quella corrente

---

## Quali variabili d'ambiente sono disponibili?

Nei prompt delle automazioni, queste variabili vengono espanse automaticamente:

| Variabile | Contenuto |
|-----------|-----------|
| `$CRAFT_LABEL` | Label che ha triggerato l'evento |
| `$CRAFT_SESSION_ID` | ID della sessione coinvolta |
| `$CRAFT_WORKSPACE_ID` | ID del workspace |

**Esempio di utilizzo:**
```json
{
  "type": "prompt",
  "prompt": "La sessione $CRAFT_SESSION_ID ha ricevuto il label $CRAFT_LABEL. Cosa è cambiato?"
}
```

---

## Come funziona PreToolUse per governance?

`PreToolUse` e `PostToolUse` permettono di **intercettare** l'uso dei tools.

**Esempio: policy di sicurezza**
```json
{
  "PreToolUse": [
    {
      "matcher": "bash|execute_command",
      "actions": [
        {
          "type": "prompt",
          "prompt": "Un comando bash sta per essere eseguito. Verifica che non sia pericoloso: $CRAFT_TOOL_INPUT"
        }
      ]
    }
  ]
}
```

---

## Come gestire errori nelle automazioni?

Le automazioni creano **nuove sessioni**. Se un'azione fallisce:

1. La sessione mostra l'errore (come qualsiasi chat)
2. Non c'è un meccanismo di retry automatico
3. Le sessioni fallite rimangono visibili nell'inbox

**Best practices per errori:**
- Dai prompt **robusti** che gestiscono casistiche limite
- Verifica che i sources menzionati siano attivi (es. `@github` deve esistere)
- Includi nel prompt istruzioni su cosa fare se qualcosa non è disponibile
- Per task critici, programma esecuzioni più frequenti (così il prossimo tick recupera)

## Come monitorare le automazioni?

Tutte le sessioni create dalle automazioni sono visibili nell'inbox:

- Hanno label automatici (es. `Scheduled`, `daily-briefing`)
- Puoi filtrarle per label nella sidebar
- Puoi controllare la cronologia delle esecuzioni
- Le sessioni fallite mostrano l'errore come ultimo messaggio

**Pattern: auto-monitoring**
Crea un'automazione che controlla le altre:
```json
{
  "SchedulerTick": [
    {
      "cron": "0 9 * * 1",
      "timezone": "Europe/Rome",
      "labels": ["Scheduled", "weekly-audit"],
      "actions": [
        {
          "type": "prompt",
          "prompt": "Controlla le sessioni con label 'Scheduled' dell'ultima settimana. Ce ne sono di fallite o incomplete?"
        }
      ]
    }
  ]
}
```

## Pattern avanzati di automazioni

### Pattern: notifica condizionale
Esegui un controllo e poi notifica solo se serve:
```json
{
  {
    "cron": "0 9,15 * * 1-5",
    "timezone": "Europe/Rome",
    "labels": ["Scheduled", "issue-check"],
    "actions": [
      {
        "type": "prompt",
        "prompt": "@github Cerca issue senza risposta da più di 3 giorni. Se ce ne sono, riassumile."
      }
    ]
  }
}
```
L'agente risponderà solo se trova issue — altrimenti la sessione rimane breve.

### Pattern: escalation automatica
```json
{
  "LabelAdd": [
    {
      "matcher": "bloccante|p1|critical",
      "actions": [
        {
          "type": "prompt",
          "prompt": "La sessione ha un problema critico. Riassumi: cosa serve per sbloccarla?"
        }
      ]
    }
  ]
}
```

### Pattern: report periodico strutturato
```json
{
  "cron": "0 18 * * 5",
  "timezone": "Europe/Rome",
  "labels": ["Scheduled", "weekly-report"],
  "actions": [
    {
      "type": "prompt",
      "prompt": "Genera un report settimanale:
1. Sessioni completate: quante e cosa?
2. Decisioni importanti prese
3. Task ancora aperti
4. Prossimi passi"
    }
  ]
}
```

---

**Vedi anche**:
- [Skills Guide](skills-guide.md) — quando usare skill vs automazione
- [Tips & Tricks](tips-and-tricks.md) — scorciatoie e produttività
- [Troubleshooting](troubleshooting.md) — problemi comuni con automazioni
- [Architecture Overview](architecture-overview.md) — come funziona il sistema di automazioni
