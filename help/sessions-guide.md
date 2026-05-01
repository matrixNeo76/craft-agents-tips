<!-- v1.2.0 - last updated: 2026-05-01 -->

# Sessions Guide — Organizzare Sessioni, Flag, Ricerca

Guida alla gestione delle sessioni in Craft Agents: organizzazione, flags, archivio, ricerca e pattern pratici.

---

## Indice

- [Cosa sono le sessioni?](#cosa-sono-le-sessioni)
- [Come organizzare le sessioni nell'inbox?](#come-organizzare-le-sessioni-nellinbox)
- [Come funzionano i flags?](#come-funzionano-i-flags)
- [Come funziona l'archivio?](#come-funziona-larchivio)
- [Come cercare sessioni passate?](#come-cercare-sessioni-passate)
- [Le sessioni persistono tra riavvii?](#le-sessioni-persistono-tra-riavvii)
- [Dove vengono salvate le sessioni su disco?](#dove-vengono-salvate-le-sessioni-su-disco)
- [Pattern pratici di gestione](#pattern-pratici-di-gestione)
- [Best practices](#best-practices)

---

## Cosa sono le sessioni?

Una **sessione** è una conversazione completa con l'agente. Ogni sessione:

- Ha una **cronologia** di tutti i messaggi e le risposte
- Ha un **titolo** (generato automaticamente o manuale)
- Ha uno **stato** (todo → in_progress → needs_review → done)
- Può avere **label** e **flags**
- Viene **salvata su disco** in formato JSONL
- **Persiste** tra riavvii dell'app

---

## Come organizzare le sessioni nell'inbox?

L'inbox mostra le sessioni aperte, organizzate per **stato**:

| Stato | Significato | Cosa fare |
|-------|-------------|-----------|
| Todo | Da iniziare | Assegna priorità e inizia |
| In Progress | In corso | Continua a lavorarci |
| Needs Review | Richiede revisione | Qualcuno deve verificare |
| Done | Completata | Archivia o cancella |

**Esempio di flusso quotidiano:**
1. Mattina → crea sessione "Review issue #42", stato **Todo**
2. Lavori → cambi stato in **In Progress**
3. Finisci → cambi in **Needs Review** per un collega
4. Approvato → **Done**, spostato in archivio

**Tips:**
- Usa `Cmd+N` per creare una nuova sessione
- I titoli vengono generati automaticamente dopo il primo scambio
- Puoi rinominare manualmente una sessione cliccando sul titolo
- Le sessioni in stato "Done" si spostano automaticamente in archivio

---

## Come funzionano i flags?

I **flags** sono un modo rapido per marcare sessioni importanti:

- **Toggle on/off**: un click per flaggare/deflaggare
- **Vista dedicata**: le sessioni flaggate appaiono in una sezione a parte
- **Indipendente dagli stati**: una sessione può essere flaggata in qualsiasi stato

**Esempi d'uso:**
```
Sessione "Decisione: usare PostgreSQL" → flaggata
Sessione "Bug critico in produzione"  → flaggata
Sessione "Setup iniziale"             → NON flaggata (non urgente)
```

**Automazione collegata:**
```json
{
  "FlagChange": [
    {
      "matcher": "true",
      "actions": [
        {
          "type": "prompt",
          "prompt": "La sessione $CRAFT_SESSION_ID è stata flaggata. Riassumi la situazione."
        }
      ]
    }
  ]
}
```

---

## Come funziona l'archivio?

L'archivio contiene le sessioni **completate**:

- Le sessioni in stato "Done" vengono spostate in archivio automaticamente
- Rimangono **accessibili** (non cancellate)
- Non ingombrano l'inbox principale
- Puoi sempre riaprirlle se serve

**Non devi fare nulla**: quando cambi stato a "Done", la sessione si archivia da sola.

---

## Come cercare sessioni passate?

**Metodo 1 — Chiedi all'agente:**
```
Cerca la sessione in cui abbiamo discusso di OAuth
```
L'agente cerca nella cronologia delle sessioni salvate.

**Metodo 2 — Per data o label:**
```
Trovami le sessioni di ieri con label "bug"
```

**Metodo 3 — Navigazione manuale:**
Scorri l'inbox o la sezione "All Sessions" per trovare ciò che cerchi.

**Tips per ritrovare sessioni:**
- Usa **label descrittivi** per raggruppare (es. `bug`, `feature-x`, `setup`)
- Dai **nomi significativi** alle sessioni (rinomina dopo il primo scambio)
- I flags aiutano a ritrovare sessioni importanti velocemente

---

## Le sessioni persistono tra riavvii?

**Sì**, tutte le sessioni sono persistenti. Prova:

1. Chiudi l'app
2. Riapri dopo ore o giorni
3. Trovi tutte le sessioni esattamente come le hai lasciate

---

## Dove vengono salvate le sessioni su disco?

```
~/.craft-agent/workspaces/{id}/sessions/
├── abc123.jsonl      ← una sessione
├── def456.jsonl      ← un'altra sessione
└── ...
```

**Formato JSONL**: ogni riga è un evento della sessione (messaggio inviato, risposta ricevuta, tool usato). Append-only: safe da crash.

**Esempio di contenuto (una riga per evento):**
```json
{"type":"user_message","content":"Ciao, analizza questo codice","ts":"2026-05-01T10:00:00Z"}
{"type":"assistant_text","content":"Analizzo il codice...","ts":"2026-05-01T10:00:01Z"}
{"type":"tool_use","tool":"read_file","input":"src/main.ts","ts":"2026-05-01T10:00:02Z"}
```

---

## Pattern pratici di gestione

### Pattern: Daily Standalone
Crea una sessione al giorno per attività correnti:
```
Sessione: "2026-05-01 — Lavoro corrente"
Label: "lavoro", "wip"
Flags: ✅ se urgente
```

### Pattern: Per Feature
Una sessione per ogni feature che sviluppi:
```
Sessione: "Auth — implementa OAuth"
Label: "feature/auth"
Stato: In Progress → Done quando finito
```

### Pattern: Bug Tracking
```
Sessione: "Bug #42 — login fallisce su mobile"
Label: "bug", "mobile"
Flag: ✅
Stato: Todo → In Progress → Needs Review → Done
```

### Pattern: Settimanale / Review
```
Sessione: "Week 18 Review — Decisioni"
Label: "review", "settimanale"
Durata: aperta venerdì, chiusa lunedì
```

---

## Best practices

### DO
- **Rinomina** le sessioni dopo il primo scambio (nome descrittivo)
- **Usa label** per categorizzare (es. `bug`, `feature`, `setup`, `urgente`)
- **Flaggale** se sono importanti o da non perdere
- **Cambia stato** man mano che procedi (todo → in_progress → done)
- **Chiudi** le sessioni completate per tenere ordinato l'inbox
- **Usa pattern** come quelli sopra per consistenza

### DON'T
- **Non lasciare** decine di sessioni "In Progress" aperte
- **Non dimenticare** di flaggare sessioni con decisioni critiche
- **Non temere** di archiviare — puoi sempre riaprire

---

**Vedi anche**: [Tips & Tricks](tips-and-tricks.md) | [Labels Guide](labels-guide.md) | [FAQ](faq.md)
