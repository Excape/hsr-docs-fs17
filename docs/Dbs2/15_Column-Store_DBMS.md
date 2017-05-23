# Column-Store Database System

## Row vs. Column Store
- Im Gegensatz zu Row-Stores werden bei Column-Store die Daten Spalte für Spalte abgelegt
- Motivation: Tabellen mit vielen Spalten, queries selektieren meist nur einige Attribute. Dann ist query-store I/O effizienter
- Nachteil: Daten schreiben ist langsam
- Da gleiche Daten zusammen in einer Spalte sind, ist Compression und Bitmap Encoding effizienter
    - Vor allem, wenn Datenbereich klein ist

## Materialization
- Das Erstellen der Tupel aus den Columns während einer Query

### Early Materialization
- Gleich zu Beginn Columns lesen und zu Tuples zusammensetzen
- Noch *bevor* einer Filterung (`WHERE`)
- Es müssen alle Tuples zusammengesetzt werden, braucht viel Memory
- Langsam für Filter, Aggregationen, etc.
- Aber schneller als Late Materialization bei *Joins*

### Late Materialization
- Möglichst lange warten, bis Tupel zusammengesetzt werden
- Filter werden auf der entsprechenden Columns angewendet
- Erst ganz am Schluss werden die Tupels zusammen gesetzt
- Schnell für Queries ohne Joins

## Invisible Joins
!!! note
    TODO

## C-Store Architecture

## In-Memory Data Warehouse
- Ziel: Möglichst wenig I/O, nur die nötigsten Daten laden
