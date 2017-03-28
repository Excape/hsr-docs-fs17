# Interne Ebene
## Heap
- Eine DB-Tabelle wird in einem Heap (Collection) von Data Pages gespeichert
- Jede Data-Page hat eine fixe Grösse, meist 8KB
- Die Rows darin sind nicht sortiert

## Table Scan
- Scanning aller Pages einer Tabelle durch alle Rows
- Extrahiere Rows, die Query-Bedinung erfüllen
- Meist langsame Operation, soll durch Indexe verbessert werden
- Wenn aber Resultatset 80% der Tabelle enthält, ist der Table Scan schneller als der Zugriff über ein Index

## Indexe
- Dienen der Beschleunigung der Suche
- Braucht zusätzlich Speicher-Overhead

### B-Trees
- "Balanced Trees"
- Eignet sich für Equality-Search (Filtern nach Gleichheitsbedigung) und Range-Search (Suchen in Wertebereich)
- "B+-Baum" hat Daten nur in Blättern
- Durch ausbalancierter Baum \(O(log(n))\) Zugriffe
- Ein Knoten hat die Grösse einer Page
- Visualisierung: <https://www.cs.usfca.edu/~galles/visualization/BTree.html>
- In einem *clustered Index* enthalten die Blätter selbst die Daten-Rows
- In einem *unclustered Index* halten die Blätter nur Referenzen auf die Rows im Heap

### Hash-Index
- Speichert Key-Value-pairs aufgrund einer Hash-funkion (wie hashmap)
- Performance-Einbussen bei gleichen Hashes (gibt "overflow chain" - linked-List der Rows mit den gleichen hashes)

### Bitmap Index
- Speichert Attribute als Bitmuster
- Nur geeignet, wenn Werte in Attribute kleinen Wertebereich haben (und diskret sind)
- Wenn z.B. in einem Attribut immer nur die gleichen 2 Werte vorkommen, kann dies mit 1 Bit indexiert werden
- Schnelle Abfragen mit ORs / ANDs

### Indexe erstellen
- convention (nicht standardisiert):
```sql
CREATE INDEX <IndexName>
ON <Table(attr)>;
```
- Auf PK-Attributen werden automatisch Indices erstellt

## Kosten-Abschätzung
!!! note
    TODO

## Query Processing
- Eine Query wird geparst in einen Query-Tree
- Vom Optimizer wird optimierter Ausführungsplan erstellt
- *Point Query*: Suche Row mit bestimmten Wert, z.B. `where id = 1024 `
- *Multipoint Query*: Suche mehrere Rows mit bestimmten Wert, z.B. `where balance = 1000`
- *Range Query*: Suche in einer Range, z.B. `where income between 100 and 1000`
- *Order Query*: Query mit `order by`
- Interpretation Postgres
    - Index wird nicht immer verwendet, vor allem wenn alle Rows durchgegangen werden (z.B. `count(*)`)
    - Einfacher Select ist mit Index ca. 3-10x schneller
