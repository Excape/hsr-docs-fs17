# Software Transactional Memory
- Problem: Shared Mutable Memory
    - Race Conditions möglich, explizite Synchronisation nötig
    - Verantwortlichkeit des Entwicklers
- Software Transactional Memory (STM) ist deklarativ
    - Keine Data Races, keine Deadlocks (Race Conditions noch möglich)
    - In HW oder SW implementierbar
    - HW-Support von Intel schon drin
    - Frameworks für Java, Scala, .NET, ...

## Software Transactions
- Kritische Sektionen identifizieren
- Drum herum `atomic {...}` (konzeptionell) schreiben
- R/W auf Speicher sind atomar
- Erfüllt ACI-Kriterien
    - Kein "Durable" / Persistenz
- Isolations-Mechanismus wird System übergeben
- Seiteneffekte sind nicht isoliert (z.B. I/O)
- Implementiert meist mit Optimistic Concurency
    - Unsynchronisiert ausführen, bei Konflikte Rollback und (automatic) Retry
    - Pesimistic Concurrecy wäre wieder Deadlock-Gefahr

## STM vs. Locking
- Unterschied zu Monitor Lock: Deskriptiv, es wird nicht gesagt, wie es isoliert werden soll
- Geschachtelte Transactions: Locking ist nicht deadlock-frei

## Probleme
- Seiteneffekte sind immer sichtbar
    - Wenn z.B. Netzwerkstream-losgeschickt wird, kann er schlecht "rollbacked" werden
- Starvation-Gefahr, wenn optimistic concurrency ständig retries macht
    - Muss dann evtl. komplett seriell ausgeführt werden
- Bei Konflikten soll Transaktion direkt abgebrochen werden, sonst kann z.B. ein Runtimeerror (z.B. Division by 0) auftreten, weil die Transaktion optimistisch ausgeführt wird

## Warten auf Bedingungen
- `retry` im `atomic`-Block, um die Prüfung der Bedinung zu wiederholen
- `atomic`-Blocks könnten geschachtelt werden, um nur bestimmte Teile des Programms zu "retryen". Ist aber kontrovers

## STM auf Java
- Bietet einen Wrapper für Transaktionen
    - Sonst müssten Speicherzugriffe auf JVM-Ebene detektiert werden
- Variablen müssen eingepackt werden

```java
final Ref.View<Integer> balance = STM.newRef(0);
```
- Datentyp muss immutable sein!
- Indirekte Strukturen (Collections) sind nicht transaktionell
    - Explixit `STM.newMap()` etc. verwenden
- In Scala einfacher zu handhaben

```java
void withdraw(int amount) {
    STM.atomic(() -> {
        if (balance.get() < amount) {
            STM.retry();
        }
        balance.set(balance.get() - amount);
        lastUpdate.set(LocalDate.now());
    });
}
```

- `atomic` kann auch geschachtelt werden
- Wenn im Atomic-Block eine Exception geworfen wird, wird die Transaktion rollbacked und die Exception heraus geworfen

## Write Skew Problem
- Problem bei "Snapshot Isolation": Anhand des Anfangsstatus werden Entscheidungen getroffen, so können Fehler auftreten (siehe Bsp. Folie)
- Darf in STM nicht passieren
- In Scala STM korrekt implementiert
- Bei anderen Systemen (z.B. auch Datenbanken), die einfache Snapshot Isolation verwenden

## Starvation Problem
- Wenn Transaktionen ständig abgebrochen werden
- In Scala STM ist beliebige Wiederholung möglich


