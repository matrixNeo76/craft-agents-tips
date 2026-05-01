<!-- v1.1.0 - last updated: 2026-05-01 -->

# Sessions Guide — Organizzare Sessioni, Flag, Ricerca

Guida alla gestione delle sessioni in Craft Agents: organizzazione, flags, archivio e ricerca.

---

## Indice

- [Cosa sono le sessioni?](#cosa-sono-le-sessioni)
- [Come organizzare le sessioni nell'inbox?](#come-organizzare-le-sessioni-nellinbox)
- [Come funzionano i flags?](#come-funzionano-i-flags)
- [Come funziona l'archivio?](#come-funziona-larchivio)
- [Come cercare sessioni passate?](#come-cercare-sessioni-passate)
- [Le sessioni persistono tra riavvii?](#le-sessioni-persistono-tra-riavvii)
- [Dove vengono salvate le sessioni su disco?](#dove-vengono-salvate-le-sessioni-su-disco)
- [Best practices per la gestione delle sessioni](#best-practices-per-la-gestione-delle-sessioni)

---

## Cosa sono le sessioni?

Una **sessione** è una conversazione completa con l'agente. Ogni sessione:

- Ha una **cronologia** di tutti i messaggi e le risposte
- Ha un **titolo** (generato automaticamente o manuale)
- Ha uno **stato** (todo → in_progress → needs_review → done)
- Può avere **label** e **flags**
- Viene **salvata su disco** in formato JSONL

---

## Come organizzare le sessioni nell'inbox?

L'inbox mostra le sessioni aperte, organizzate per **stato**:

| Stato | Significato | Cosa fare |
|-------|-------------|-----------|
| Todo | Da iniziare | Assegna priorità e inizia |
| In Progress | In corso | Continua a lavorarci |
| Needs Review | Richiede revisione | Qualcuno deve verificare |
| Done | Completata | Archivia o cancella |

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
- **Indipendente dagli stati**: una sessione può essere flaggata e in qualsiasi stato

**Quando flaggare:**
- Sessioni che richiedono attenzione urgente
- Sessioni da revieware prima di chiudere
- Sessioni con decisioni importanti da ricordare

---

## Come funziona l'archivio?

L'archivio contiene le sessioni **completate**:

- Le sessioni in stato "Done" vengono spostate in archivio automaticamente
- Rimangono accessibili (non cancellate)
- Non ingombrano l'inbox principale
- Puoi sempre riaprirlle se serve

---

## Come cercare sessioni passate?

Puoi chiedere all'agente di trovare sessioni passate:

```
Cerca la sessione in cui abbiamo discusso di OAuth
```

L'agente cerca nella cronologia delle sessioni salvate.

**Tips per ritrovare sessioni:**
- Usa **label descrittivi** per raggruppare sessioni simili (es. `bug`, `feature-x`, `setup`)
- Dai **nomi significativi** alle sessioni (rinomina dopo il primo scambio)
- I flags aiutano a ritrovare sessioni importanti velocemente

---

## Le sessioni persistono tra riavvii?

**Sì**, tutte le sessioni sono persistenti. Puoi:

1. Chiudere l'app
2. Riaprire ore/giorni dopo
3. Trovare tutte le sessioni esattamente come le hai lasciate

La persistenza è garantita dal salvataggio in formato JSONL su disco.

---

## Dove vengono salvate le sessioni su disco?

```
~/.craft-agent/workspaces/{id}/sessions/
├── {session-id}.jsonl
├── {session-id}.jsonl
└── ...
```

**Formato JSONL**: ogni riga è un evento della sessione (messaggio, risposta, tool_use).

**Vantaggi:**
- Append-only: safe da crash
- Leggibile: puoi ispezionare il file con qualsiasi editor
- Backup: basta copiare la directory

---

## Best practices per la gestione delle sessioni

### DO
- **Rinomina** le sessioni dopo il primo scambio (nome descrittivo)
- **Usa label** per categorizzare (es. `bug`, `feature`, `setup`, `urgente`)
- **Flaggale** se sono importanti o da non perdere
- **Cambia stato** man mano che procedi (todo → in_progress → done)
- **Chiudi** le sessioni completate per tenere ordinato l'inbox

### DON'T
- **Non lasciare** decine di sessioni "In Progress" aperte
- **Non dimenticare** di flaggare sessioni con decisioni critiche
- **Non temere** di archiviare — puoi sempre riaprire

---

**Vedi anche**: [Tips & Tricks](tips-and-tricks.md) | [Labels Guide](labels-guide.md) | [Quickstart](quickstart.md)
