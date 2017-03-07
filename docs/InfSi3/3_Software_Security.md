# Software Security
## The Trinity of Trouble
- **Connectivity**: Immer mehr verbundene Geräte
    - Software wird als Service publiziert, die nie dafür gedacht war
- **Extensibility**: Viele software wird modular
    - Durch Plugins erweiterbar, z.B. Browser
- **Complexity**: Moderne Software ist komplex
    - z.B. Betriebssysteme, Runtimes
    - Anzahl Fehler steigt etwa quadratisch zu Anzahl Codezeilen

## Defects = Bugs + Flaws
- **Bug**: Implementations-Fehler, der sich relativ leicht beheben lässt
- **Flaw**: Design-Fehler in der Software, nur schwer zu finden / zu fixen
- In der Praxis sind solche Defects 50/50 geteilt in Bugs und Flaws

## Best Practices
- Penetration ist nicht die effizienteste Massnahme, da die Fehler erst spät in der Entwicklung gefunden werden und so die Kosten enorm steigen
- Statische Code Analyse
    - z.B. mit Coverity (für Github projekte kostenlos)

### Architectural Risk Analysis
- Architektur auf einer Seite zusammen fassen ("Flipchart")

#### Attack Resistance Analysis
- Ansatz mit Checklisten
- Gut für bekannte Schwachstellen und Angriffe
- Schlecht für neue Attacken / 0-days

#### Ambiguity Analysis
- Von dritter Seite wird die Software und Architektur studiert
- Gut, um Widersprüche und Fehler im Design zu finden

#### Weakness Analysis
- Verwendete Libraries und Frameworks analysieren

## Microsoft Security Development Lifecycle
- [SDL - Simplified Version](www.microsoft.com/sdl/) lesen!
- Best Practises des SDL kennen
- Threat Modeling = Risk Analysis

- Fuzzing: Zufällige Input-Daten für Testfälle, dafür sehr viele verschiedene Inputs
