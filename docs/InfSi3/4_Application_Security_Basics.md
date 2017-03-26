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

## 302 Redirect nach Login
- Wenn der Server vertrauliche Daten per POST erhält (Login), sollte er mit 302 Redirect antworten
- Bei 200 Returncode würde der Browser die gesendeten Daten cachen (und können erneut gesendet werden bei back-button)
- Bei 302 Redirect cached der Browser die Daten nicht

## Session Fixation Attack
- Angreifer erstellt Session auf Webapp (noch ohne Login)
- Angreifer schickt seine Session zum Opfer und bringt es dazu, diese Session zu verwenden
- Opfer loggt sich ein, Session ist nun authentifiziert
- Angreifer kann diese Session verwenden

- Das "unterjubeln" von Sessions geht nur schwer über Cookies, betroffen sind primär Server, die Session-Handling über URL-Requests machen

### Remedies
- Beim Login soll der Server eine neue Session erstellen (mit Kopie des Inhalts der alten Session) und die alte invalidieren

## Same Origin Policy
- Same Origin wird definiert auf Protokoll, Host und Port
- Verboten also auch von HTTP zu HTTPS und umgekehrt!
- SOP kann umgehen werden, indem JS auf Third-party-seite liegt und mit `<script src="..">` eingebunden wird
- Sauber geht es über CORS (später)
