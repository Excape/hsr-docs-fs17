# Weitere Synchronisationsprimitiven
!!! note
    Quiz letzte Vorlesung: `notify()` reicht, da nur auf eine Bedingung gewartet wird, und nur ein einziger Thread darf weiter machen (One-In/One-Out)

## Symaphor
- Von Dijkstra, kommt von Eisenbahn-Signalen
- Ist ein Zähler mit der Anzahl noch freier Ressourcen
- `acquire()`: Beziehe freie Ressource oder warte, Zähler dekrementieren
- `release()`: Ressource freigeben, Zähler inkrementieren
- Monitor-Nachbau ist nicht garantiert fair, weil `notify()` ein beliebiger Thread weckt
- Binäre Sempahore: `ǹew Semaphore(1)`, gegenseitiger Ausschluss
- Kann in Java auch negativ initialisiert werden (nicht bei .NET)
- Faire Semaphore: `new Sempahore(N, true)`
    - Benutzt FIFO-Warteschlange
    - Allerdings langsamer als "unfaire" Variante
- Anwendung BoundedBuffer:
    - Mit Semaphoren deutlich schneller als mit Monitor (ca. 3x)
    - Grund: `notifyAll()` fallen weg, es müssen nicht immer alle Threads aufgeweckt werden
    - "Faire" Variante ist etwa gleich schnell
## Lock & Condition
- Spezialfall des Monitors
- Verschiedene Wartelisten für mehrere Bedingungen
- Notify geht auf eine der "Warteräume"
- In Java unabhängig vom Java Monitor, muss selbst nachgebaut werden
- Auf einen Lock (analog `synchronized`) können mehrer Conditions definiert werden
- Lock kann "fair" sein

```java
private Lock monitor = new ReentrantLock(true);
private Condition nonFull = monitor.newCondition();
private Condition nonEmpty = monitor.newCondition();
```

```java
public void put(T item) throws InterruptedException {
    monitor.lock();
    try {
        while (queue.size() == Capacity) { 
            nonFull.await();
        }
        queue.add(item);
        nonEmpty.signal();
    } finally { monitor.unlock(); }
}
// Analog für get()
```
- `signal()` notifiziert ein beliebiger Thread für diese Condition, `signalAll()` alle
- Überholen ist weiterhin ein Problem, da die aufgeweckten Threads wieder in den "normalen" Warteraum kommen

## Read-Write Lock
- Erlaube parallele Lese-Zugriffe
- Schreibzugriffe mit gegenseitigem Ausschluss

```java
ReadWriteLock rwLock = new ReentrantReadWriteLock(true);
rwLock.readLock().lock();
// read-only accesses
rwLock.readLock().unlock();

rwLock.writeLock().lock();
// write (and read) accesses
rwLock.writeLock().unlock();
```
- Der WriteLock ist gleich wie der Lock bei Lock & Condition
## Count Down Latch
- Zeitlicher Synchronisationspunkt von mehreren Threads
- N Threads warten auf Control-Thread, Control-Thread wartet auf N Threads und gibt "Startsignal"

- Count Down Latch hat Zähler und wartet, bis er 0 wird
- Threads können Zähler dekrementieren mit `countDown()`

```java
CountDownLatch carsReady = new CountDownLatch(N);
CountDownLatch startSignal = new CountDownLatch(1);

// N Cars
carsReady.countDown();
startSignal.await();

// 1 RaceControl
carsReady.await();
startSignal.countDown();
```
- Geht auch mit Multi-Release/-Aquire Semaphore
- CountDown lässt sich nicht wieder hochsetzen

## Cyclic Barrier
- N Threads warten aufeinander
- `await()` blockiert, bis N Threads `await()` aufgerufen haben
- Kann wiederverwendet werden

```java
CyclicBarrier gameRound = new CyclicBarrier(N);

// Bei N Players:               
while (true) {
    gameRound.await();
    // play concurrently with others
}
// Mehrere Runden
```
- Wenn ein Thread im `await()` eine Exception wirft, ist die Barriere kaputt
- *Phaser*: Kann zusätzlich Teilnehmer im nachhinein an- und abmelden

## Exchanger
- "Rende-vouz": Barriere mit zwei Parteien und tauschen etwas aus
- `exchange(v) Blockiert, bis anderer Thread auch exchange() aufruft
- Liefert Argument x des jeweils anderen Threads
