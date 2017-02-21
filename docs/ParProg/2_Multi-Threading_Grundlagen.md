# Multi-Threading Grundlagen

## Motivation
- Reale Prozesse abbilden (Druckjobs, Server-Client)
- Perfromance-Steigerung
- Seit 2003 stagnieren Taktraten, stattdessen wird mehr auf Hyperthreading und mehrere Kerne gesetzt. Deshalb müssen Programme darauf optimiert werden

- Hyperthreading (Virtual Threading): Ein CPU-Core hat zwei Register-Sets, aber immer noch nur ein Rechenwerk (ALU)
    - Ist nicht "echte" Parallelisierung

## Parallelität vs. Nebenläufigkeit
- **Parallelität**:  Zerlegung eines Ablaufs in mehrere Teilabläufe, welche gleichzeitig auf mehreren Prozessoren laufen
- **Nebenläufigkeit** (Concurrency): Gleichzeitig oder verzahnt ausführbare Abläufe, welche auf gemeinsame Ressourcen zugreifen.
    - Älteres Prinzip, z.B. Drucker
    - Kann anschein von Parallelität haben, aber es wird immer nur etwas auf einmal ausgeführt

---
## System Grundlagen Repetition
### Threads
- Parallele Ablaufsequenz innerhalb eines Programms, teilen den Adressraum mit dem ganzen Prozess
- Ist günstiger als eigener Prozess, braucht keine eigene Pagetable
- Jeder Thread hat eigenen Stack
- User-Level-Thread: Im Prozess implementiert, keine echte Parallelität durch mehrere Prozessoren
- Kernel-Level-Thread: Im Kernel implementiert, kann Multi-Core ausnutzen. Wechsel per SW-Interrupt, ist also nicht ganz "gratis"
- Scheduling: Ein CPU-Core kann immer nur ein Thread gleichzeitig ausführen. Scheduler teilt die Threads zu
- Wenn nur ein Prozessor Threads verarbeitet, ist es eine Quasi-Parallelisierung
- Programmierung hat für "echte" oder "quasi"-Parallelität die gleichen Probleme, weil man nie weiss, wann die Kontextwechsel geschehen

- Kontextwechsel
    - **Synchron**: Thread wartet auf Bedingung, gibt den Prozessor selbst frei
    - **Asynchron**: Nach gewisser Zeit wird der Thread gewzungen, die CPU freizugeben
- Multi-Tasking
    - **Kooperativ**: Threads müssen explizit synchrone Kontextwechsel initiieren
    - **Preemptive**: Scheduler unterbricht den Thread *asynchron* in gewissen Zeitintervallen
    - Heute in der Regel immer *preemptive*!

!!! note
    Todo: Bild Folie 30
    
## Grundlagen Java Threads
- JVM ist ein Single Process System
- Main-Thread führt die `main()`-Methode aus (per Reflection)
- Programmierer kann weitere Threads starten
- Laufzeitsystem startet auch eigene Threads, z.B. GC
- Die JVM läuft solange, bis kein (nicht-Daemon-) Thread mehr läuft
    - Daemon-Thread ist z.B. GC, wird bei Ende der JVM unkontrolliert beendet

```java
class SimpleThread extends Thread {
    @Override
    public void run() {
        // thread behavior

        // thread ends when run() exits 
        // (or unhandled exception orccurs)
    }
}
Thread myThread = new SimpleThread();
myThread.start();
```

- Wenn unbehandelte Exception in Thread auftritt, laufen andere Threads weiter (in Java, andere Umgebungen anders)
- Threads laufen ohne Vorkehrungen beliebig verzahnt, **nicht-deterministischer Ablauf!**

Runnable Implementierung statt Vererbung:
```java
class SimpleLogic implements Runnable {
    @Override
    public void run() {
        // thread behavior
    }
}
// Pass Runnable to Thread constructor!
Thread myThread = new Thread(new SimpleLogic());
myThread.start();
```
- `Runnable`-Interface hat 1 Methode -> Functional Interface!
    - Kann mit Lambdas verwendet werden
```java
Thread myThread = new Thread(() -> {
    // thread behavior
});
myThread.start();
```
- Mit `Thread.sleep(t[ms])` kann der Thread schlafen gelegt werden
- `Thread.yield()` gibt Thread frei, aber wird gleich wieder *ready*. Provoziert Thread-Wechsel
    - Sollte man nicht verwenden, weil OS das Scheduling selbst verwaltet
- `t.join()` wartet solange, bis der Thread `t` terminiert

```java
Thread myThread = new Thread(() -> {
    // thread behavior
});
myThread.start();
// Thread started
myThread.join();
// Thread finished
```
- Threads können von Aussen unterbrochen werden mit `t.interrupt()`
    - Löst `InterruptedException` aus
    - Wird meist missbraucht zum Aufbrechen von Blockaden (schlecht!)
