# CSP - Content Security Policy
- Server gibt vor, wohin der Browser sich verbinden darf
- Schutz gegen XSS mit `<script src="..." />`
- Wird geschickt per HTTP-Header `X-Content-Security-Policy`

- Beispiel: `X-Content-Security-Policy script-src self ajax.google.com`
    - Erlaubt nur Skripte vom Sever selbst und ajax.google.com
- Gibt für Objekte wie css, bilder, etc. eigene policies
    - XHRs werden über `connect-src` gesteuert!
- `default-src: 'none'` als ersten Wert fungiert als "Deny all", nachher können Ausnahmen definiert werden
- Für Debugging kann mit `report-uri` und dem Header `Content-Security-Policy-Report-Only` eine uri angegeben werden
    - Der Browser enforced die Policy nicht, aber schickt violations an die angegebene uri
