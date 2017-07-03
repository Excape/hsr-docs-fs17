# Cross Site Request Forgery
## Ursprung
- Die meisten Router-Admin-Interfaces laufen auf den gleichen IPs
- Router haben oft Default Passwords
- Infizierter PC sendet Request an Router, loggt sich ein und ändert den DNS-Server (zu dem des Hackers)

## Attack
- Opfer authentisiert sich bei E-Banking
- Nutzt dabei ein Session-Cookie aus
    - Geht nicht mit URL-Based Session handling, weil dann die URL nicht voraussehbar ist (angenommen die Session ID ist zufällig)
- Opfer geht auf Hacker-Seite
- Im Browser wird einen Request (nicht ajax) an die Bank geschickt mit einer bestimmtem Transaktion
    - z.B. über ein Bild
    - schickt dabei Session-Cookie mit

## Remediation
- E-Banking verlangen SMS-Bestätigung
- Grundsätzlich: Aktion darf nicht mit einem voraussehbaren Request ausführbar sein
- In Formular zufälliges XSRF-Token als hidden field einbinden
- Client muss im Request dieses Token wieder mitschicken
- Darf keine XSS-Lücken haben! Sonst nützt CSRF-Token auch nichts mehr
