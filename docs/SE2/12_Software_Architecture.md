# Software Architecture III
- Definiton: "Beschreibung der einzelnen Komponenten eines Systems und deren Beziehungen untereinander"

## Context Diagramm
- Wo steht das System in seinem Umfeld?
- Was sind Schnittstellen zu Umsystemen?

## Multi-Prozess-Architektur
- Stateful-Prozesse sind schwierig wieder aufzusetzen nach einem Ausfall
- Möglichst stateless-Prozesse bauen

## Architecture Refactoring
- als letzten Schritt partitionieren
    - strukturierter
    - Einfachere Fehlersuche: Man muss nur in der gleichen Partition suchen
    - Besser testbar
    - Evtl. skalierbar durch Verteilung auf mehrere Tiers
