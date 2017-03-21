# Thread Pools

!!! note
    Quiz letzte Woche: Keine Garantie, dass Lock jemals erfolgreich ist -> Starvation. 

## Konzept
- *Tasks Queue* mit Tasks von potentiell parallele Arbeitspakete
    - Queue weiss nicht, wieviele Threads im Pool arbeiten, Tasks müssen also beliebig parallelisierbar sein
- *Thread Pool* ist eine beschränkte Anzahl von Worker-Threads, die die Tasks aus der Queue holen und ausführen


- Vorteile
    - Beschränkte Anzahl Threads (konfigurierbar, normalerweise Anzahl logische CPU-Cores)
    - Threads werden recycled, weniger Overhead für Thread-Erzeugung und -Freigabe
    - Höhere Abstraktion: Task-Beschreibung wird von Task-Ausführung getrennt (muss z.B. nicht zwinged nebenläufig sein)


- Einschränkungen
    - Tasks dürfen nicht auf andere warten, sie müssen unabhängig voneinander sein
        - Sonst könnte es zu Deadlocks kommen, wenn alle Threads auf andere Tasks in der Queue warten
    - Tasks müssen komplett fertig laufen, bevor der Worker Thread ein anderer Task beginnt (*Run to Completion*)
        - Ausser bei geschachtelten Tasks (Sub-Tasks)
        - Grund: Thread führt einen Stack. Weitere Tasks würden den Stack füllen und könnten nur wieder in umgekehrter Reihenfolge "gepoppt" werden. Bei geschachtelten Tasks weiss man, dass der "obere" Task auf dem Stack zuerst fertig laufen muss

## Funktionsweise
### Task Lancierung
```java
ForkJoinPool threadPool = new ForkJoinPool();
```
- Bietet Task Queue und Threads (default: Anzahl Cores)

```java
Future<Integer> future = threadPool.submit(() -> {
    int value = …;
    // long calculation
    return value;
});
```
- Task wird eingereiht in die Task-Queue
- Generic Type von `Future<T>` ist Typ des Rückgabewert

### Future Konzept
- Das `Future`-Objekt wird benötigt, um asynchron Tasks zu submitten. Das Ergebnis wird erst später rein geschrieben
- `T result = future.get()` blockiert, bis Task beendet ist und ruft das Ergebnis ab (analog `join`)
- Wenn Tasks mit unbehandelter Exception abbricht, wirft die `get()` Methode eine `ExcecutionException` mit ursprünglicher Exception als `Cause`
- Mit `future.cancel()` wird Task aus Warteschlange entfernt, und falls `true` als argument mitgegeben wird, auch ein laufender Tasks unterbrochen (`InterruptedException`, wird nicht einfach gekillt!)
- Wenn `Future`-Objekt beim submit ignoriert wird (Fire and Forget), werden unbehandelte Exceptions ignoriert!

## Rekursive Tasks
- Tasks ineinander verschachteln
- Tasks muss explizit implementiert werden und von `RecursiveTasks<T>` ableiten
- Statt `submit` auf Tasks `fork()` aufrufen
- Statt `get()` auf Tasks `join()` aufrufen
```java
class CountTask extends RecursiveTask<Integer> {
    private final int lower, upper;
    
    public CountTask(int lower, int upper) {
        this.lower = lower; this.upper = upper;
    }
    
    protected Integer compute() {
        if (upper - lower > THRESHOLD) {
            // parallel count
            int middle = (lower + upper) / 2;
            CountTask left = new CountTask(lower, middle);
            CountTask right = new CountTask(middle, upper);
            left.fork(); right.fork();
            return right.join() + left.join();
        } else {
            // sequential count
            int count = 0;
            for (int number = lower; number < upper; number++) {
            if (isPrime(number)) { count++; }
        }
        return count;
        }
    }
}
```
- Aufruf (Java 8): `int result = threadPool.invoke(new CountTask())`
- Achtung vor Über-Parallelisierung! Nicht zuviel aufsplitten, sonst ist der Overhead der Rekursion zu gross

## Fork & Join Pool
- `Fork()` und dann `Join()` ist schneller, wenn `Join()` in umgekehrter Reihenfolge ausgeführt wird
    - Grund: Neue Sub-Tasks werden zuoberst in lokale Queue eingefügt
- Worker-Threads laufen als Daemon-Threads
- Anzahl Threads werden dynamisch verändert
- Common Pool (sinleton) hat immer #Prozessoren - 1 Threads (also langsamer)
- Moderne Thread-Pool-Implementationen haben mehrere Queues
    - Jeder Thread hat eigene Queue (Lokale Queue)
    - Wenn Loake Queue leer ist, wird von einer anderen lokalen Queue Tasks abgenommen ("Work Stealing")

## CompleteableFutures
- Feature von Java 8
- Caller-zentrisch (Pull): Caller wartet auf Ende und holt sich das Resultat über das Future-Objekt
- Callee-zentrisch: Completion-Callback, das ausgeführt wird, wenn der Task fertig ist
- `CompletableFuture` ist *Callee-zentrisch*

```java
CompletableFuture<Long> future =
    CompletableFuture.supplyAsync(() -> longOperation());
//other work
future.thenAccept(result -> System.out.println(result));
```
