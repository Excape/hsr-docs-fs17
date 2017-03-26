# SQL Injection

## Blind SQL-Injection
- Der Server liefert auf einen SQL-Injection-Angriff keine Fehlermeldung
- Angreifer kann aber z.B. "Benchmarks" probieren auszuführen, die lange zum Berechnen haben. Wenn die Antwort länger als erwartet dauert, hat die Injection wahrscheinlich funktioniert ("Time based SQL Injection")

## Mitigation
- **Prio 1**: 
    - Prepared Statements
    - Proper Error Handling
- Prio 2:
    - Web Application Firewall (filtert Inputs)
    - DB-Privilegien (nicht mit root!!)
