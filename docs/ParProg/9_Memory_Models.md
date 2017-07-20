# Memory Models
## Quiz letzte Vorlesung
- `InvalidOperationException`, wenn während dem Download ein Element in die Collection eingefügt wird
- `await` haltet die Schleife an und kann den Thread wechseln. Währenddessen kann das UI die Collection ändern

## Ziel
- Korrekte nebenläufige Interaktion
- Garantien des Speichermodell nutzen
- Effiziente Synchronisation, skalierbar

## Probleme
- Umordnung: Optimizer kann Code-Ablauf nicht-deterministisch ändern, wenn zwei Statements unabhängig voneinander sind ("Weak Consistency")
- Keine sequentielle Konsistenz bei Nebenläufigkeit

## Java Memory Model
    
### Atomicity
- Unteilbarkeit
- Garantiert einzelnes atomares Lesen und Schreiben für Primitive Datentypen (bis 32 Bit), Objekt-Referenzen und `volatile` long und double
- Unteilbarkeit heisst nicht Sichtbarkeit: Nach einem Write kann ein Thread noch den alten Wert sehen  

### Visibility
- Wenn ein Thread eine Variable setzt, ist es nicht garantiert, dass ein anderer den neuen Wert sieht
- Kann nicht-deterministisch nach gewisser Zeit oder gar nie sichtbar werden
- Optimizer lädt evtl. Variable in ein Register, dass dann gar nie geupdated wird
    - Optimizer beachtet nur die Ausführung in einem Thread

### Garantien
- Sichtbar bei Locks (sonst würde das ganze Lock-System nicht funktionieren)
- `volatile` Variablen sind für andere Zugreifer immer sichtbar
    - Vor dem `volatile`-Zugriff werden alle Änderungen(auch von nicht-volatile-Variablen!) für andere sichtbar, die auch auf diese Variable zugreifen 
    - Besser explizite Synchronisation einsetzen
    - Ordnung ist vor und nach dem volatile-Zugriff garantiert, wie ein "Memory-Fence"
- `final`-Variablen nach Initialisierung im Constructor: "Initialized State" ist sichtbar
- Thread-Start / Join, bzw. Task Start und Ende

### Ordering
- Innerhalb eines Threads wird alles sequentiell ausgeführt
- Zwischen Threads ist die Reihenfolge nur erhalten für Synchronisationsbefehle und Zugriff auf volatile-Varialben
- "Memory Fence": Keine Umordnung über Synchronisation oder Volatile-Zugriffe hinweg

### Atomare Operationen
- Effiziente, atomare Instruktion des Prozessors
- Komplexer als Lesen / Schreiben

#### Atomic Boolean
- Kann mit `getAndSet()` atomar alten Wert lesen und neuen Wert setzen
- `compareAndSet()`: Atomares lesen und setzen mit Condition
    - Wenn Variable expected Wert hat, wird neuer Wert gesezt und `true` returned
- Atomic Klassen gibt es auch für Integer, Long und Referenzen

#### Optimisitsche Synchronisation
- In einer Schleife wird versucht, den Wert zu aktualisieren
- alten Wert zwischenspeichern und versuchen zu Updaten, bis der Wert nicht nicht zwischendrin verändert wurde
- Nachteile: 
    - Theoretische Starvation-Möglichkeit
    - Zwischenänderungen werden nicht erkannt (ABA-Problem)
- Concurrent Lockfreie Datenstrukturen sind meistens so implementiert

## .NET
### Volatile Read / Write
- Volatile Read: Bleibt garantiert **vor** den nachfolgenden Zugriffen
- Volatile Write: Bleibt garantiert **nach** den vorherigen Zugriffen
- `Thread.MemoryBarrier()` verhindert umordnung
