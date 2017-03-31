# CORS
> Cross Origin Resource Sharing


- Ziel: Cross-Site-Requests erlauben, um z.B. per AJAX von einem anderen Server Daten zu laden
- Alternative mit `<script src=".." />`, ist aber gefährlich, weil es in der gleichen Security Domain wie unsere App ausgeführt wird!

!!! warning
    Kein Schutz gegen XSS!

- Der Browser schickt mit dem AJAX-Request einen `Origin: mySite` header mit der Origin der Seite
- Der Server (API) kann entscheiden, ob die Origin erlaubt ist
- Der Server der API, auf die zugegriffen werden möchte, setzt den Header `Access-Control-Allow-Origin: mySite` bei der Antwort

## Pre-flight request
- Problem: Bei der Antwort des Server weiss der Client noch nicht, ob er Cross-Domain damit kommunizieren kann
- Der Client schickt vor dem ersten eigentlichen Request einen `OPTIONS`-Request an den Server
- Der Server antwortet mit den verfügbaren HTTP-Methoden *und* dem `Access-Control-Allow-Origin`-Header
- Nun weiss der Browser, ob er mit dem Server kommunizieren kann
- Nicht alle CORS-Requests brauchen einen Pre-flight-Request, es ist standardisiert welche (z.B. Multipart form und alle Methoden ausser GET, POST und HEAD)
- Wird vom Browser automatisch gemacht

## Angriffsvektor
- Wenn der Angreifer den Browser kontrolliert, kann er den `origin`-Header manipulieren. Der Server könnte das aber irgendwann merken
- Im grossen Stil ist der Angriff nicht wirkungsvoll
