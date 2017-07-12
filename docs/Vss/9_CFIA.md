# Component Failure Impact Analysis (CFIA)

## Ziele
> The purpose of a CFIA is to provide information to ensure that the availability and recovery design criteria for new or existing IT services are influenced to prevent or minimize the impact of failure to the business operation and users

- Risiko-Analyse, um abzuschätzen, wie Ausfälle Einfluss auf die IT-Services haben können
- Impact bei Ausfall von Komponenten auf die Business Operations verhindern oder minimieren
- Zeit fürs Entdecken und Beheben von Ausfällen minimieren

## CFIA Matrix
- In vertikaler Spalte alle "Configuration Items" auflisten
    - Das sind Komponenten, Nodes, Applications, Links, etc.
    - Kann Hardware sein, aber auch das OS, ein bestimmter Prozess, Datenbanken, etc.
- In horizontaler Richtung die kritischen IT-Services auflisten
- Für jede Zelle ausfüllen:
    - Leer lassen, wenn Ausfall des CI keine Auswirkung auf Service hat
    - `X`, wenn bei Ausfall des CI der Service nicht verfügbar ist
    - `A`, wenn eine alternative CI automatisch übernehmen kann (z.B. Redundante Server)
    - `M`, wenn eine alternative CI existiert, aber von Hand eingegriffen werden muss
- Kritisch sind Komponenten mit vielen `X`, da ein Ausfall ein hoher Impact hat
- Kritisch sind auch Services mit vielen `X`, da sie komplex und Fehler-anfällig sind

### Erweiterung
- Für jede Komponente beschreiben
    - Wie kann sie ausfallen?
    - Wie kann ein Ausfall entdeckt werden?
    - Was sind Recovery Procedures?
- Sind die Prozesse dokumentiert? Können sie verbessert werden?

## Häufige Bereiche für Verbesserung
- SPOFs
- Ungenügende Dokumentation der IT-Services und Infrastruktur
- Ungenügends Monitoring
- Schwächen im Backup und Restore
- "Key Person" Dependencies: wenn nur einzelne Personen für kritische Services verantwortlich sind
