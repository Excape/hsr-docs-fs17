# Objektrelatione DBMS
- Erweitert Relationale DBMS um OO-Konzepte
- Kennt komplexe Typen: Einem Attribut kann eine Menge von Werten zugeordnet werden
- Attribute können selbst Relationen sein
- Unterstützen anwendungsspezfische Typen (User defined types)
- Komplexe Typen können von Obertyp erben, genauso können Relationen vererbt werden

## Standardisierung
- SQL-Standard 1999 beinhaltet objekt-relatione Erweiterungen
- Definiert auch neue Basisdatentypen: BLOBs, CLOBs (Character large object), BFILE
- *Row Types* können mehrere Attribute in einem Attribut vereinen
    - Bsp: Attribut `address` beinhaltet `Number, Street, ZIP`
    - Zugriff über den Pfad: `address.number`
- Arrays möglich (`array[n]`)
- Row-Types und Arrays können verschachtelt werden
- Collection: `listof(type)`, `setof(type)`, `bagof(type)` (Bag erlaubt im Gegensatz zu einem Set Duplikate)
