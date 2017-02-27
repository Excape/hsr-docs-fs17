# Socket Programmierung
- Message-Oriented Middleware (z.B. HTTP GET / POST)
    - Client wartet meist asynchron auf die Antwort
- Remote Procedure Call
    - z.B. JAVA RMI
    - Heute Web-Services (RESTful HTTP)
    - Client wartet auf die Antwort
- [Fallacies of Distributed Systems](http://www.rgoarchitects.com/Files/fallacies.pdf)
- [Fowler's First Law](http://www.drdobbs.com/errant-architectures/184414966) of Distributed Object Design
    - Verteilte eigene Objekte sind starke Kopplung!
    - Müssen meist in gleicher Sprache sein

## Sockets
- Middleware, um über TCP / UDP zu kommunizieren
- Zwei Prozesse schreiben und lesen auf den Socket, als ob es ein File wäre
- Identifiziert durch Tupel IP-Adresse und Port
- Zuerst muss Session aufgebaut werden
- Enge Kopplung zwischen Client und Server
- In TCP/IP-Model auf Application-Layer, in OSI-Modell auf Session-Layer
- Nachteile
    - Reiner Bytestream - Muss geparsed werden
    - Message Exchange Patterns muss selbst implementiert werden, z.B. Reihenfolge der Messages
- Meist nicht direkt auf Sockets programmieren, sondern höhere Abstraktion verwenden

### Server
- Hört auf einen Port (Listener)
- Erstellt für jeden Client einen eigenen Socket
- Meist wird für jede Client-Connection (Socket) ein eigener Thread verwendet

- Berkeley Sockets bieten ein standardisiertes Interface

### WebSockets
- Bei reinem HTTP kann der Server nur Daten senden, wenn der Client eine Anfrage sendet
- Mit Websockets kann der Server Daten auf den Client "pushen"
- Browser sendet Daten mit `send()` und empfängt Daten in `onmessage` Event handler
- Wird von modernen Browsern unterstützt

### UDP-Sockets
- Client muss keine Verbindung vor dem Senden zum Server aufbauen, sondern kann direkt anfangen zu senden
- Server sendet keine Bestätigung
- [Java Tutorial](http://docs.oracle.com/javase/tutorial/networking/datagrams/index.html)

## Messaging Patterns
- **Basic Pattern**: Analog zu einem Brief, der von einem Message Endpoint zum anderen gesendet wird
- **Blocking Receiver Message Pattern**: Synchrone Übertragung, Server und Client warten auf die Antwort
- **Polling Receiver Message Pattern**: Der Receiver macht Anfragen zum Empfangen der Nachricht (Polling)
- **Service Activator Message Pattern**: Auf einen Request ruft der "Replier" mit dem "Service Activator" die richtige Service-Funktion auf (RPC-style)
