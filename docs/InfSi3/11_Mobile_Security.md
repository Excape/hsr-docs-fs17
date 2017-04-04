# Mobile Security

## iOS Bascis
- iOS ist Subset von OS X mit gleichen Libraries
- Objective-C, Swift und C kann gemischt werden
- Jede App ist gekapselt durch Sandboxing
- Secure Boot Chain
    - LLB: Low-Level Bootloader
    - Jeder Schritt überprüft die Signatur des nächsten
- Berechtigungen werden einzeln erfragt

### Data Protection API
- File-System-Key: Wird bei einem Wipe gewechselt, dann können die verschlüsselten Daten nicht mehr gelesen werden
- Es gibt unterschiedliche Class Keys, die zu unterschiedlichen Zeiten im Memory sind, z.B. wenn das Gerät entsperrt ist oder gesperrt

### Keychain API
- Durch Hardware-Key geschützt (eigener Chip)
- Jede App kann in ihrer Sandbox gehörenden Secrets lesen
- Kann ähnlich wie Class Keys gesteuert werden, wann sie verfügbar sein sollen 
- Seit iOS 7 können solche Secrets auch mit dem Fingerprint gesichert werden

## Android Basics
- SELinux seit Android 4.4
- Für alternative Stores (z.B. Amazon) muss Installation von fremden APKs aktiviert werden - Sicherheitsriskio
- jede App läuft in eigener JVM
- KeyStore API seit 4.3 - ähnlich zu iOS

## OWASP Mobile Top 10

### M1: Improper Platform Usage
- Platform-Features für Sicherheit nicht oder falsch benutzen
- Guidelines (unabsichtlich) nicht einhalten
- Zu viele Permissions geben
- z.B. Schlüssel nicht in KeyChain API speichern, sondern unverschlüsselt in ein Property-File

### M2: Insecure Data Storage
- Unsicherer Data Store, wenn Gerät verloren wurde oder mit jailbreak / root
- Leakage durch Sidechannels
    - z.B. Screenshots der "recent apps" View
    - Bei iOS und Adroid können diese Screenshots bearbeitet werden

### M3: Insecure Communication
- Unsichere Kommunikationskanäle
- z.B. alte TLS-Versionen, schwache Ciphers, clear-text
- Certificate Pinning verwenden
    - Public-Key des Servers in der App hinterlegen
    - In Android und iOS über Standard-APIs

### M6: Insecure Authorization

### M7: Client Code Quality
- XSS, SQL-Injection, ...

### M8: Code Tampering
- Monkey-Patching
- Jailbreaking / Rooting
    - Detection auch möglich, indem z.B. nach shell-skripts gesucht wird
- Method Swizzling
    - Methoden werden vertauscht
- In Objective-C werden alle Methoden-Aufrufe über eine zentrale Methode geschickt, die Messages verschickt
    - diese können mit jailbreak überschrieben werden
    - Besser in Swift

### M9: Reverse Engineering
- Code Reversing
- Disassembly
- Bei Android Code Obfuscating im SDK dabei
- Android kompiliert Java zu "smali" Code bis Android 5
    - Mit `dex2jar` kann es auch zu normalen Class-files kompiliert werden
- Seit Android 5 Android Runtime
    - Kompiliert code bei Installation zu native code
    - DEX-File ist immer noch im APK - Reverse Engineering gleich möglich
