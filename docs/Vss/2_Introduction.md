# Introduction

- Transparency Types: Eigenschaften eines Systems transparent (= "durchsichtig") für den Benutzer machen, damit er nicht mitbekommt, dass z.B. mehrere Benutzer gleichzeitig zugreifen (Concurrency Transparency)
- Vorteile von VSS
    - Bilden die verteilte Realität ab (verschiedene Arbeitsplätze etc.)
    - Performancesteigerung (paralelle Verarbeitung)
    - Skalierbarkeit
    - Fehlertoleranz
- Herausforderungen VSS
    - Komplexe Kommunikation
    - Performanceprobleme (Latenz, Durchsatz)
    - Zuverlässigkeit (Netzzugriffe, Ausfälle)
    - Transaktionssicherheit (mehrere Benutzer)
    
## Middleware
**Midleware** ist infrastrukturelle Software, die eine Ebene unter dem Software-System liegt

- Wird i.d.R. nicht selbst geschrieben
- Dient zur Kommunikation zwischen den Software-Komponenten
### Kommunikationsmiddleware
- Interfaces zur Netzwerkprogrammierung
- TCP/IP Sockets, RESTful HTTP, etc.
### Anwedungsorientierte Middleware
- Unterstützung verteiler Andwendungen
- Vereinfacht das Design der Applikation
- bietet Sicherheit, Zuverlässigkeit, verteilte Transaktionen, ...
- z.B. .NET Application Server, SQL mit Remote Queries, ...

![](img/middleware.png)

## VSS Architectural Styles
- *Hub and Spoke*: Alle kommunizieren über zentrale Stelle ("Hub")

- CORBA (Centralized Object Request Broker Architecture) wird heute nicht mehr verwendet, die Prinzipien sind aber immer noch releveant
