# Design by Contract
- Contracts legen Rechte (benefits) und Pflichten (obligations) zwischen zweier Parteien in einem formalen Dokument fest
- Design by Contract will dieses Prinzip auf SW anwenden
- Beziehungn zwischen "Kunden und Lieferanten", zwischen zwei Komponenten, werden durch Verträge geregelt
- Komponenten können Systeme oder Subsysteme (z.B. Klassen) sein
- [Einführung Konzept von Eiffel](https://www.eiffel.com/values/design-by-contract/introduction/)

## Pre-/Post-Conditons

- **Preconditions**: Bedingungen, die vor dem Aufruf einer Methode gelten (bei Klasse). Der Aufrufer ist dafür verantwortlich
- **Postconditions**: Bedingungen, die nach dem Aufruf gültig sind, verantwortlich ist die konkrete Implementation
- **Klasseninvarianten**: Garantien für einen Aufrufer, welche Eigenschaften vor / nach jedem Methodenaufruf gelten
    - oder: Allgemeingültige Postconditions für alle Methoden in einer Klasse

- Pre- und Postconditions werden nur auf der "supplier"-Seite definiert, also dem "Callee"
    - Grund: Kontext des Aufrufers ist verschieden, beim Supplier aber immer gleich

- In Eiffel werden Pre-conditions im `require`-Block, Post-conditions im `ensure`-Block definiert

- Der defensive Ansatz prüft die Pre-conditon in der Methode
- Der Ansatz von *Design by contract* geht davon aus, dass die Pre- und Post-conditions **erfüllt** sind, ohne sie explizit zu prüfen
- Pre- und postconditions dürfen Zustände des Systems abfragen, aber nicht verändern!

## Vollständigkeit
- Man kann eine Klasse nur auf ihren internen Zustand prüfen
    - Wenn z.B. eine Klasse eine Referenz auf eine andere Klasse hat, kann man nicht die internen Eigenschaften der Klasse "ausserhalb" prüfen

## Contracts und Vererbung
- Ein Subtyp muss mindestens den Contract der Superklasse erfüllen
    - Wegen Liskov's Substitution Principle: Eine Superklasse muss austauschbar durch die Subklasse sein
- Subtypen dürfen postconditons der Superklassen verstärken (eingrenzen) und preconditions schwächen (erweitern), aber nicht umgekehrt
