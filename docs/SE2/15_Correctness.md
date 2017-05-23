# Proving Programs Correct

- Bis jetzt: Unit testing, um Korrektheit zu prüfen
- Kann nicht alle Bugs finden: Wie weiss man, welche Tests "gut genug" sind?
- Ziel: Programm wie eine mathematische Formel formell beweisen
- Scope dieser Vorlesung: Imperative single-thread Programme
- Ansatz in Dafny: "Desing-by-Contract", man definiert Post-conditions, die vom Compiler überprüft werden

## Hoare Triples
- \({P} C {Q}\)
- \(P\) ist Precondition, \(C\) Programm / Command, \(Q\) ist Postcondition
- Correctness-Aussage: Wenn \(P\) erfüllt ist, wird durch \(C\) die Postcondition \(Q\) erfüllt
- Diese Aussage ist selbst ein "boolean" (Predicate): Kann wahr oder falsch sein
-
## Inference Rules
- \([x := E\) -> \(x\) wird durch \(E\) ersetzt
