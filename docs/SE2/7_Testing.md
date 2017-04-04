# Testing in grösseren Projekten

## Microtesting
- Je weiter oben im Layer, desto mehr muss gemockt / gefaked werden
- Testen einzelne Teile in Isolation -> Gegensatz zu Integrationtests!

## Integration-Test
- Möglichst hoch oben in den Layers
- Unit-Tests!
- Sind in der Regel die "besseren Tests" als Microtests, weil sie realistischere Szenarien testen
- Geht womöglich durch alle Schichten durch, ohne Mocking
- Im Exambiur z.B. auf Ebene Service
- Können Teil der Ent-to-End-Tests ersetzen, dort muss dann nur noch die Darstellung getestet werden, nicht die Logik
- Framework: <https://cucumber.io/>

### "Lokales Minimum"-Effekt
- Wenn viele Unit-Tests vorhanden sind, verleitet es zu weniger "grobem" Refactoring, da dadurch die Unit-Tests kaputt gehen
- Man versucht nur, lokal zu optimieren, anstatt Architektur zu refactoren, und sieht die "grosse" Lösung nicht

## Wann haben wir genug getestet?
- Keine der Antworten sagt viel aus
- Aber was denn sonst?
- Konnt stark auf den Kontext an: Ist es ein medizinisches System, oder nur eine simple Website?

## Testabdeckung
### Statement Coverage
- Test Coverage Tools messen nur Statement-Abdeckung, welcher Anteil aller Statements wurden von einem Test durchlaufen?
- Statement-Abeckung ist einfach zu ermitteln, aber die wenigst aussagekräftige

### Branch Coverage
- Jedes `If` ergibt 2 Zweige: Eine für Condition erfüllt und eine für `else`
- Branch Coverage (Zweigabdeckung) zählt die Anzahl abgedeckten Zweige / Gesamtzahl der Zweige
- Bei Loops und Ifs auch testen, wenn Body gar nie ausgeführt wird
    - Fehlerquellen, wenn im Zweig Seiteneffekte entstehen

### Decision Coverage
- Bedinungsabdeckung prüft, welche Entscheidungen einmal auf `true` und eimal auf `false` getestet wurden
- Bei `If`s und Loops mit mehreren Bedingungen gibt es entsprechend für jede Bedingung zwei Tests

### Path Coverage
- Alle möglichen Kombinationen von Pfaden im Zweig-Graphen
- Führt schnell zu unendliche Anzahl Kombinationen!

## Server Setup
- TEST: Test-Server für Entwickler, auch z.B. für Performance-Tests
- ACC: Acceptance-Server / Staging Server  für Kunden zum Ausprobieren
