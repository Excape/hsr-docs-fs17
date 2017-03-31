# Cross Site Request Forgery
## Ursprung
- Die meisten Router-Admin-Interfaces laufen auf den gleichen IPs
- Router haben oft Default Passwords
- Infiszierter PC sendet Request an Router, loggt sich ein und ändert den DNS-Server (den des Hackers)

## Attack
- Opfer authentisiert sich bei E-Banking
- Opfer geht auf Hacker-Seite
- Im Browser wird einen Request (nicht ajax) an die Bank geschickt mit einer bestimmtem Transaktion
    - z.B. über ein Bild
    - schickt dabei Session-Cookie mit

## Remediation
- E-Banking verlangen SMS-Bestätigung
- Grundsätzlich: Aktion darf nicht mit einem voraussehbaren Request ausführbar sein
- In Formular zufälliges XSRF-Token als hidden field einbinden
- Client muss im Request dieses Token wieder mitschicken
