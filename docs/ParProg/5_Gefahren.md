# Gefahren der Nebenläufigkeit

## Race Condition
> Ungenügend synchronisierte Zugriffe auf gemeinsame Ressourcen

- Je nach Thread-Verzahnung und Timing unterschiedliche Ergebnisse
- Oft ist die Ursache ein *Data Race*
- Es gibt auch Race Conditions ohne Data Race
- oder Data Race ohne Race Condition
    - Programm funktioniert dann zwar, ist aber formal falsch

### Data Race
- Mehrere Threads greifen auf selben Speicher (Var, Array, ...) zu
- Mindestens ein Write-Zugriff von einem Thread ist involviert
- Ist ein formaler Fehler: Einfacher zu erkennen als generelle Race Condition (z.B. nicht-atomare Operationen)

## Synchronisation
### Verzichtbare Fälle
- Wenn Objekte nur gelesen werden (immutable Objects)
- Confinement: Object gehört zu einer Zeit nur einem Thread
    - *Thread Confinement*: Objekt lebt nur bei einem Thread ("privat")
    - *Object Confinement*: Einkapsung in synchronisiertes Objekt, Zugriff auf Objekt nur mit synchronisierten Methoden

#### Thread Confinement
``` java
new Thread(() -> {
    OutputStream output = new FileOutputStream();
    try {
        doService(output);
    } finally {
        output.close();
    }
}).start();
```
#### Kapselungsbrüche
- Inneres Objekt von aussen zugreifbar
- Rückgabe auf Referenz eines inneren Objekts
- Eine innere Referenz wird irgendwo rein "installiert", z.B. in eine Liste, die per Parameter mitgegeben wird
- Inneres Objekt gibt selber `this` raus

### Thread-Safety
- Keine klare Definition
- Heisst Klassen und Methoden, die für sich intern synchronisiert sind
- Keine Synchronisierung über mehrere Methoden -> Race Conditions immer noch möglich
- Immer Spezifikation prüfen, was thread-safe ist
- Synchronisation reicht nicht immer, Iteration ist z.B. nicht synchronisiert

#### Java Collections
- Alte Collections `Vector`, `Stack` und `Hashtable` sind thread-safe
- Moderne Collections nicht! (`HashSet`, `ArrayList`, `HashMap`, ...)
    - Grund: Synchronisation ist teuer! Thread-Safety wird meist nicht benötigt
- Eigene `ConcurrentCollections` sind thread-safe: `ConcurrentHashMap`, `ConcurrentLinkedQueue`, ...
- Iteration ist "schwach konsistent": Es gibt keine Garantie, dass alle Updates gelesen werden

## Deadlocks
> Gegenseitiges Aussperren von Threads
- Einige Threads sperren sich gegenseitig so, dass keiner von denen weitermachen kann
- Vorsicht vor impliziten nested Locks! Wenn z.B. eine synchronisierte Methode eine andere synchronisierte Methode aufruft
- Programm mit potentiellem Deadlock ist inkorrekt
- *Livelocks*: Deadlocks, die ständig eine Bedingung prüfen, also weiterhin CPU verbrauchen

### Deadlocks erkennen
- Wenn Deadlock eingetreten ist, gibt es im Betriebsmittelgraph (Holt-Diagrams, Bsys1) einen Zyklus
- Für einen Deadlock müssen **alle 4 Voraussetzungen erfüllt sein**
    - **Nested Locks**
    - **Zyklische Warteabhängigkeiten**
    - Gegenseitiger Ausschluss (Locks)
    - Sperren ohne Timeout / Abbruch

## Deadlocks vermeiden
- Ziel: Einer der vier Voraussetzungen verhindern
- Die geschachtelten Ressourcen nur in aufsteigender Reihenfolge reservieren (locken)
    - Verhindert zyklische Warteabhängigkeiten
- Grobgranulare Locks wählen
    - z.B. "ganze Bank sperren bei Kontozugriff"
    - Verhindert geschachtelte Locks
    - Ist aber evtl. sehr ineffizient

## Starvation
> Kontinuierliche Fortschrittsbehinderung von Threads wegen Fairness-Probleme
- Es gibt kein Deadlock, die ressource wird immer frei, aber der wartende Thread wird ständig von anderen Threads überholt und die Bedingung wird nie erfüllt
- Liveness Problem: Threads werden für unbestimmte Zeit aufgehalten, aber nicht unendlich lange
- Java-Monitor ist Starvation-Anfällig, weil es keine Fairness gibt
- Vermeidung: Fairness einbauen, z.B. bei Java Semaphoren. Länger wartende Threads haben Vortritt

## Erkennung / Vermeidung

## Design Aspekte
