# RMI & Web Services

## RPC
- Analog zu einem Function Call
- Transparent, ob Function lokal oder remote ist
- Normalerweise ein synchroner Aufruf
    - Mit modernen Frameworwks auch asynchron
- Procedure Calls werden gegen einen lokalen Stub aufgerufen, der dann den Aufruf in eine Message verpackt ("marshalling")
- Auf dem Emfpänger empfängt der Server Stub (Skeleton) die Message und called die server procedure

## Herausforderungen
- blocking calls
- Fehlgeschlagene Aufrufe wegen Netzwerk-Ausfall
    - Der Client muss dies behandeln
- Schwierig für nicht-idempotente Funktionen

## RMI
- Jave Implementation von RPC
- Lässt Objekte mit beliebig komplexen Typen übertragen
- Remote Objects werden vom Server in einer Registry eingetragen, damit sie aufgerufen werden können
- Es können auch Klassen-Definitionen in beide Richtungen übertragen werden
    - So kann der Client unabhängig von der Implementation der Business Logik sein
- Objects werden über HTTP übertragen

### Remote Object
- Objects werden Remote, wenn sie ein Interface implementieren, das von `java.rmi.Remote` ableitet

### Probleme
- Enge Kopplung Client-Server wegen Serialisierung
- Gleiche JVM-Version auf Client und Server
- Ist inheränt synchron, während message-based Protokolle inheränt asynchron sind

## Interface Description Language
- Sprache, um Interfaces sprachunabhängig zu definieren


## Web Services
### WSDL
- Web Service Description Language
- Beschreibt das Interface des Servers und dessen Datenstrukturen
- Wird z.B. in WCF verwendet
