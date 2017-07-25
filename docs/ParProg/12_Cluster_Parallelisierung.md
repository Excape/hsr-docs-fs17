# Cluster Parallelisierung

## HPC Cluster Architektur
- Anwendung. Wissenschaftliches Rechnen, Simulationen
- Cores in einem Cluster sind normale CPU-Cores (General Purpose)
- Gleichartige Rechenknoten an einem Standord fest verbunden, mit schnellem "Interconnent" (z.B. 60GBit/s)
- Ein *Head*-Node koordiniert die Jobs und ist nach Aussen verbunden. Die restlichen Knoten sind *compute*-Nodes (hinter der Firewall)
- I/O wird über File-Shares abgewickelt
- Ziel: Ein Programm auf mehreren Nodes ausführen -> z.B. Actor Model

## Verteiltes Programmiermodel - MPI
- Keine Shared Memory zwischen Nodes
- Ziel: Nachrichtenaustausch zwischen Prozessen (und Nodes)
- MPI: Message Passing Interface
    - "Standard" wie JPA
- Jeder Prozess hat eine Nummerierung (Rank)
- C Interface, kann aber auch in .NET verwendet werden

```cs
using (new MPI.Environment(ref args)) {
    int rank = Communicator.world.Rank;
    Console.WriteLine("MPI process {0}", rank);
}
```
- Ausführung mit `mpiexec -n <nof processes> <executable>`
- Wird automatisch auf HPC-Nodes verteilt
    - Auf einem Node können auch mehrere Instanzen (Prozesse) des Programms laufen
- Synchronisation über Barrieren (Initialize und Finalize sind Barrieren)

### Communicator
- Erlaubt Kommunikation zwischen Prozessen
- Rank ist Nummer innerhalb einer Gruppe, Eindeutige Id ist Rank + Communicator
- Alle Prozesse sind in Communicator-Gruppe "World"
- Senden: `world.send(value, receiverRank, messageTag)`
- Empfangen: `world.Receive(senderRank, messageTag, out value)`
- `world` ist Communicator-Gruppe, message-Tag frei wählbäre Nummer >= 0
- `Communicator.world.Barrier()` ist eine Barriere, die auf alle Prozesse wartet
- `world.Allreduce(value, fn)` reduziert mehrere Werte mit einer Aggregations-Funktion auf einen einzelnen Wert

### Monte Carlo Pi Simulation
- Erwartungswert Punkt im Kreis: \(\frac{Kreisfläche}{Quadratfläche}\)
- Quadratfläche \(= 2*2 = 4\), Kreisfläche \( = r^2 * \pi = \pi\)
- Annhäherung \(\pi = 4 \cdot \frac{\text{# Hits}}{\text{# Points}}\)
- Jeder Prozess rechnet einen Teil der Punkte, am Schluss wird die Summe der Hits aggregiert
- `world.Reduce(hits, (a, b) => a + b, 0);`, das Resultat wird an Prozess 0 gesendet
- Demo auf Cluster:
    - 30s auf einem Node
    - 8.4s auf 4 Nodes
    - 0.9s auf 40 Nodes
    - 0.4s auf 80 Nodes
