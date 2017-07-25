# Summary

## Java Monitor
```java
public synchronized void withdraw(int amount)
    throws InterruptedException {
    while (amount > balance) {
        wait();
    }
    balance -= amount;
    }
public synchronized void deposit(int amount) {
    balance += amount;
    notifyAll(); // put all waiting threads in "waiting room"
    // notify() wakes up a random thread
    // -> possible starvation! 
    // still continue execution (signal & continue)
}
```
```java
synchronized(this) {...}
```

## Java Semaphore
```java
this.upperLimit = new Semaphore(capacity, fair);
this.lowerLimit = new Semaphore(0, fair);

public void put(int amount) throws InterruptedException {
	upperLimit.acquire(amount);
	lowerLimit.release(amount);
}

public void get(int amount) throws InterruptedException {
	lowerLimit.acquire(amount);
	upperLimit.release(amount);
}
```

## Java Thread Pool
```java
ForkJoinPool threadPool = new ForkJoinPool();
// non-blocking
Future<Integer> future = threadPool.submit(() -> {
    // function with int return value
    // uncaught exceptions will be ignored!
})
// cancel task
// future.cancel()
// wait until completion (blocking)
int result = future.get()
```
```java
// blocking submit
boolean found = threadPool.invoke(new CountTask());
// CountTask extends RecursiveTask<T>

// Java 8 Standard pool (implicit)
boolean found = new CountTask().invoke();
```
### Completable Futures
```java
CompletableFuture<Long> future =
    CompletableFuture.supplyAsync(() -> longOperation());
// other work
future.get();

// or supply continuation tasks
future.thenAccept(myTask); // without return value
future.thenApply(myTask); // with return value
```
```java
CompletableFuture.allOf(future1, future2)
    .thenAccept(continuation);

CompletableFuture.any(future1, future2)
    .thenAccept(continuation);
```

## Deadlocks
- Für einen Deadlock müssen **alle 4 Voraussetzungen erfüllt sein**
    - **Nested Locks**
    - **Zyklische Warteabhängigkeiten** (Holt-Graph)
    - Gegenseitiger Ausschluss (Locks)
    - Sperren ohne Timeout / Abbruch

## C# Monitor
```csharp
// best practice
private object syncObject = new object();

public void Withdraw(decimal amount) {
    lock(syncObject) {
        while (amount > balance) {
            Monitor.Wait(syncObject);
        }
        balance -= amount;
    }
}
public void Deposit(decimal amount) {
    lock(syncObject) {
        balance += amount;
        Monitor.PulseAll(syncObject); // like notifyAll()
    }
}
```
## C# Task Parallel Library

```csharp
Task<int> task = Task.Run(() => {
    int total = ... // some calculation
    return total;
});
var result = task.Result; // blocking
```
```csharp
// Run parallel tasks and wait for completion (barrier)
Parallel.Invoke(
    () => MergeSort(l, m),
    () => MergeSort(m, r)
);
```
```csharp
// uses Striped Partitioner
Parallel.ForEach(list,
    file => Convert(file)
);
// Uses Range Partitioner
Parallel.For(0, array.Length,
    i => DoComputation(array[i])
);
// waits for all tasks to complete
```
```csharp
// Task Continuation
task1.ContinueWith(task2).ContinueWith(task3);
```
### PLINQ
```csharp
ParallelQuery<Book> query =
    from book in bookCollection.AsParallel()
    where book.Title.Contains("Concurrency")
    select book;
    // no side effects!!
query.ForAll(b => {
    if (Interesting (b)) {
        Read(b);
    }
});
```

## GUI-Programming
### Java
<img src="img/swing_invoke-later.png" style="max-width: 40%; margin: 10px; float: right" />


```java
button.addActionListener(event -> {
    // GUI-thread
    new Thread(() -> {
        String text = readHugeFile();
        SwingUtilities.invokeLater(() -> {
            // GUI Thread
            textArea.setText(text);
        });
    }).start();
});
```

!!! warning
    Swing ist nicht thread-safe! Wenn ein anderer Thread auf das UI zugreift, gibt es keine Exception!

### .NET
#### Mit TPL
```csharp
Task.Factory.StartNew(() => {
    int result = LongCalculation(number);
    Dispatcher.BeginInvoke(new ThreadStart(() => {
        resultLabel.Content = result;
    }));
});
```
#### Async / await
```csharp
public async Task<int> LongOperationAsync() { }

Task<int> task = LongOperationAsync();
OtherWork();
int result = await task;
```
- `async`-Methode muss `await` enthalten (gibt Kette)
- Bis zu `await` wird alles synchron, nacher asynchron (beliebiger Thread, ausser wenn Aufrufer UI-Thread ist)

<img src="img/async_await_gui.png" style="max-width: 60%" />

## Memory Models
- Optimizer kann Code-Ablauf nicht-deterministisch ändern, wenn zwei Statements unabhängig voneinander sind ("Weak Consistency")

### Java
- `volatile` ist wie Barriere: Alle änderungen vor dem Zugriff auf `volatile`-Variable werden für andere Threads sichtbar, die auf diese Variable zugreifen

#### Atomic Operations
- Kann mit `getAndSet(newValue)` atomar alten Wert lesen und neuen Wert setzen
- `compareAndSet(boolean expect, newValue)`: Atomares lesen und setzen mit Condition
    - Wenn Variable expected Wert hat, wird neuer Wert gesezt und `true` returned
- Atomic Klassen gibt es auch für Integer, Long und Referenzen
- Java 8: `var.updateAndGet(old -> calculateChanges(old))`

### .NET
#### Volatile Read / Write
- Volatile Read: Bleibt garantiert **vor** den nachfolgenden Zugriffen
- Volatile Write: Bleibt garantiert **nach** den vorherigen Zugriffen
- `Thread.MemoryBarrier()` verhindert Umordnung

## Actor Model
- Actors sind aktiv und kommunizieren asynchron über Channels miteinander
- Actors wissen selbst nichts voneinander, können aber neue Actor kreieren
- Kein shared memory, d.h. Actors können auch auf verschiedenen Nodes laufen
- Synchrones Senden und Empfangen möglich, aber Deadlock/Starvation-Gefahr!

```java
ActorSystem system = ActorSystem.create("System");
ActorRef printer =
    system.actorOf(Props.create(NumberPrinter.class));
for (int i = 0; i < 100; i++) {
    printer.tell(i, ActorRef.noSender());
}
system.shutdown();
```

## CUDA
```c
void CudaVectorAdd(float* A, float* B, float* C, int N) {
    size_t size = N * sizeof(float);
    float *d_A, *d_B, *d_C;
    
    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);
    
    cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);
    
    int blockSize = 512; // multiple of 32!
    int gridSize = (N + blockSize - 1) / blockSize;
    VectorAddKernel<<<gridSize, blockSize>>>(d_A, d_B, d_C, N);
    
    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);
    cudaFree(d_A); cudaFree(d_B); cudaFree(d_C);
}
```

- `__syncthreads()` dient als Barriere, aber **nur innerhalb eines Blocks!**

<img src="img/cuda_3d_grid.png" style="max-width: 60%" />

- Ein Block wird intern zu Warps (zu je 32 Threads) zerlegt
- Alle Threads in einem Warp führen gleiche Instruktionen aus (SIMD)
- Ein Block läuft immer auf einem Streaming Prozessor
- Falls ein Warp auf Speicher wartet, führt Streaming Multiprocessor einen anderen Warp aus
- **Coalescing**: Memory-Zugriffe werden in Memory-Bursts ausgeführt. Daher immer möglichst Speicher am gleichen Ort zusammen abrufen

## Cluster Parallelisierung
- Starten: `mpiexec -n <nOfNodes> program`
- Alle Prozesse starten und terminieren synchron
- Prozesse können mit `Communicator` messages senden und empfangen mit einer Nummer als "tag"
- `Send()` und `Receive()` sind blocking!
- `Allreduce()` ist eine Barriere und gibt jedem Prozess das Gesamtergebnis zurück
- `Reduce()`: Nur ein Prozess sieht das Gesamtresultat (per Parameter angegeben)

## Reactive Programming
<img src="img/react_stream.png" style="max-width: 60%" />

- Im Gegensatz zu "normalem" (P)LINQ (Pull) sind die Datenquellen aktiv und "Pushen" die Daten durch die Pipeline
- Jedes Subject (ausser Anfang und Ende) ist *Observer* des Vorgängers und *Observable* des Nachfolgers

<img src="img/react_buffers.png" style="max-width: 60%" />

- Parallel ausführen:
```csharp
collection.ToObservable().ObserveOn(TaskPoolScheduler.Default);
```
- Für GUI-Thread `DispatcherScheduler.Current` verwenden

- *Hot* Observables: Notifizieren spontan auch ohne Observers, z.B. `Timer`, `Intervall`
- *Cold* Observables: Notifizieren on request und erst bei Anmeldung des Observers, z.B. `Range`, `Generate`

!!! warning
    Vorsicht bei Seiteneffekten und Warteabhängigkeiten in Observer (Race Conditions / Deadlocks)!

## Software Transactional Memory
- Unterschied zu Monitor Lock
    - Deskriptiv - es wird nur beschrieben, was atomar ist
    - Keine Deadlocks, keine Race-Conditions (Starvation noch möglich!)
- Transaktionen können verschachtelt werden ohne Deadlock-Gefahr (Commit erst bei Top-Level-Transaktion)
- Optimistic Concurrency: Transaktion wird bei Konflikten (oder Exceptions) abgebrochen
- Wird Hardwareseitig von Intel unterstützt
- Wenn gewartet werden muss, `STM.retry()` aufrufen
- Generell wird kein IO unterstützt
- *Write Skew*: Anhand des Anfangsstatus werden Entscheidungen getroffen, während ein anderer Thread dies ändert (Isolationsfehler)
    - in Scala STM korrekt gelöst, in anderen Systemen mit einfacher *Snapshot-Isolation* aber nicht!
