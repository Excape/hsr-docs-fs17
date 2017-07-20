# GUI and Threading
## Quiz letzte Woche
```csharp
Task.Run(() => DownloadFile(url)).ContinueWith(task2);
```
- beachten: main Thread darf nicht aufhören, bevor die Tasks beendet werden, da sie in Daemon Threads ausgeführt werden

## Single-Thread-Modell
- Nur ein Thread darf auf GUI zugreifen (UI-Thread)
- UI-Thread arbeit Ereignisse aus einer Event-Queue nacheinander ab
- Analog: Thread Pool mit 1 Worker Thread
- Gründe
    - Synchronisationskosten
    - Deadlock-Risiko wegen zyklischen Pattern (Observer, MVC)
- Einschränkungen
    - UI-Events müssen schnell berechenbar sein, damit das UI nicht blockiert
    - Kein Zugriff auf UI durch fremde Threads

!!! warning
    Alte GUI-Frameworks wie AWT und Swing werfen keine Exceptions, wenn ein anderer als der UI-Thread auf das UI zugreift, es kann dann Race Conditions geben

## UI Dispatching
- In Swing mit `invokeLater(Runnable doRun)` ein Runnable in die Event-Queue eingefügt

```java
button.addActionListener(event -> {
    new Thread(() -> {
        String text = readHugeFile();
        SwingUtilities.invokeLater(() -> {
            textArea.setText(text);
        });
    }).start();
});
```
- Besser Thread Pool statt `Thread.start()` benutzen

## .NET UI-Thread Modell
- Gleich wie in Java Single-UI-Thread
- Der Thread, der das Window startet, wird zum UI-Thread
```csharp
Task.Factory.StartNew(() => {
    int result = LongCalculation(number);
    Dispatcher.BeginInvoke(new ThreadStart(() => {
        resultLabel.Content = result;
    }));
});
```
- Verkettung ist schlecht lesbar

## C# async / await
- Löst die Zerstückelung der Logik bei der klassischen GUI-Programmierung
- Methode mit Keyword `async`
- Rückgabetyp ist `void` (fire & forget) oder `Task<T>`, wobei `T` der Typ des Rückgabewerts ist (optional)
    - Rückgabe direkt mit `return T`, nicht `return Task<T>`
- Name endet auf `Async` per Konvention
- Nach Aufruf der Methode kann auf dem zurückgegebenen Task `await` aufgerufen werden, um auf das Ergebnis zu warten (und Rückgabewert auslesen)

```csharp
public async Task<int> LongOperationAsync() { }

Task<int> task = LongOperationAsync();
OtherWork();
int result = await task;
```
- Der Aufrufer ist nicht *zwingend* während des Aufrufs blockiert

### Spezielle Regeln
- `async`-Methode muss `await` beinhalten, sonst Compiler-Warning
- `await` muss in `async`-Methode sein, sonst Compiler-Fehler
- Dies verursacht schnell eine Kette, weil nun alles async sein muss
    - Kann z.B. durch `Task.wait()` unterbrochen werden
- Grund liegt im Ausführungsmodell

### Ausführungsmodell
- Eine `async`-Methode läuft teilweise asynchron, teilweise synchron
- Aufrufer führt die Methode erst asynchron aus, sobald ein `await` kommt, vorher synchron
- Der asynchrone Teil wird normalerweise durch den Thread des erwarteten Tasks ausgeführt (als "continuation")
- *Ausser* bei UI-Threads: Dort wird der Asynchrone Teil nach dem `await` wider vom Aufrufer (= UI-Thread) ausgeführt
    - Somit hat dies die gleiche Auswirkung wie ohne dem async / await Konzept, die Aufteilung wird einfach vom Compiler gemacht

### UI-Programmierung
```csharp
async void startDownload_Click(…) {
    HttpClient client = new HttpClient();
    foreach (var url in collection) {
        var data = await client.GetStringAsync(url);
        textArea.Content += data;
    }
}
```
- Die Methode springt zurück beim `await`, das Resultat wird dann wieder im GUI-Thread gesetzt

### Pitfalls
- Eine `async`-Methode sind nicht per-se asynchron. Ist kein `await` drin ist, wird sie komplett synchron ausgeführt
    - Workaround: `return await Task.Run()`
- Threadwechsel während Methodenausführung
    - Teil nach `await` muss nicht mehr im gleichen Thread ausgeführt werden
- Empfehlung: Nur im UI-Layer benutzen
