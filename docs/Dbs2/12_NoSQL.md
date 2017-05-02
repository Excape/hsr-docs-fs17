# NoSQL
## Definition
- Keine klare Definition
- "Not only SQL", "new SQL"
- Einfaches API, horizontal gut skalierbar

## CAP and BASE
- Klassische Systeme sind fokussiert auf ACID Eigenschaften
- "Moderne" Systeme konzentrieren sich auf BASE
    - "Basically available": Jeder Request wird beantwortet, es kann aber auch eine Fehlermeldung sein, oder die Daten können inkonsistent sein
    - Scalable
    - "Eventually Consistent": Nach dem Updaten werden die Daten irgendwann überall repliziert sein

## CAP Theorem
- In einem verteilten System muss man sich zwischen *Consitency* und *Availability* entscheiden
- **Consistency**: Alle Clients haben dieselben Daten, braucht atomarität, transaction isolation
- **Availability**: Jeder Request wird beantwortet
- **Partition Tolerance**: Das System darf nur inkorrekt antworten, wenn es komplett ausfällt
- **CAP Theorem**: Alle drei Kriterien zu erfüllen, ist *unmöglich*

## Key-Value Database
- Hash-Table, die nur mit key ansprechbar ist
- z.B. Redis, Memcached
- Keys werden gruppiert zu "Buckets"
    - Normalerweise wird in einem Bucket nur Values mit gleichem Typ gespeichert, ("domain bucket")
- "Eventually consistent" in verteilten Systemen
- Anwendungen: Session-Informationen, User Profiles, Shopping Cart Data
- Nicht geeignet für Beziehungen zwischen Daten

## Document Databases
- Mapped einen Key zu einem Document
- Ein Document ist meist ein JSON (oder BSON) Objekt
- z.B. MongoDB, CouchDB
- Documents werden in Collections (analog Tables) gespeichert
- Documents müssen kein festes Schema haben

## Modeling Herausforderungen
- Embedded Relationships: Beziehungen werden eingebettet, dies verursacht Redundanz (*Denormalisierung*)
- Referencing: Beziehungen werden über Referenzen aufgelöst. In MongoDB wird die Object-ID als "Fremdschlüssel" verwendet
    - Nachteil: Aufwändige Joins, muss von Hand gemacht werden
- Ansatz: Daten so modellieren, dass zusammengehörende Daten in ein einziges Document geschrieben werden
    - Bsp. Blogpost: Ein Blogpost wird immer als ganzes geladen. Der Text, Autor und die Kommentare kommen also in ein einziges Document

## MongoDB
### Replica Set
- Es wird ein Primary Node anhand der Priorität oder Rechenpower ausgewählt
- Alle Requests gehen durch den Primary Node
- Wenn der Primary Node ausfällt, machen die anderen Nodes aus, wer den Primary übernimmt

#### Consistency
- Ein Replica Set sieht eine Write-Operation als komplett an, wenn eine Mehrheit der Nodes diese geschrieben hat
- Read Concern
    - Local (default): Es wird einfach die neuste Daten der beantworteten Instanz gelesen
    - Majority: Daten werden *von der beantwortenden Instanz* gelesen, die von einer Mehrheit der Nodes bestätigt worden ist
    - Linearizable: Returnierende Daten sind garantiert die neusten, die von einer Mehrheit der Nodes akzeptiert worden ist ("Majority" hingegen gilt nur auf lokaler Instanz)
