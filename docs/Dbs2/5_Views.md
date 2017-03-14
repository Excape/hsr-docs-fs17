# Updatable / Materialized Views

## Views
- Externe Sichten für Applikationen
- Verringern die Komplexität von Queries
- Sind "updatable", wenn gewisse Einschränkungen erfüllt sind
    - Einen Eintrag in der FROM Klausel
    - Keine WITH, GROUP BY, LIMIT, OFFSET, etc
    - keine UNION, INTERSECT, EXCEPT
    - Keine Aggregation oder Window-Funktion
- Es müssen nicht alle Felder updatable sein, die View kann dann immer noch mit UPDATE bearbeitt werden, aber logischwerweise nicht die "nicht-updatable" Felder

### Beispiel Updatable
```sql
create view ourview1 as
    select name, abtnr, salaer
    from angestellter
    order by abtnr, salaer desc;

update ourview1 set salaer=salaer+10;
```

### Beispiel NICHT updatable
```sql
create view ourview2 as
    select abtnr, avg(salaer) as salaer
    from angestellter
    group by abtnr;
update ourview2 set salaer=salaer+10;
-- Fehler, view enthält groupby
```

## Instead-of-Triggers
- Werden anstelle der ursprünglichen SQL-Operation ausgeführt
- Können für Modifikationen auf Tables und Views ausgeführt werden
- Leiten insert, update, delete auf Views auf die darunterliegenden Tabellen weiter

### Beispiel
```sql
CREATE OR REPLACE VIEW abtleiterinfo (abtnr, abtname, abtchef)
AS
    SELECT abt.abtnr, abt.name, al.abtchef
    FROM abteilung abt
    INNER JOIN abtleitung al
        ON abt.abtnr=al.abtnr
    INNER JOIN angestellter ang
        ON ang.persnr=al.abtchef;
```
```sql
CREATE OR REPLACE FUNCTION abtleiterinfo_update_abtchef_fn()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        UPDATE abtleitung SET abtchef=NEW.abtchef
            WHERE abtnr=OLD.abtnr;
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;
```
```sql
CREATE TRIGGER abtleiterinfo_update_abtchef
INSTEAD OF UPDATE ON abtleiterinfo
FOR EACH ROW
EXECUTE PROCEDURE abtleiterinfo_update_abtchef_fn();
```
```sql
UPDATE abtleiterinfo SET abtchef=1019 WHERE abtnr=2;
```

## Materialized View
- Eine normale View wird bei jedem Aufruf (Query) neu berechnet
- Eine *Materialized View* wird gecached und nur periodisch neu berechnet

```sql
CREATE MATERIALIZED VIEW view_name
AS
<query>
WITH [NO] DATA;
```
- Mit `NO DATA` wird die View initial nicht geladen und kann erst gelesen werden, wenn sie das erste Mal refreshed wird
- View neu laden:

```sql
REFRESH MATERIALIZED VIEW view_name;
```

## Zugriffsschutz mit Views
- Auf Views können eigene Berechtigungen vergeben werden
- Somit kann z.B. einem user Zugriff auf eine unterliegende Tabelle verwehrt bleiben, er kann aber über eine View bestimmte Attribute der Tabelle sehen

```sql
CREATE VIEW AngPublic (Persnr, Name, Tel, Wohnort)
AS
SELECT Persnr, Name, Tel, Wohnort
FROM Angestellter;
GRANT SELECT ON AngPublic TO PUBLIC;
```
- In der View kann z.B. `user` verwendet werden, um Daten spezifisch für den angemeldeten Db-User anzuzeigen

```sql
CREATE OR REPLACE VIEW Angestellter_V AS
SELECT a.*
FROM Angestellter a
WHERE a.login = user
```
- Zugrifsschutz einer Tabelle kann auch über Stored Procedure realisiert werden. Dazu wird vom Table-Owner eine Stored Procedure erstellt, die eine Tabelle verändert, und anschliessend Ausführungsrechte an andere User erteilt. Die Stored Procedure werden immer mit den Rechten des Erstellers ausgeführt

```sql
GRANT EXEC ON SalaerErhoehung TO PersonalChef_R;
```

## Temporäre Tabellen
- Erstellt eine Tabelle, die am Ende der Session oder der Transaktion gelöscht wird

```sql
CREATE TEMPORARY TABLE tmp AS
    SELECT generate_series(1,100000) AS a;
```
