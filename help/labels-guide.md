<!-- v1.1.0 - last updated: 2026-05-01 -->

# Labels Guide — Etichette, Colorì, Auto-Apply

Guida al sistema di label in Craft Agents: creare, organizzare e automatizzare le etichette delle sessioni.

---

## Indice

- [Cosa sono i label?](#cosa-sono-i-label)
- [Come si crea un label?](#come-si-crea-un-label)
- [Come usare i label per organizzare le sessioni?](#come-usare-i-label-per-organizzare-le-sessioni)
- [Come funzionano i label gerarchici?](#come-funzionano-i-label-gerarchici)
- [Come funziona l'auto-apply con regex?](#come-funziona-lauto-apply-con-regex)
- [Come usare i label con le automazioni?](#come-usare-i-label-con-le-automazioni)
- [Best practices per i label](#best-practices-per-i-label)

---

## Cosa sono i label?

I **label** sono etichette colorate che puoi attaccare alle sessioni per organizzarle.

**A cosa servono:**
- Filtrare sessioni per argomento
- Triggerare automazioni (LabelAdd, LabelRemove)
- Trovare rapidamente sessioni correlate
- Organizzare l'inbox per categorie

---

## Come si crea un label?

**Metodo più semplice — chiedi all'agente:**
```
Crea un label rosso chiamato "urgente"
```

**Oppure** usa l'interfaccia dell'app: clicca sul pulsante label nella sessione e creane uno nuovo.

**Proprietà di un label:**
- **Nome**: testo identificativo
- **Colore**: per riconoscimento visivo rapido
- **Gerarchia**: opzionale, può essere annidato

---

## Come usare i label per organizzare le sessioni?

| Label | Colore suggerito | Quando usarlo |
|-------|------------------|---------------|
| `urgente` | 🔴 Rosso | Sessioni che richiedono attenzione immediata |
| `bug` | 🟠 Arancione | Sessioni su bug e problemi |
| `feature` | 🟢 Verde | Sessioni su nuove funzionalità |
| `setup` | 🔵 Blu | Configurazione iniziale, sources, skills |
| `domanda` | 🟣 Viola | Richieste di chiarimento o aiuto |
| `wip` | 🟡 Giallo | Work in progress |

**Convenzione di naming:**
```
urgente              → piatto, semplice
progetto/alpha       → gerarchico, per progetto
progetto/alpha/bug   → multi-livello
```

---

## Come funzionano i label gerarchici?

I label supportano una struttura **gerarchica** (nidificata):

```
progetto/
├── alpha/
│   ├── bug
│   └── feature
└── beta/
    ├── bug
    └── feature
```

**Vantaggi:**
- Organizzazione logica per area/progetto
- Filtri per categoria principale o specifica
- Automazioni con regex sulla gerarchia completa

**Esempio di automazione:**
```json
{
  "LabelAdd": [
    {
      "matcher": "progetto/.*/bug",
      "actions": [
        {
          "type": "prompt",
          "prompt": "Bug trovato nel progetto. Assegna priorità e analizza."
        }
      ]
    }
  ]
}
```

---

## Come funziona l'auto-apply con regex?

I label possono essere applicati **automaticamente** in base al contenuto dei messaggi.

**Configurazione (in `~/.craft-agent/workspaces/{id}/config.json`):**
```json
{
  "labelAutoApply": [
    {
      "pattern": "errore|error|exception|fallito",
      "label": "bug"
    },
    {
      "pattern": "setup|config|installazione",
      "label": "setup"
    }
  ]
}
```

**Come funziona:**
1. Ogni volta che arriva un messaggio, le regex vengono verificate
2. Se una pattern matcha, il label viene applicato automaticamente
3. Più label possono matchare sulla stessa sessione
4. I label sono deduplicati (non vengono applicati due volte)

**Tips per le regex:**
- Usa pattern **specifici** per evitare falsi positivi
- Metti pattern più generici verso la fine (fallback)
- Testa la regex prima di inserirla

---

## Come usare i label con le automazioni?

I label sono eventi nativi per le automazioni:

**LabelAdd** — quando un label viene aggiunto:
```json
{
  "LabelAdd": [
    {
      "matcher": "urgente|bloccante",
      "actions": [
        {
          "type": "prompt",
          "prompt": "La sessione $CRAFT_SESSION_ID ha ricevuto il label $CRAFT_LABEL."
        }
      ]
    }
  ]
}
```

**LabelRemove** — quando un label viene rimosso:
```json
{
  "LabelRemove": [
    {
      "matcher": "wip",
      "actions": [
        {
          "type": "prompt",
          "prompt": "Label wip rimosso. Resoconto di quanto fatto?"
        }
      ]
    }
  ]
}
```

---

## Best practices per i label

### DO
- **Usa pochi label** (5-10) per non frammentare l'inbox
- **Convenzione chiara**: decidi un naming e attieniti
- **Colori consistenti**: rosso=urgente, verde=completato
- **Regex mirate** per auto-apply: evita falsi positivi
- **Label + automazione**: il pattern più potente

### DON'T
- **Non creare** troppi label (oltre 15 diventa caotico)
- **Non usare** label al posto degli stati (todo/in_progress/done)
- **Non dimenticare** che le automazioni LabelAdd possono creare loop se mal configurate

---

**Vedi anche**: [Automations Guide](automations.md) | [Sessions Guide](sessions-guide.md) | [Tips & Tricks](tips-and-tricks.md)
