# Piano di Miglioramento — Craft Agents Tips

## Valutazione dello Stato Attuale

### Cosa funziona bene ✅
- **8 guide complete** con 103 domande e 69 esempi
- **Nuovo repo pubblico** su GitHub (`matrixNeo76/craft-agents-tips`)
- **Source attivo** nel workspace (Local Folder → `~/repos/craft-agents-tips`)
- **Skill installata** che triggera su domande pertinenti
- **Test funzionante** — l'agente ha consultato il file giusto durante il test

### Criticità Identificate

| # | Criticità | Impatto |
|---|-----------|---------|
| C1 | **Nessuna `guide.md`** per il Source — l'agente non sa quali tools/strumenti offre | L'agente non sa che può leggere/cercare nei file help |
| C2 | **Nessuna search semantica** — solo grep su markdown | Per trovare una risposta, l'agente deve leggere interi file |
| C3 | **Nessun diagramma Mermaid** nella architecture guide | La comprensione dell'architettura è solo testuale |
| C4 | **Nessun `llms.txt`** / HADS per consumo AI ottimizzato | Agenti esterni non possono scoprire il contenuto facilmente |
| C5 | **Skill migliorabile** — potrebbe coprire più scenari e suggest | Trigger parziali, nessun suggerimento proattivo |
| C6 | **Nessuna automazione** — sync con upstream, CI, changelog | Le guide invecchiano senza aggiornamenti |
| C7 | **Solo Italiano** — barriera per utenti internazionali | Repo pubblico ma non accessibile a tutti |
| C8 | **Nessun indice/search FTS** per interrogazioni rapide | L'agente deve scorrere file interi per trovare una risposta |

---

## Micro-Fasi di Miglioramento

### MF-1: Aggiungere `guide.md` al Source
**Obiettivo**: Dare all'agente istruzioni chiare su come usare il Source.
**Cosa fare**:
- Creare `source-guide.md` nella root del repo
- Specificare: path alla directory help/, elenco file, formato frontmatter YAML
- Descrivere i tool a disposizione dell'agente (lettura file, ricerca)

**Output**: `source-guide.md`
**Priorità**: Alta — senza questo il source è "muto"

---

### MF-2: Aggiungere Diagrammi Mermaid
**Obiettivo**: Visualizzare l'architettura e i flussi complessi.
**Cosa fare**:
- `architecture-overview.md`: Mermaid diagram del monorepo, del session loop, del thin-client mode
- `automations.md`: Mermaid diagram del flusso eventi (LabelAdd → azione → sessione)
- `sources-guide.md`: Mermaid diagram del flusso OAuth Google

**Output**: 3 diagrammi Mermaid in altrettante guide
**Priorità**: Media — migliora comprensione ma non blocca l'uso

---

### MF-3: Creare `llms.txt` per AI Discovery
**Obiettivo**: Permettere a qualsiasi LLM/agente di scoprire il contenuto del repo.
**Cosa fare**:
- Creare `llms.txt` (standard llmstxt.org) con descrizione e link a tutte le guide
- Creare `llms-full.txt` con il contenuto completo per training/retrieval

**Output**: `llms.txt`, `llms-full.txt`
**Priorità**: Alta — repo pubblico, deve essere discoverabile

---

### MF-4: Migliorare la Skill `craft-agents-help`
**Obiettivo**: Coprire più scenari e far sì che l'agente suggerisca la guida proattivamente.
**Cosa fare**:
- Aggiungere più trigger words (es. "come collego", "perché non", "non capisco", "spiegami")
- Aggiungere sezione "Suggestions" per risposte proattive (es. se l'utente parla di MCP, suggerire sources-guide)
- Migliorare i mapping domanda → file con più granularità

**Output**: `SKILL.md` aggiornata
**Priorità**: Media

---

### MF-5: Aggiungere Automazioni per Sync
**Obiettivo**: Mantenere le guide aggiornate con i cambiamenti di Craft Agents OSS.
**Cosa fare**:
- Scheduler tick settimanale che controlla il repo upstream `lukilabs/craft-agents-oss`
- Confronta README.md upstream con le nostre guide per verificare obsolescenza
- Segnala cambiamenti in una sessione dedicata

**Output**: Automazione in `automations.json`
**Priorità**: Bassa — utile ma non urgente

---

### MF-6: Aggiungere Search FTS (Full-Text Search)
**Obiettivo**: Permettere all'agente di cercare semanticamente nelle guide.
**Cosa fare**:
- Valutare se serve un MCP server custom che espone i docs con FTS
- Alternativa: usare grep con pattern intelligenti
- Strumento bash: script che indicizza tutte le guide per query veloci

**Output**: Script `scripts/search-help.sh` + documentazione
**Priorità**: Media — utile ma non bloccante

---

### MF-7: Aggiungere Changelog e Versioning
**Obiettivo**: Tracciare l'evoluzione del sistema help.
**Cosa fare**:
- Creare `CHANGELOG.md` in formato Keep a Changelog
- Aggiungere header di versione a ogni guida (es. `<!-- v1.0.0 -->`)
- Aggiungere `last-updated` date in ogni file

**Output**: `CHANGELOG.md`, version headers
**Priorità**: Bassa

---

### MF-8: Traduzione EN delle Guide (futuro)
**Obiettivo**: Rendere il repo accessibile a utenti internazionali.
**Cosa fare**:
- Creare directory `help/en/` con traduzioni
- Tradurre quickstart, troubleshooting e tips-and-tricks prima (massimo impatto)

**Output**: `help/en/` con 3 guide tradotte
**Priorità**: Bassa — solo dopo che il contenuto IT è stabile

---

## Dipendenze

```
MF-1 (guide.md) ─── indipendente
MF-2 (Mermaid)  ─── indipendente
MF-3 (llms.txt) ─── indipendente
MF-4 (skill)    ─── dopo MF-1
MF-5 (sync)     ─── dipende dal contenuto upstream
MF-6 (search)   ─── indipendente
MF-7 (changelog)── indipendente
MF-8 (EN)       ─── dopo stabilizzazione contenuti IT
```

---

## Priorità Consigliata

| Fase | Cosa | Perché prima |
|------|------|-------------|
| **1** | MF-1 (guide.md) + MF-3 (llms.txt) | Il source è "muto" senza guide.md; repo pubblico dev'essere discoverabile |
| **2** | MF-4 (skill) + MF-2 (Mermaid) | Skill più performante + visualizzazioni |
| **3** | MF-6 (search) + MF-7 (changelog) | Searchabilità + tracciamento versioni |
| **4** | MF-5 (sync) + MF-8 (EN) | Automazione manutenzione + accessibilità globale |

---

## Metriche di Successo Aggiornate

| Metrica | Target | Attuale | Gap |
|---------|--------|---------|-----|
| guide.md presente | ✅ | ❌ | +1 |
| Diagrammi Mermaid | ≥3 | 0 | +3 |
| llms.txt funzionante | ✅ | ❌ | +1 |
| Skill trigger accuracy | ≥90% | ~70% (stimato) | +20% |
| CI/CD pipeline | ✅ | ❌ | +1 |
| Search veloce per l'agente | <2 file da leggere | interi file | ridurre |
| Changelog attivo | ✅ | ❌ | +1 |
