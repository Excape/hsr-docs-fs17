# Fraud Detection

- Kreditkarten-Betrug wird momentan meist durch Menschen erkannt, in Zukunft soll vermehrt Monitoring / Machine Learning eingesetzt werden

## Online Fishing
- Im Gegensatz zur Offline Attacke werden die Credentials des Opfers z.B. über einen Reverse Proxy an den richtigen Dienst weitergeleitet
- Attacker hat gültige Session (Session Hijacking)
- Dadurch kann auch 2FA umgangen werden

## Money Mule
- Angreifer greift die Session ab
- Vom Angreifer wird über das Konto des Opfers an ein "Money Mule" (weiteres Opfer) Geld gesendet
- Money Mule wird überzeugt, dass das Geld weiter an den Angreifer leitet
- Ist mittlerweile "outdated"

## Fraud Detection System
- Bank zeichnet Informationen über das Login auf (zeit, IP, Browser Fingerprint, Login duration, etc) und hält History über frühere Sessions
- Auch Business Transaction werden aufgezeichnet: Wiederholte Zahlungen, Zahlungen an welche Banken, etc.
- Daraus wird eine Entscheidung gefällt, ob die Transatkion ausgeführt wird oder nachgefragt werden muss

## Markov Shield (Clickstreaming)
- Ziel: Verhalten unterscheiden von einem normalen Benutzer und einem infizierten Browser
- Requests werden von einem REverse Proxy nach Kafka-Server weitergeleitet
- Kritische Requests werden in eine ML-Enginge gefüttert

## APT Detection
- Logs von Diensten im Netzwerk sammeln
- Black-Lists beziehen und danach filtern
- Cuckoo Sandbox: Verdächtige Executables in Sandbox laufen lassen
