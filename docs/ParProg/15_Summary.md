# Summary
## TODO
- Java Monitor Syntax
- Java Synchronisationsprimitiven
    - Sempaphor Syntax
    - Lock & Condition
    - Count Down Latch
    - Cyclic Barrier / Phaser / Exchanger
- Java Thread Pool Syntax
- C# TPL Syntax
    - Partitionierung
    - PLINQ
    - async / await
- Unterschied TPL / Java Thread Pool
- Syntax MPI
- GUI-Parallelisierung Java & C#
- CUDA Code-Struktur
- Korrektheit (Wann Data Race, Starvation, etc.)
- Vergleich STM / Reactive / Actor

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
