# Replikation

## Anwendungen
- Load-Balancing
    - Cluster, schnelle Verbindungen
- Distributed geographic Data processing
    - auf verschiedene Standorte verteilt Peer-to-Peer
    - Mittelschnelle Verbindung, hohe Verfügbarkeit
- Real Time OLAP
    - (Online Analytical Processing)
    - Replikation auf einen Slave, z.B. als Data Warehouse
- Warm Standby
    - Master-Slave
    - Schnelle, hochverfügbare Verbindung
- Mobile Datenbanken
    - Bei jedem Client liegt eine Kopie der nötigen Daten, die mit dem zentralen "Master" repliziert werden
    - Clients können auch offline sein oder langsame Verbindungen haben

## Motivation
- Hohe Verfügarkeit durch Verteilung auf mehrere Nodes
- Niedrige Kommunikationskosten
- Lastverteilung, dadurch skalierbar
- Vorbeugung gegen Datenverlust
- Client können disconnected sein (Mobile Databases)

## Korrektheit
- Leser sollten eine möglichst konsistente Kopie der Daten erhalten
- *Weak Consistency*: Version, die der Leser erhält, muss nicht die aktuellste sein
    - Gibt evtl. parallele Änderungen, Konflikt-Behebung nachträglich
    - Asynchrone Replikation
    - Hohe Performance
    - Hohe Verfügbarkeit (wenig overhead) und Fehlertoleranz
- *Strong Consistency*: Jeder Zugriff liefert neustes transaktionskonsistente Version der Daten
    - Synchrone Replikation
    - Benutzt das 2PC-Protokoll, dadurch grosser Overhead
    - Weniger Fehlertoleranz und Verfügbarkeit

## Replikationsarten
### Master Slave
- Updates geschehen immer auf dem Primary Node
- Alle Updates werden zu Read-only-Subscribers (Slaves) propagiert
- Ausfall eines Knotens führt zum Ausfall des ganzen Systems!!

#### Synchrone Replikation (eager)
- Wenn auf Master eine Transaktion ausgeführt wird, wird sie sofort mit 2PC zu den Slaves repliziert
- Die Daten werden repliziert, **bevor** das OK zurück zur Applikation geschickt wird
- So sind die Daten immer konsistent

#### Asynchrone Replikation (lazy)
- Die Transaktion wird zuerst vom Master abgeschlossen
- Erst anschliessend werden die Slaves asynchron aktualisiert
- Dadurch können Konflikte auftreten
- Höhere Verfügbarkeit
- Änderungen bei Master werden effizienterweise im Log-File erkannt und Änderungen daraus abgeleitet
    - Alternative: Jedes Update feuert einen Trigger auf dem Master

### Multi-Master
- Jeder Master kann Update-Operationen ausführen
- Komplexe Synchronisation, asynchrone Replikation
- Konflikte, wenn parallele Änderungen an verschiedenen Nodes ausgeführt werden
- Typische Anwendung in HPC

#### Synchronisationsprotokolle
- *Read-One, Write-All*: Schreibzugriffe werden synchron repliziert, Lesezugriffe asynchron
- *Majority Protocol*: Lesen und Schreiben verlangt Locks auf einer *Mehrheit* der Replikaten
    - Jedes Replikat kann ein Write-Lock und mehrere Read-Locks haben
    - Braucht mehr als 2 Knoten
- *Quorum Consesus Protocol*
    - Verallgemeinerung vom Majority Protocol
    - Jede Kopie enthält bestimmte Anzahl von Stimmen
    - Lesen und Schreiben erfordert je eine bestimmte Anzahl Stimmen
- *Snapshot-Replikation*: Einfacheres Verfahren mit schwächeren Konsistenzanforderungen
- *Merge Replikation*: Unsychronisierte Änderungen an mehreren Knoten, mit asynchroner Prograpierung der Änderungen
    - Benötigt für disconnected clients
    - Nachträgliche Konfliktbehandlung

## MongoDB
!!! note
    TODO


### Sharding
- Horizontale Skalierung, also Verteilung der Daten auf mehrere Nodes
- Collections werden in Shards aufgeteilt, z.B. nach Wertebereich des Keys oder mit einer Hash-Funktion
    - Dabei ist ein document immer vollständig in einem Shard
- Requests werden von `mongos`, einem Query-Router, zum richtigen Shard geleitet
- Der Query-Router entscheidet mit Hilfe von Config servers, wo welche Daten liegen
