# Error Handling Design

## Massnahmen für Fehler-Vermdeidung
- Testing / Simulation
- Statische Analyse
- Architektur (-Review)
- Deliberate Programming
- Reviews

## Defensive Programmierung
### Systematische Fehlerprüfung
- Alle Werte von externen Quellen werden geprüft
- Ungültige Zustände werden behandelt
    - Systematisch abfangen
    - z.B. Default case bei `switch`
- Ungültige Benutzer-Eingaben verhindern
- Prüfung von Funktions-Input
    - Preconditions vor Ausführung prüfen
- Nachteile
    - Kann u.U. nicht getestet werden
    - Kostet etwas (mehr Programmieraufwand, mehr Laufzeit)
    - Duplizierter Code

#### Fehler-Barrikaden
- Externe Eingaben sind zuerst "untrusted" und müssen durch eine Barrikade gehen, wo sie getestet werden
- Precondition muss so nicht bei jeder Methode geprüft werden, sondern nur einmal
- Implementation
    - z.B. über eine Facade nur gültige Daten "rein lassen"
    - Datacontracts, wenn z.B. eine Konfiguration eingelesen wird
    - Public-Methods überprüfen Daten, private Methods gehen von gültigen Daten aus

### Systematische Fehlerbehandlung
- Fehler erkennen und melden
- Hängt stark vom System ab, ein Auto z.B. kann bei Fehler nicht einfach weiter fahren
- Sicherheitskritische Systeme sollten bei einem Fehler in einen sicheren Zustand
- Nicht-sicherheitskritische Systeme sollten Fehler loggen und robust sein bei Fehler, dh. versuchen am Laufen zu halten
- _Konservative Behandlung_
    - Fehlermeldung anzeigen
    - Shutdown
- _Optimistische Behandlung_
    - Neutrales Resultat
    - Nächstmöglich plausibles Resultat wählen
    - Warnung loggen
- *lokale* Behandlung
    - Nur für erwarteten Fall, wenn Fall lokal abschliessend entscheidbar ist
    - In java checked exceptions
- *globale* Behandlung
    - Wenn nicht lokal behandelbar
    - Fehler ist auf höherer Ebene relevant
    - In Java unchecked (Runtime) Exceptions (z.B. NullPointerException), da es überall passieren könnte
    - In Java kann ein global Error Handler definiert werden, der z.B. alle Exceptions loggt
- Fehlerbehandlung kann auch Fehler enthalten!
    - Einfach halten
    - ebenfalls testen

## Assertions
- Logisch dassselbe wie `if.. else throw`
- Kann von der Runtime an- oder abgeschaltet werden, z.B. für Debug-Umgebung
- Für produktive Fälle wie externe Quellen immer Exceptions verwenden!
- Assertions für Programmierfehler verwenden, die nie auftreten dürfen
    - Sicher sein, dass sie immer wahr sind! Quasi als formale Kommentare
    - z.B. wenn man bereits weiss, dass Preconditions erfüllt sind
    - Kein Ausführbarer code, bzw. keine Seiteneffekte! Assertions werden nicht immer ausgeführt
- Für Tests assertions abschalten, wenn sie in der Produktion auch disabled sind
