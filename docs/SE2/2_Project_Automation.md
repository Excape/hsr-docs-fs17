# Project Automation
!!! note
    kontakt: mmeili

Leitsatz: "Automate everything you need to do more than once"

## Idee: Build-Script
- Pro
    - Compile, unit test, package, integration test, deploy automatisiert
    - Wiederholbar
    - can automatisch scheduled werden
- Con
    - non-interactive process, man kann nicht eingreifen
    - Maintenace und Erweiterung ist mühsam
    - Meist platform-abhängig (Batch, bash)

## Ziele
- **CRISP**
    - Complete: Jeder Build wird von neu auf aufgebaut
    - Repeatable: Wiederverwendbar, auch mit älteren Versionen
    - Informative: Feedback über den Prozess, z.B. Testresultate
    - Schedulable
    - Portable: Nicht nur auf lokaler Maschine ausführbar
- Flexibilität: Indiviuelle Tasks ausführen

## Build Tools
### Imperative Build Tools
- Make-Familie: Den DA-Graphen wird explizit definiert (Abhängigkeiten)
- Pros
    - Sehr flexibel und mächtig
- Cons
    - Komplexe Definitionen
    - Schwierig wiederzuverwenden
    - Viel copy-paste

### Declarative Build Tools
- z.B. Maven, Gradle
- Deklarativ: Wie soll das Ergebnis aussehen?
- Convention over Configuration (nur konfigurieren, was nicht default ist)
- Projekt-Struktur ist meist default vorgegeben
    - resources-Verzeichnis ist read-only!
- Pros
    - Kürzere files
    - Wiederverwendbare Logik
    - Dependeny Management
- Cons
    - Weniger flexibel
    - Strenge Projektstruktur

## Continuous Integration
1. Maintain a single source repository
2. Automate the build
3. Make the build self-testing
4. Everyone commits to the mainline every day
5. Every commit to the mainline should be built
6. Keep the build fast
7. Test in a clone of the production environment
8. Make it easy to get the latest deliverables
9. Everyone can see what’s happening
10. Automate deployment
