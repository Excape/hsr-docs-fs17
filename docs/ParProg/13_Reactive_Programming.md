# Reactive Programming
## Quiz letzte Vorlesung
- Ausgabe nicht-deterministisch
- `send()` muss non-blocking sein, ist bei mpi aber nicht spezifiziert!
- Es gibt garantiert non-blocking send Funktion: `immediateSend()`

## Datenflüsse
- Wir wollen Programme deskriptiv schreiben (*was* tun, nicht *wie*)
- Daten kommen mit Daten-Streams hinein (Iteratoren) und werden gejoined, gruppiert, gefiltert, etc.
- Horizontal parallelisieren: z.B. mit einem Thread jeweils ein Datenpunkt durch die ganze Pipeline schlaufen, parallele Pipeline
- Vertikal parallelisieren: Innerhalb einer Box parallelisieren

## LINQ
``` cs
from entry in
    salesEurope.AsParallel()
    Union(salesAsia.AsParallel()).
    Union(salesAmerica.AsParallel())
// group ... select ...
```
- Evaluation ersten bei Iteration
- Vorraussetzung: Daten müssen vollständig vorliegen (passiv)
- Geht nicht, wenn Daten sukzessive ankommen

## Reactive Push-Mechanismus
- Im Gegensatz zum Pull-Modell
- Pro ankommender Wert muss ein Ereignis ausgelöst werden (Observer Pattern)
- Verkettung der Schritte: Nachfolge-Schritt abonnniert Events des Vorgängers

## Rx.NET
### Pipelining
- Jeder Zwischenschritt spielt gleichzeitig Observer des Vorgängers und Observable des Nachfolgers. Diese Objekte sind `Subjects` (Promises)
- Bei `onComplete()` wird der Observer de-registriert
- Ein `ReplaySubject` sendet auch Daten an Subscribers, die sich erst später registiert haben

### Collections zu Observables
- Mit `myCollection.ToObservable()` eine Collection für Rx.NET erstellen
- Auf dieser Collection `subscribe()` aufrufen, dessen Funktion dann für jedes Element aufgerufen wird

### Rx und Concurrency
- Default: Alles sequentiell
- Concurrency "einschalten": `observable.ObserveOn(TaskPoolScheduler.Default).Subscribe(...)`
- Mit WPF `DispatcherScheduler.Current` verwenden, um den GUI-Thread zu benachrichtigen (Zugriff von anderem Thread ist verboten)

### Concurrency Fehler
- Nie `first()` oder `last()` verwendet, diese warten auf alle Daten und blockieren!

- Aufpassen bei Aggregationen: Man muss auf alle Daten warten (`onComplete()`), bis die Aggregation vervollständigt wird
