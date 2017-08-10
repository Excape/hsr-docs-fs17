# Exam Notes

## ToDo
- Stored Procedures schreiben können
    - inkl. explizite cursor
- Datenstrukturen abbilden können
- MongoDB Queries schreiben können / Datenmodelle erstellen
- Cassandra
- Query-Ausführung
- I/O Kosten berechnen
- Synchronisationsprotokolle


## Umfang
### Fokus
- OR-Mapping
- Stored Procedures, Cursors, Triggers
- Interne Ebene
- Verteilte DB / Replikation

### Ausgeschlossene Themen!
- Objektrelationale DB
- Objektorientierte DB
- In-Memory / Column Store DBMS

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

### NoSQL
- Cassandra Datenmodell
- MongoDB Modellierung / Queries

### Arrays Graph Trees
- Arrays in PostgreSQL
- Trees
    - Adjadenzliste
    - Nested Set
        - Beim Absteigen im Baum die linked Indices vergeben, beim Zurückgehen die rechten
