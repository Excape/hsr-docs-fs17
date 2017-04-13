# Verteilte Datenbanksysteme

## VDBMS
- Ist ein Datenbanksystem verteilt über mehrere physische Knoten
- Ist Transparent gegen aussen, die Verteilung der Daten ist aus Sicht des Benutzers egal
- In einem **homogenen** System laufen alle Noten mit der gleichen Software und wissen voneinander, es erscheint gegenüber dem Benutzer als ein System
- In einem **heterogenen** System können auf den Knoten unterschiedliche Software und Schemas laufen, sie sind voneinander unabhängig, wissen also nichts voneinander. Dies macht das Verteilen von Daten und Transaktionen schwerer.

## Replikation
- Eine Relation (Tabelle) wird redundant auf mehreren Knoten gespeichert
- Dies bietet mehr Verfügbarkeit und Parallelität bei Ausführung von Queries
- Hat aber höhere Update-Kosten und komplexere Synchronisation, Änderungen können zu temporär inkonsistenten Daten führen

## Fragmentierung
- Jede Relation wird in Fragmente aufgeteilt
- **Horizontale Fragmentierung**: Jedes *Tupel* wird auf ein oder mehrere Fragmente aufgeteilt (Sharding). Dies kann z.B. nach einem Attribut der Relation gruppiert werden
- **Vertikale Fragmentierung**: Das Schemea der Relation ist in mehrere kleinere Schematas aufgeteilt. z.B. ist ein Tupel so verteilt auf mehrere Fragmente, die mit einem gemeinsamen Schlüssel verbunden werden

## Verteilte Transaktionen
- Problem: Transaktion ist immer lokal zu einer DB-Session
- In einem VDBMS muss im Hintergrund die Transaktion aber auf mehreren Nodes committed werden

### Two Phase Commit (2PC)
- Garantiert Atomarität von verteilten Transaktionen
- Die Transaktion zwischen DBMS und Applikation wird von einem *Transaction Manager* verwaltet
- Beim Commit-Befehl der Applikation zum *TM* fragt dieser zuerst alle Resourcen (Nodes) an, ob sie bereit zum commit sind (*prepare to commit*)
- Falls alle Resourcen bereit sind, sendet der TM allen den Befehl zum commit
- Wird während dem Commit der Commit von einer Resource abgebrochen, oder sie antwortet nicht rechtzeitig, sendet der TM einen Rollback-Befehl an *alle* Resourcen
- Haben die Resourcen einen Commit abgeschlossen, antworten sie mit einem *ACK*

- Der TM stellt so sicher, dass die Transaktion entweder von *allen* commited oder von allen rollbacked wird. Er muss auch mit allen Fehlersituationen der Serverkommunikation dazwischen umgehen können
- Das Protokoll muss auch mit einem Absturz des TM umgehen können
- Alle Schritte werden vom TM und den einzelnen Resource-Managers geloggt. So weiss das System nach einem Absturz, welche Aktionen noch durchgeführt werden konnten
- Resource Manager kann von alleine nicht entscheiden, wenn nach dem *ready* kein *commit* vom TM kommt. Er muss dann solange blockieren, bis er entweder *commit* oder *abort* erhält

- 2PC ist kein effizientes Protokoll, es ist relativ langsam und skaliert schlecht
- Allerdings wird es von fast allen Herstellern unterstützt

## 2-Phase-Locking
- Lokale Serialisierbarkeit einer Transaktion reicht bei VDBMS nicht aus, es braucht eine globale Serialisierbarkeit über alle Nodes
- Dafür wird 2-Phase-Locking auf verteilte Systeme adaptiert

### Globaler Lock-Manager
- Verwaltet Locks auf globaler Ebene über alle Nodes hinweg
- Transaktionen fragen beim Lock-Manager an, um Resourcen zu sperren
- Vorteil: Deadlock-Erkennung ist gleich wie im System mit einem Knoten
- Nachteile: 
    - Jede Sperr-Anfrage muss zuerst an den Knoten gesendet werden und die Antwort abwarten
    - Lock-Manager ist SPOF

### Lokaler Lock-Manager
- Verwaltet die Locks auf jedem Node einzeln für sich selbst
- wird über globalen Algorithmus gesteuert
- Vorteil: Arbeit ist verteilt und robuster gegen Ausfälle
- Nachteil: Schwierige Deadlock-Erkennung, Performance-Einbussen

## Timestamp-based Synchronisation
- Jede Transaktion bekommt einen Zeitstempel + Rechner-ID, was sie im System global Unique macht
- Dadurch wird die Serialisierungsreihenfolge einer Transaktion festgelegt bei Konfliktoperationen
- Transaktionen müssen alle Änderungen von älteren Zeitstempel sehen, aber keine von jüngeren
- Eine jüngere Transaktion darf nicht ein objekt verändert haben, das anschliessend von der älteren geschrieben wird
- Bei Verletzung der Regel wird ein Rollback gemacht

## Verteilte Deadlocks
### Erkennung
- Primitive Variante: Bei Timout wird Transaktion zurückgesetzt und erneut gestartet
    - Problem beim Wählen des Timeouts: Zu lang ist ineffizient, zu kurz gibt "false-positives" für Deadlocks
- Zentralisierte Erkennung: Stationen melden lokale Wartebeziehung an eine Station, die dann den globalen Wartegraphen aufbaut
    - Sichere Lösung, aber hoher Aufwand
    - Risiko von Phantom-Deadlocks - nicht existierende Deadlocks durch das "Überholen" von Nachrichtne in der Übertragung

### Vermeidung
- Optimistic Concurrency: Nach Abschluss der Transaktion wird Validierung durchgeführt
- Timestamp-based Synchronisation

## Distributed Query Processing
### Verteilte Anfragen
- Bei einem zentralen System werden die Kosten bestimmt durch Anzahl Disk I/O's
- Im verteilten System werden sie bestimmt durch Anzahl Netzwerk-I/O's und den Performancegewinn durch Parallelisierung
- Parallelisierung ist z.B. durch horizontale Fragmentierung möglich, indem Teilresultate durch Kriterien auf Knoten verteilt sind und anschliessend zusammen geführt werden

### Join-Strategien
- *Ship Whole*: Alle benötigten Relationen auf einen Knoten übertragen, der dann den Join ausführt
    - Wenig Nachrichten, hohes Datenvolumen
- *Fetch as needed*: Nur Join-Attribute an einen Knoten schicken, der den Join durchführt
    - Viele Nachrichten, niedriges Datenvolumen

#### Semi-Join
- Optimierung des *Fetch-as-needed* Ansatz
- Join-Attribute der ersten Relation werden zum Knoten der zweiten Relation geschickt
- Knoten der zweiten Relation schickt alle Tupels, die auf den Join matchen, zurück zum Knoten der ersten Relation, wo dann der Join erfolgt
