# IAM
- Identity (User name, User attribute)
- Authentisierung
- Autorisierung
- InfSi1: IAM im Intranet (AD, Kerberos ticket)
    - Ziel: Single-Sign-On
- Heute: Internet
    - Ziel: Single-Sign-on im Internet

## Federations
- Verbund lose gekoppelten Organisationen (vgl. Schweiz)
- "make identity and entitlements *portable* across autonomous identity domains"
- "disparate systems": Unterschiedliche Systeme arbeiten auf Security-Ebene zusammen
- Federation sollte Sicherheitsstandards erfüllen, die die Identity Provder erfüllen sollen

### Authentication & Authorization Infrastructure (AAI)
- Ohne AAI macht jeder Service eigene Authentiation und Authorization
- Mit AAI: In der "Federation" gibt es mehrere Identity Provider
    - HSR hat einen Identity Provider, Universitäten zusammen sind Federation
- Service Provider machen nur noch Autorisierung
- Der Benutzer meldet sich nur noch bei seinem Identity Provider an
- Die Service Provider wissen nichts über die Identität, er kann nur Benutzer-Attribute anfodern
- Identity Provider haben Zertifikate von Service Providern

## Shibboleth
- Open Source Middleware zur Implementation von Federations
- Für Web-Anwendungen (HTTP), basierend auf Redirections
    - Auch über HTTP sicher
- User Attribute werden SAML-Verschlüsselt im Header übertragen
- IdPs können Pseudonyme ausgeben (zufällige ID), die für verschiedene Service Provider unterschiedlich sind

1. User greift auf Ressource zu
2. Umleitung auf Discovery Service (z.B. Auswahl Schule)
3. Umleitung wieder auf Ressource-Server (Dieser kennt den IdP)
4. Ressource schickt Authentication Request an IdP
5. User authentisiert sich bei IdP mit User Credentials
6. IdP stellt Identität aus (zeitbegrenzt)
7. Mit dieser Identität kann der User auf die Ressource zugreifen

- Daten werden über XML übertragen
- Identität wird mit SAML 2.0 beschrieben
- Ziel: XML schützen
- Es gibt W3C Standards für Signierung und Verschlüsselung

## SAML
- Secure Assertion Markup Language
- "Eierlegende Wollmilchsau"

## SuisseID
- SAML 2.0 Application
- "Qualifizierte Signatur"
- SwissSign und QuoVadis sind IdPs
- Im Zertifikat sind nur die nötigsten Infos drin (Name, Firma, Seriennummer)
- Restliche Daten sind als Attribute hinterlegt

## OAuth2
- *Autorisierungs*-Protokoll, macht nicht Authentication!
- User (Resource Owner) gibt einer dritten Stelle (client) das Recht, auf eine Ressource (Resource Server) zuzugreifen
- Ohne Crypto built-in, Sicherheit vertraut auf TLS
- Authentication und Schutz gegen MitM fehlt

## OpenID Connect
- Authentication Layer on Top of OAuth2
- REST statt SOAP, JSON statt XML
- Signaturen mit JWS (JSON Web Signature)
- Encryption mit JWE (JSON Web Encryption)
