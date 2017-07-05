# Weitere Synchronisationsprimitiven
!!! note
    Quiz letzte Vorlesung: `notify()` reicht, da nur auf eine Bedingung gewartet wird, und nur ein einziger Thread darf weiter machen (One-In/One-Out)

## Semaphore
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
- Fairness spielt keine Rolle, da alle wartenden Threads "auf einmal" durchkommen
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
- CountDown lässt sich nicht wieder hochsetzen, weil man nicht weiss, wieviele Threads auf die "Barriere" warten werden. Sobald man also auf 0 ist und ein Thread den Count wieder erhöht, weiss man nicht, ob jemals ein weiterer Thread zu `await()` kommen würde

## Cyclic Barrier
- N Threads warten aufeinander
- `await()` blockiert, bis N Threads `await()` aufgerufen haben
- Kann wiederverwendet werden
- Im Unterschied zum CountDownLatch weiss man genau, wieviele Threads warten werden

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

## Übung
- Semaphore sind schneller als Lock & Condition
- Lock & condition lohnt sich nicht wegen Overhead der Implementierung

```
TEST SERIES: 1 producers 1 consumers (capacity 5)
Test WarehouseWithMonitor unfair
Total time: 1394 ms
Test WarehouseWithSemaphore unfair
Total time: 1262 ms
Test WarehouseWithSemaphore fair
Total time: 1103 ms
Test WarehouseWithLockCondition unfair
Total time: 1119 ms
Test WarehouseWithLockCondition fair
Total time: 3392 ms
TEST SERIES: 5 producers 5 consumers (capacity 5)
Test WarehouseWithMonitor unfair
Total time: 2913 ms
Test WarehouseWithSemaphore unfair
Total time: 1524 ms
Test WarehouseWithSemaphore fair
Total time: 2362 ms
Test WarehouseWithLockCondition unfair
Total time: 4983 ms
Test WarehouseWithLockCondition fair
Total time: 5368 ms
TEST SERIES: 1 producers 10 consumers (capacity 5)
Test WarehouseWithMonitor unfair
Total time: 4602 ms
Test WarehouseWithSemaphore unfair
Total time: 1449 ms
Test WarehouseWithSemaphore fair
Total time: 2014 ms
Test WarehouseWithLockCondition unfair
Total time: 5603 ms
Test WarehouseWithLockCondition fair
Total time: 19024 ms
TEST SERIES: 100 producers 100 consumers (capacity 5)
Test WarehouseWithMonitor unfair
Total time: 9808 ms
Test WarehouseWithSemaphore unfair
Total time: 1732 ms
Test WarehouseWithSemaphore fair
Total time: 2621 ms
Test WarehouseWithLockCondition unfair
Total time: 15325 ms
Test WarehouseWithLockCondition fair
Total time: 78283 ms
TEST SERIES: 1 producers 10 consumers (capacity 1000000)
Test WarehouseWithMonitor unfair
Total time: 1 ms
Test WarehouseWithSemaphore unfair
Total time: 0 ms
Test WarehouseWithSemaphore fair
Total time: 2 ms
Test WarehouseWithLockCondition unfair
Total time: 0 ms
Test WarehouseWithLockCondition fair
Total time: 0 ms
```
