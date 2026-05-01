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

| Evento | Descrizione |
|--------|-------------|
| `SchedulerTick` | Attivato a intervalli cron |
| `LabelAdd` | Un label viene aggiunto a una sessione |
| `LabelRemove` | Un label viene rimosso da una sessione |
| `PermissionModeChange` | Cambio del permission mode |
| `FlagChange` | Una sessione viene flaggata/deflaggata |
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

## Best practices per le automazioni

### DO
- **Usa label descrittivi** sulle sessioni automatizzate (`Scheduled`, `auto-*`)
- **Timezone esplicito** per SchedulerTick — evita ambiguità
- **Regex mirate** per LabelAdd — troppo generiche causano falsi positivi
- **Prompt concisi** — l'azione deve essere focalizzata

### DON'T
- **Non creare loop**: un'azione che aggiunge un label che triggera un'altra automazione
- **Non esagerare con la frequenza**: SchedulerTick ogni minuto non è necessario
- **Non dimenticare che** le automazioni creano **nuove sessioni** — troppe sessioni automatiche intasano l'inbox

### Pattern consigliati

**Weekly review:**
```json
{
  "cron": "0 17 * * 5",
  "timezone": "Europe/Rome",
  "labels": ["Scheduled", "weekly-review"],
  "actions": [
    {
      "type": "prompt",
      "prompt": "Riassumi le sessioni completate questa settimana. Evidenzia decisioni importanti e task ancora aperti."
    }
  ]
}
```

**Auto-label su sessione urgente:**
```json
{
  "LabelAdd": [
    {
      "matcher": "bloccante|blocking",
      "actions": [
        {
          "type": "prompt",
          "prompt": "La sessione $CRAFT_SESSION_ID è bloccante. Riassumi il problema e suggerisci il prossimo passo."
        }
      ]
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
