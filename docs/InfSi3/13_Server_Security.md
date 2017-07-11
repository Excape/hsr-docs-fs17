# Server Security

## Hardening
### Installing the System
- Minimal System
- Sepparate Partition for Logs
- Automatic Updates
- Strong defaults (`umask`, `PATH`, ...)

### Network Security
- Start only required Services
- Least File permission
- Least execution privileges
- Error Handling
- Disable direct internet access (anti covert channel)

### Authentication
- Strong Authentication (time-based lockouts)
- Monitor password-guessing (fail2ban)
- Login as user, root via `sudo`

### Monitoring / Auditing
- Time Synchronization
- Integrity Checking
- Forensic Readiness (see [WAF](12_Web_App_Firewall.md))
- Remote Logging

## SUID Flag
- Normalerweise hat ein Prozess, der von einem Binary erstellt wird, die Rechte des Aufrufers
- Wenn auf dem Binary das Suid-Flag gesetzt wurde, werden Prozesse immer mit Recht des File-Owners erstellt, egal wer sie aufruft
- Setzen mit owner Rechten: `chmod +s /usr/bin/passwd`
- siehe z.B. ` ls -la /usr/bin/passwd`
    - Mit der Shell können keine Scripts mit suid-Flag mit owner-Rechten ausgeführt werden! Es braucht ein Binary (z.B. C-File compilen)

## TLS
- `SSLHonorCipherOrder on` setzen, damit der Server die akzeptierten Ciphers erzwingt

## Apache Hardening
- Core-Prozess muss unter root laufen, worker-Prozesse unter apache-User (`wwwrun`)
- Workers haben keine Rechte auf Config und Log-Files und SSL, nur Read-Rechte auf `htdocs` (owner alle auf root)
- Saubere Trennung der Usergruppen vom Rest der System-User
- Kein World-Readable / Writeable!
- HTTPS: Geeignete Ciphers enforcen
