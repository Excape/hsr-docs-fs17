# CSP - Content Security Policy
- Server gibt vor, wohin der Browser sich verbinden darf
- Schutz gegen XSS mit `<script src="..." />`
- Wird geschickt per HTTP-Header `X-Content-Security-Policy`

- Beispiel: `X-Content-Security-Policy script-src self ajax.google.com`
    - Erlaubt nur Skripte von der Domain selbst und ajax.google.com
- Gibt für Objekte wie css, bilder, etc. eigene policies
    - XHRs werden über `connect-src` gesteuert!
- `self` erlaubt Requests auf den eigenen Host (wie standard Cross-Origin-Policy)
- `default-src: 'none'` als ersten Wert fungiert als "Deny all", nachher können Ausnahmen definiert werden
- HXR-requests gehen über `connect-src`
- Für Debugging kann mit `report-uri` und dem Header `Content-Security-Policy-Report-Only` eine uri angegeben werden
    - Der Browser enforced die Policy nicht, aber schickt violations an die angegebene uri
    - Angreifer kann das ausnutzen, wenn er CSP verändern kann - die Violations zu sich schicken lassen und so URLs herausfinden
- Es können jeweils mehrere Werte mit Space getrennt angegeben werden, z.B. um Google Analytics einzubinden: `script-src 'self'; www.google-analythics.com`
