# Objektorientierte DBMS
- Nimmt OO-Konzepte und erweitert sie um DB-Konzepte
- Anforderungen: OO-Modell (Complex Objects, inheritance, overriding, etc.) mit ACID-Kriterien auf der Datenbank

## Speicherstrukturen
- Im Gegensatz zu RDBMS müssen Objekte nun nicht mehr in ein relationales Schema übersetzt werden, der Datentransfer ist "direkt"
- Der Query-Code ist nun Aufgabe des Clients, von der Datenbank werden nur noch die Daten zurück gegeben
- Programmiersprache und OODBMS arbeiten mit dem gleichen Typensystem
- Clustering: Komplexe Objekte sollten möglichst auf der gleichen Page liegen, damit die Abfrage effizient ist

## Vor- und Nachteile
- Nur noch ein Datenschema notwendig
- Datentypen müssen nicht mehr gemappt werden, sollten identisch sein
- Neue Technologien: Objektversionierung, Array-Datentypen

Nachteile:
- Query Language oft primitiver als SQL
- Mangel an "kommerziellen" Datentypen wie Datum / Zeit
- Wenig ausgereift

## ODMG-Standard
- Standardisierung der *Object Database Management Group*
- Definiert Standards für das Object Model, ODL, Query Language, Bindings für Java / C++ etc.
- Letzte Version 3.0, in Java von *Java Data Objects* abgelöst
- ODL definiert eine Sprache zur Beschreibung des Datenmodells
- OQL operieren auf Collections (SQL: Menge von Tupels)
    - Sprache ähnlich wie SQL

## Persistence
- "Persistence by Reachability"
- Wenn ein Objekt geladen oder persistiert wird, gehören alle Objekte dazu, die irgendwie von diesem "Root" Objekt aus erreichbar sind
- "If Object A references Object B, and Object A is persistent … then Object B becomes persistent automatically."
- Die maximale "Tiefe" ist konfigurierbar
- Vorteil: Grosse Objektbäume können mit einem Aufruf geladen werden

## When to use ODBMS
- <http://www.odbms.org/introduction-to-odbms/when-to-use-an-odbms/>
- Mobile Clients (Zugriffe einfach und günstig)
- Komplexe Relationen, die schwer mit RDBs zu modellieren sind
- Tiefe Objektstrukturen, die z.B. komplexe Bäume darstellen
- In einer OO-Umgebung - Kein mapping mehr
- Datenzugriff über Navigation: Navigieren durch die Objektstruktur ist günstig, es braucht keine Joins
