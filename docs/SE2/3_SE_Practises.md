# Software Engineering Practices

## Requirements Practises
### Dig for Requirements
- Mit dem Kunden zusammen arbeiten
- Denken aus Benutzersicht
- "Wünsche" von echten Anforderungen trennen
    - Gründe hinterfragen
- Genügend abstrakt definieren, Details können schnell ändern
    - Wenn zu genau spezifiziert, werden sie genau so implementiert und sind nicht erweiterbar

### Make Quality a Requirement
- Qualität als NF-Anforderungen
- Möglichst testbar machen
- Basierend auf echten Anforderungen von Benuzter-Bedürfnissen
- Sind schwieriger zu ermitteln, oft unter-/un- bewusst
- Ermittlungstechniken
    - Checklisten (Brainstorming)
    - Befragen, Beobachten
- Grosser Einfluss auf Architekturentscheidungen
- evtl. Referenzsystem festlegen für Performance-Tests

### Deal with Changes
- Es gibt keine "stabilen" Requirements
- Möglichst flexibles Design

## Design Practises

### DRY
- Code-Redundanz ist schlecht, nicht wartbar
- Auch in Code-Doku redundante Beschreibungen vermeiden

### Achieve Orthogonality
- "Eliminate effects between unrelated things"
- Keine Kopplung zwischen konzeptionell unabhängiger Konzepte
- Low Coupling / High Cohesion
- Architektur sollte keine Zyklen haben (DAG)
    - Sonst schwer auszutauschen
    - Keine Wiederverwendbarkeit
    - Nicht sauber testbar

### Design to Test
- Vor Entwicklungszeit betrachten, da es Architetktur beeinflusst

## Implementation Practises
### Fix broken Windows
- "Broken Window Syndrom": Wenn Probleme nicht behoben werden, bleiben sie bestehen
- Probleme beheben, wenn sie entstehen
- Refactoring / Code Reviews

### Refactor early and often
- Refactoring als Prozess definieren
- Gute Tests for Refactoring haben, um nicht Fehler einzubauen

### Program Deliberately
- Nicht auf "gut Glück" programmieren
- Spezifikation lesen (vor allem bei Paral. Progr.)

## Verification Practises
### Test rigorously
- früh, häufig, automatisch testen
- "Find Issues Once": Für gefundene Fehler Tests schreiben
- Integration Tests genauso wichtig wie Unit Tests

### Perform Reviews
