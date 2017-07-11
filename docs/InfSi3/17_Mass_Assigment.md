# Mass Assignment
## Vulnerability
- Ein MVC-Framework "bindet" Attribute aus HTTP-Requests an das Model und speichert es z.B. in der DB
- Das Model hat Attribute, die vom User gar nicht gesetzt werden dürfen und im Template nicht explizit angegeben sind, die aber trotzdem vom Framework gebindet werden

## Remediaton
- Die Attribute, die "gebindet" werden sollen, explizit angeben (Whitelisting) oder explizit ausschliessen (Blacklisting)
- "Strongly-Typed Approach": Mit einem Interface die nötigen Attribute für das Model definieren, bzw. das Model so designen, dass nur benötigte Felder exposed werden
    - oder z.B. im .NET das "read-only"-Attribut auf Properties setzen
