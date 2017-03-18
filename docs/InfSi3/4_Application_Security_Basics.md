# Application Security Basics

## Web Basics
- Interception Proxy
    - Proxy zum Abfangen und Analysieren von Traffic
    - z.B. ZAP und Burp (auf LiveCD)
- HTTP ist zustandslos
    - 
- Zustände werden mit Cookies ausgetauscht
    - Server erzeugt ID (=Referenz auf serverseitigen Speicher), die er dem Client im Response-Header überträgt
- Statt mit einem Cookie kann eine ID auch im Body als hidden field übertragen werden
- Client schickt Session-ID an Server zurück
    - Geht im Request als Query-parameter
    - Oder im Header (z.B. Cookie)
    - Oder im Body (POST)
- **Austausch über Cookies im Header ist die sicherste Variante!**
    - Request-Queries werden im Access Log und History Cache (lokal) gespeichert -> Anfällig auf Session Hijacking!
    - Body: Wird lokal im Filecache gespeichert, ebenfalls anfällig
- Ob Cookie Session-Cookie ist (nicht persistent), wird mit `ìsSession` gesteuert (default true)
- `Path` und `Domain` geben an, zu welcher Domain und Pfad das Cookie vom Browser gesendet wird
- HPKP: HTTP Public Key Pinning
    - Beim ersten Response des Servers wird ein Hash des Public Keys (=Pin) des Certs im HPKP-Header mitgesendet
    - Der Client rechnet ebenfalls einen Hash des Public-Keys
    - Bei zukünftigen Verbindungen prüft der Client, ob der Hash noch derselbe ist wie der gespeicherte. Wenn nicht, wird die Verbindung rejected
    - Problem, wenn Certs ausgetauscht werden
        - Lösung: Mehr als einen PIN angeben
        - Zertifikate werden auf Vorrat erstellt
        - Es werden mehrere PINS mitgeschickt, auch solche von zukünftigen Certs
        - Oder: Eigenes Intermediate CA Pinnen und von diesem aus die richtigen Server-Certs ausstellen
