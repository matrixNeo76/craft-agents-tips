# Skills Guide — Estendere l'Agente

Guida per creare, importare e gestire skills in Craft Agents.

---

## Indice delle Domande

- [Cosa sono le skills?](#cosa-sono-le-skills)
- [Come creo una skill?](#come-creo-una-skill)
- [Come faccio riferimento a una skill con @mention?](#come-faccio-riferimento-a-una-skill-con-mention)
- [Come importo skills da Claude Code?](#come-importo-skills-da-claude-code)
- [Come aggiorno o elimino una skill?](#come-aggiorno-o-elimino-una-skill)
- [Dove vengono salvate le skills?](#dove-vengono-salvate-le-skills)
- [Quando creare una skill vs. un'automazione?](#quando-creare-una-skill-vs-unautomazione)
- [Best practices per scrivere una skill](#best-practices-per-scrivere-una-skill)

---

## Cosa sono le skills?

Le **skills** sono istruzioni specializzate che estendono le capacità dell'agente. Ogni skill è un file markdown con frontmatter YAML che dice all'agente come comportarsi in un contesto specifico.

**Esempi di skills:**
- Una skill che aiuta a scrivere commit message conventional
- Una skill che guida nel debugging di API REST
- Una skill che applica pattern di design specifici

---

## Come creo una skill?

**Metodo più semplice** — descrivi cosa vuoi:

```
Crea una skill che mi aiuti a scrivere messaggi di commit conventional
```

L'agente genera la struttura:
```
~/.craft-agent/workspaces/{id}/skills/
└── conventional-commit/
    ├── SKILL.md          ← Istruzioni in markdown con frontmatter
    └── ...               ← File di supporto opzionali
```

**Struttura di SKILL.md:**
```yaml
---
name: conventional-commit
description: Aiuta a scrivere messaggi di commit Conventional Commits
---

Quando ti chiedo di fare un commit:
1. Analizza i file modificati
2. Determina il tipo (feat, fix, chore, docs...)
3. Scrivi il messaggio nel formato: tipo(scope): descrizione
...
```

---

## Come faccio riferimento a una skill con @mention?

In qualsiasi conversazione, usa `@` seguito dal nome della skill:

```
@conventional-commit Prepara un commit per questi cambiamenti
```

**Tips:**
- Le menzioni funzionano istantaneamente — **nessun restart necessario**
- Puoi menzionare più skills e sources nella stessa frase
- Le skills sono attive solo quando le menzioni esplicitamente (tranne quelle always-on)

---

## Come importo skills da Claude Code?

Se hai già skills in Claude Code:

```
Importa le mie skills da Claude Code
```

L'agente trova le skills esistenti e le importa nel workspace corrente.

---

## Come aggiorno o elimino una skill?

**Aggiornare:**
```
Aggiorna la skill conventional-commit: aggiungi una sezione per breaking changes
```

**Eliminare:**
```
Elimina la skill conventional-commit
```

Oppure modifica direttamente i file in `~/.craft-agent/workspaces/{id}/skills/{skill-name}/`.

---

## Dove vengono salvate le skills?

Le skills vivono in:
```
~/.craft-agent/workspaces/{id}/skills/
└── {skill-name}/
    ├── SKILL.md
    ├── reference.md (opzionale)
    └── assets/ (opzionale)
```

Ogni workspace ha le proprie skills, indipendenti dagli altri.

---

## Quando creare una skill vs. un'automazione?

| Scenario | Skill | Automazione |
|----------|-------|-------------|
| Voglio istruzioni specializzate su un tema | ✅ | ❌ |
| Voglio un'azione automatica a un orario fisso | ❌ | ✅ |
| Voglio che l'agente sappia come gestire un task | ✅ | ❌ |
| Voglio reagire a un evento (label, stato) | ❌ | ✅ |
| Voglio pattern riutilizzabili in più sessioni | ✅ | ❌ |
| Voglio un reminder giornaliero | ❌ | ✅ |

**Regola generale:** skill = **come** fare qualcosa, automazione = **quando** farla.

---

## Best practices per scrivere una skill

1. **Frontmatter chiaro**: `name` e `description` descrittivi per far sì che l'agente la usi al momento giusto
2. **Istruzioni step-by-step**: l'agente segue meglio liste numeriche
3. **Esempi concreti**: includi esempi "prima/dopo"
4. **Trigger chiari**: spiega quando la skill dovrebbe essere attivata
5. **Mantienila focalizzata**: una skill = un compito
6. **Usa file di supporto**: se serve più contesto, aggiungi file `.md` aggiuntivi nella directory della skill

**Esempio di frontmatter efficace:**
```yaml
---
name: api-design-review
description: >
  Review di API design. Attiva quando chiedo di revieware
  uno schema OpenAPI, endpoint REST, o specifica GraphQL.
  Include controlli di naming, consistenza, error handling.
---
```

---

**Vedi anche**:
- [Automations Guide](automations.md) — quando usare skill vs automazione
- [Tips & Tricks](tips-and-tricks.md) — creazione rapida skills
- [Troubleshooting](troubleshooting.md) — skill che non funzionano
- [Quickstart](quickstart.md) — importare skills da Claude Code
