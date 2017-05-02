# GPU Parallelisierung

## Vorteile Actor Model
- Kein Shared Memory
- Keine Data Races
- Distributed Concurrency - Beliebige Verteilung auf mehrere Systeme
- Parallelisierung ist inhärent eingebaut, man braucht keine Synchronisationsprimitiven

## Ziel
- GPUs haben viele Cores, aber sie sind langsam und spezifisch (nicht "general-purpose)
- Ziel ist also möglicht hohe Parallelisierung

## GPU Prozessarchitektur
- ALU führt Rechenoperationen durch
- Im einer CPU werden relativ wenig Transistoren für die ALU eingesetzt
- Auf einer GPU ist der grösste Teil Transistoren für ALUs, dafür sind diese primitver, z.B. wird nur wenig Caching eingesetzt
- Eine GPU besteht aus mehreren SM (Streaming Multiprocessor), die selbst aus mehreren (z.B. 32 oder 64) Cores bestehen
    - die Cores in einer SM sind für sich selbst nicht fähig für Operationen
    - Eine Instruktion wird von einer SM ausgeführt, diese wird dann von jedem Core im SM gleichzeitig ausgeführt auf unterschiedlichen Datenstellen
    - Normale Operationen werden ausgeführt in sequentiellen Reihenfolge fetch - decode - execute - write back
- GPU-Parallelität eignen sich gut für Blockweise Operationen, wenn viele gleiche Berechnungen durchgeführt werden, z.B. Video Gaming
    - Eignet sich hingegen nicht für komplizierte Verzweigungen, z.B. Schach-Computer
### NUMA Modell
- Non-Uniform Memory Access
- Kein gemeinsamer Speicher zwischen CPU und GPU
- Unterschiedlicher Instruktionssatz zwischen CPU und CPU
    - Code für GPU und CPU sepparat kompilieren

## CUDA
- Proprietäre API / Compiler für C/C++ *für NVIDIA Karten*
- Video-Computing und CUDA werden parallel in einem Thread-Pool ausgeführt

- Code für GPU wird speziell ausgezeichnet
- Ein Kernel (Methode) wird von mehreren Threads ausgeführt
- Thread-index wird mit `threadIdx.x` abgerufen (`x` ist koordinate)

```c
__global__
void VectorAddKernel(float *A, float *B, float *C) {
    int i = threadIdx.x;
    C[i] = A[i] + B[i];
}
```

### Threads
- Threads sind gruppiert in Blöcke, ein Block ist im Hintergrund immer auf einem Streaming Multiprocessor
- Innerhalb eines Blocks können Threads untereinander kommunizieren
- Ein Thread ist ein virtueller Skalarprozessor
- Thread-Blöcke müssen unabhängig sein
- Blöcke werden mit Thread-Pool auf die verschiedenen Streaming-Prozessoren verteilt
    - Ein Block ist quasi ein "Task"
- Ein Grid ist eine Gruppe von Block, meist ein Programm
- Aufteilung in Blocks und Threads wird vom Programmiere modelliert
    - z.B. globalen Index ermittel mit `i = threadIdx.x + blockDim.x * blockIdx.x`
    - Im Aufruf des Kernels angeben, wie es ausgeführt werden soll. `<<<4, 512>>>>` heisst 4 Blöcke zu je 512 Threads

### Ausführung
- Speicher muss auf auch der GPU alloziert werden und hin und her von Host- zu Device-Memory kopiert werden
- Diese Schritte müssen manuell im Code gemacht werden