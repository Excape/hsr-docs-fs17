# Operationale Modelle, Design for Performance

## Non-Functional Requiremenets
- **Constraints**: Limitationen, äussere Einflüsse und das Umfeld des Kunden, z.B. auch Standards und Regulierungen
- **Qualities**: "Service Level Requirements", sind messbar, z.B. Performance, Security, Portability, Reliability, etc. etc.

- *Wie* bringt ein System seine Funktionalität? (Nicht "was macht es")
- QOS ist eine Abwägung zwischen Risiko und Kosten
    - Werden Anforderungen nicht erfüllt, gibt es Business Risiken
    - Wird over-engineered, gibt es unnötige Kosten

## Performance
> "The degree to which a system or component accomplishes its designated functions within given constraints, such as speed, accuracy, or memory usage."

- Hauptziele von Performance sind schnelle Antwortzeiten und *Predictability*
- Nicht immer ist schneller besser, manche Systeme brauchen auch eine sehr konsistente Performance (z.B. real-time)

- Für schnelle Antwortzeiten braucht es genüged Durchsatz (z.B. Transaktionen pro Sekunde)
- Für genügend Durchsatz braucht es genüged Kapazität (Scalability)

## Functional / Operational Model
- Functional Model: Die funktionalen Komponenten eines Systems
- Operational Model: Das System, auf das die Komponenten deployed werden (Infrastruktur)
