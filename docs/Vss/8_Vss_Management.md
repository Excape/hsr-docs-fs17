# VSS Management

## System Management
- Zu Systems Management gehört u.a.
    - Software distribution
    - version control
    - Backup / Recovery
    - Performance Monitoring
    - Network Management
- Zu *Configuration Management* gehört das Dokumentieren des Systems und Nachverfolgbarkeit, damit frühere Versionen maintained werden können
- Ein Service Management Framework ist z.B. *ITIL*


### Patterns für message-basierte Software
#### Wiretap
Einen Message-Channel "abhören", indem die Messages neben dem Ziel auch an einen zweiten Channel zur Inspektion gesendet werden

#### Detour
Nicht alle Messages werden direkt ans Ziel gesendet, sondern an eine Zwischenstelle, die Validierung, Debugging o.ä. vornimmt. Ein Router entscheidet, welche Messages über diese "Detour" und welche direkt an das Ziel gesendet werden

#### Test Message
Eine Art Black-Box-Test, in dem Test Messages ins System gefüttert werden, und hinterher geschaut, welche Messages raus kommen. So können interne Verarbeitungs-Fehler erkannt werden

#### Smart Proxy 
- In Systemen, in der Messages vom Absender mit einer Return-Adresse versehen werden
- Analog zu einem Web-Proxy: Er ändert die Returnadresse zu sich selbst, und leitet die Antwort schliesslich zum originalen Absender wieder
- Proxy hat dann Einsicht in die Messages

#### Message Store
Für jede Message wird jeweils eine Kopie an einen zentralen Message Store gesendet. Dieser speichert dann die gesamte oder Teile der Message

#### Message History
Die Message trägt eine History auf sich (im Header), von welchen Applikationen sie bereits vearbeitet wurde. Dies erleichtert debugging, da man den Weg der Message verfolgen kann.

#### Channel Purger
Ein Filter, der gewisse "verbliebene" Messages verwirft, damit das System wieder in einen konsitenten Zustand versetzt wird.

## Java Management Extensions (JMX)
- Java Technologie, um Applikationen, System-Objekte und Devices zu managen
- Jedes Objekt ist ein *MBean* (Managed Bean)
- Der Standard JMX-Client ist `jconsole`

## Logging
### Herausforderungen
- Easy to use, wiederverwendbar
- Zentralisiert, damit der Administrator es an einem Ort einsehen kann
- Nur wenig Performance-Einbussen auf die Applikation
- Filterung nach Konfiguration für verschiedene Typen

### Tipps
- Logging Framework benutzen (z.B. `log4j`)
- Mehrere Log levels (`debug`, `info`, `warning`, `severe`)
- `slf4j` als Wrapper benutzen, damit das konkrete Logging-Framework abstrahiert wird und später geändert werden kann
- In Logs "W"-Fragen beantworten: Wo ist was, wie, wann und von wem passiert? etc.
