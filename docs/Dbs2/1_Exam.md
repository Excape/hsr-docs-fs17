# Exam Notes

## Umfang
### Fokus
- OR-Mapping
- Stored Procedures, Cursors, Triggers
- Interne Ebene
- Verteilte DB / Replikation

## Inhalt
### JPA
- Queries schreiben
- Referentielle Integrität (selbst programmieren!)

### Stored Procedures
- Nachteil: Nicht portabel
- Cursors!

### Triggers
- Row- vs Statement-Trigger
    - Statement triggert per Statement
    - Row-Trigger triggert per veränderte Row (auch in einem Statement)
- Zugriff in SP mit `OLD` und `NEW`
- Concatinate mit `||`
- `RETURN NULL` bei After-Trigger (Return wird ignoriert)

### Arrays Graph Trees
- Arrays in PostgreSQL
- Trees
    - Adjadenzliste
    - Nested Set
        - Beim Absteigen im Baum die linked Indices vergeben, beim Zurückgehen die rechten
