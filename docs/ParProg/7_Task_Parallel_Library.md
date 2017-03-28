# Task Parallel Library
- Task Parallel Library ist ein moderner Thread-Pool in .NET

## Threading in .NET
- Thread nimmt delegate entgegen

```csharp
Thread myThread = new Thread(() => {
    for (int i = 0; i < 100; i++) {
        Console.WriteLine("MyThread step {0}", i);
    }
    });
myThread.Start();
// ...
myThread.Join();
```
- Unbehandelte Exceptions in einem Thread führen zum Abbruch des Programms!

### Monitor
- Object als Hilfsobjekt
```csharp
class BankAccount {
    private decimal balance;
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
            Monitor.PulseAll(syncObject); // wie notifyAll()
        }
    }
}
```
- Monitor hat im Gegensatz zu Java Fairness (FIFO Queue)


## Task Parallel Library
- Work stealing thread pool (singleton)
- Verschiedene Abstraktionsstufen
    - Task Parallelization: Explizite Tasks starten
    - Data Parallelization: Parallele Statements und Queris
    - Asynchrone Programmierung mit Continuation style

### Task Parallelisierung
```csharp
Task task = Task.Run(() => {
    // task implementation
});
// perform other activity
task.Wait(); // Blockiert, bis Task beendet wird
```
- Tasks können weitere Tasks starten

```csharp
Task.Run(() => {
    Task<int> left = Task.Run(() => Count(leftPart));
    Task<int> right = Task.Run(() => Count(rightPart));
    int result = left.Result + right.Result;
});
```
- Anzahl Worker-Threads wird variiert
    - Es wird "ausprobiert" und der Durchsatz gemessen
    - Wenn der Durchsatz besser wird, werden die Anzahl Threads erhöht
    - Bei einem Deadlock kann der Pools immer weiter wachsen

### Datenparallelität
- Unabhängige Statements und Loops können parallel ausgeführt werden
```csharp
Parallel.Invoke(
    () => MergeSort(l, m),
    () => MergeSort(m, r)
);

Parallel.ForEach(list,
    file => Convert(file)
);
```
- blockiert, bis alle Tasks fertig sind
- TPL gruppiert die "Bodies" automatisch in Tasks, es wird nicht zwingend für jede Iteration einen eigenen Task erstellt
- Partitionierung kann fix angegeben werden
```csharp
Parallel.ForEach(Partitioner.Create(0, array.Length),
    (range, _) => {
        for (int i = range.Item1; i < range.Item2; i++) {
            DoCalculation(array[i]);
    }
});
```

### Parallel LINQ
- Parallele Verarbeitung von Collection Operationen
- Oft können Conditions parallel geprüft werden
```csharp
ParallelQuery<Book> query =
    from book in bookCollection.AsParallel()
    where book.Title.Contains("Concurrency")
    select book;
query.ForAll(b => {
    if (Interesting (b)) {
        Read(b);
    }
});
```
- Resultat hat beliebige Reihenfolge, `ForAll` wird auch in beliebiger Reihenfolge ausgeführt
- Für richtige Reihenfolge noch `AsOrdered()` anhängen (Performance-Einbussen)
- Geht in Java auch mit `parallelStream()`, dort ist der output aber standardmässig geordnet
- Achtung vor Seiteneffekten in Query!

### Asynchrone Programmierung
- Tasks starten und auf Resultat warten
```csharp
var task = Task.Run(
    LongOperation
);
// perform other work
int result = task.Result;
```
- Task Continuations wie bei Java
    - `task1.ContinueWith(task2).ContinueWith(task3)`
- Multi-Continuation
    - `Task.WhenAll(task1, task2).ContinueWith(task3)`

#### Asynchronität in C#
- Sprachkonstrukt in C# für asynchrone Ausführung
- Thema nächste Woche
