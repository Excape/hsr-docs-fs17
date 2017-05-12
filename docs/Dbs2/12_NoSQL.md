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


## Column-Family Stores
- Daten mit Key-Value-Mappings
- Values sind gruppiert in mehrere Column Families, in einer Family werden Daten zusammengefasst, die oft zusammen benutzt werden
- Eine Column Family besteht aus einem Key-Value-Pair, wobei der Key ein name ist und der "Value" ein Set von Columns
- Analog zu RDBMS ist eine Column Family eine Tabelle und jedes Key-Value Tupel eine Row

### Cassandra
- Im Cassandra ist eine Column ein Key-Value-Pair mit einem Wert als Value
- Eine Row ist ein Pair von einem Namen und ein Set von Columns
- Eine Column Family ist ein Pair von einem Namen und ein Set von Rows
- Bei Replication gibt es keinen Master, alle Nodes sind peers
- Partitioning: Mit einem Hash-Algorithmus werden die DAten auf die Nodes verteilt
    - Jeder Node weiss, welche Hash-Ranges zu welchem Node im Cluster gehören
- Mit dem "Gossip" Protokoll tauschen die Nodes unterneinander ihren Zustand aus
    - Der Status des Clusters mit N Nodes ist in \(O(log(N))\) Runden bekannt
    - Alle T sekunden sendet ein Node seine Liste zu einem anderen Node im Cluster
- Query Syntax ist ähnlich zu SQL
- Use Cases: Event Logging, CMS, Blogs

## Graph-Datenbanken
- Daten werden über Nodes und Relationships definiert
    - Beide können Properties haben

### Neo4J
- Java basierte Graph-DB, z.B. von Facebook verwendet

#### Cypher Query Syntax
- Deklarativ

```
MATCH (john {name: 'John'})-[:firend]->()-[:friend]->(fof)
RETURN john.name, fof.name
```
#### Data Model
- Jede Node hat ein Label und ein Set von Properties
- Edges sind gerichtet, haben einen Namen (meist ein Verb) und ein Set von Properties

```
CREATE (alice:User {username:'Alice'}),
    (bob:User {username:'Bob'}),
    (charlie:User{username:'Charlie'}),
    (davina:User {username:'Davina'}),
    (edward:User {username:'Edward'}),
    (alice)-[:ALIAS_OF]->(bob)
```

## Map-Reduce
- `Map()` macht Filterung und Sortierung in "Queues", `Reduce()` aggregiert die Daten in einer Queue zu einem Ergebnis
- Die einzelnen Tasks werden möglichst parallelisiert / auf einem Cluster ausgeführt

### Beispiel MongoDB
- Ziel: Preise nach Kunden gruppieren
- Im SQL wäre dies ein einfaches `groupby`, aber beim Schemalosen MongoDB geht das nicht ohne weiteres
- `mapReduce()` nimmt eine Map und eine Reduce-Funktion als Argumente

```javascript
var emitCustPrice = function() {
    emit(this.cust_id, this.price);
};

var sumUp = function(custId, prices) {
    return Array.sum(prices);
};

db.orders.mapReduce(
    emitCustPrice, sumUp,
    {out: "PurchasesPerCustomer" }
);
```


## Polygot Persistence
- Verschiedene Datenbank-Ansätze lösen verschiedene Probleme
- Man kann nicht alle Bedürfnisse für Geschwindigkeit, Verfügbarkeit, Konsistenz, Replication etc. mit einem DB-System erfüllen
- Traditionell wurde für alles RDBMS verwendet
- mit dem "Polygot"-Ansatz werden für verschiedene Probleme in einem System verschiedene Datenbanken verwendet
    - z.B. RDBMS für Bestellungen, Key-Value-Stores für Session-Informationen, Graph-Datenbanken für Kunden-Beziehungen, etc.
