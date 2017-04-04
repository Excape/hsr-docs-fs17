# Joins / Anfrageoptimierung

## Joins

### Hash Join
- Für die kleinere Tabelle des Joins wird eine in-memory Hash-Table gebaut
    - Wenn die Tabelle nicht im Memory Platz hat, wird sie aufgeteilt in "buckets"
    - Die kleinere Tabelle ist hier die "Driving Table"
- Für den Join wird für jeder Eintrag der grösseren Tabelle die Hash-Table abgefragt

### Nested Loop Join
- Geeignet für kleine Relationen
- In der einfachen Variante wird einfach über beide Tabellen geloopt, wobei die kleinere der "äussere" Loop ist

```
for (i = 0; i < length(outer); i++)
    for (j = 0; j < length(inner); j++)
        if (outer[i] == inner[j])
            output(outer[i], inner[j]);
```

#### Block based Nested-Loop Join
- Optimierte Version des Nested Loop Joins
- Relationen werden nicht direkt row-by-row verglichen, sondern in Blöcken
- In jedem Blockvergleich wird wieder gleich wie oben Row-by-row verglichen
- Weitere Optimierung, wenn Indexe verwendet werden

### Sort-Merge Join
- Beide Relationen werden auf der Join-Column sortiert
- Durch die äussere Relation (kleinere) wird 1x iteriert
- TODO: Algorithmus verstehen

### Wahl des Join Algorithmus
- Falls kein Index existiert: In der Regel Hash Join
- Mit Index ist ein Nested Loop schneller bei FK-Joins
- Möglichst Indexe verwenden, vor allem für grosse Tabellen

## Anfrage Optimierung
### Logische Optimierung
- Umformung des Anfrageterms aufgrund von Heuristiken
- Nimmt keine Rücksicht auf das interne Schema oder die Grösse der Relationen
- in der ersten Phase wird die Query in relationale Algebra übersetzt
- Selektionen so früh wie möglich, um Resultatmenge zu verringern
    - z.B. Filter auf eine Tabelle vor dem Join anwenden
- Basisoperationen ohne Zwischenspeicherung als einen Schritt ausführen
- Zusammenfassen gleicher Teilausdrücke für Wiederverwendung von Zwischenergebnissen

### Physische Optimierung
- Erzeugung von Ausführungsplänen

#### Kostenbasierte Optimierung
- Generiere *alle* denkbaren Ausführungspläne
- Bewerte diese durch Kosten und führe den "billigsten" Plan aus
- Kosten werden berechnet aus Menge der zu übertragenen Daten, Berechnungskosten, I/O-Kosten und Speicherungskosten (temporäre Speicherbelegung)

#### Statistiken
- Informationen über Relationen und Indexe werden aus dem System-Katalog gelesen
- z.B. Kardinalität, Anzahl Pages, Index-Grösse, etc.

#### Selektivität
- Es wird abgeschätzt, wieviele Rows der Gesamtmenge die Condition für die Filterung erfüllen
- Höhere Selektivität = Mehr wird rausgefiltert
- Optimizer nimmt für hohe Selektivität eher Index, für tiefe Selektivität Table Scan

### Dichte
- Durchschnittlicher prozentualer Anteil von Duplikaten
- als Funktion: Anzahl eindeutige Werte / Anzahl Tupels
- Hohe Dichte -> Viele Duplikate

## Best Practices
- Nur Indexe erstellen, die oft verwendet werden
- Indexe auf Primär-, Fremdschlüssel und Attribute, auf denen häufig Queries ausgeführt werden

!!! info
    TODO: SARG-able Queries
