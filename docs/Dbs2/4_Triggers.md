# Triggers

## Anwedungen
- Berechnen von komplexen Konsistenzbedingungen
- Sicherheiten, z.B. das Änderungen an Tabelle X nur an Wochentagen ausgeführt werden können
- Sammeln von Statistik und Log-Daten
- Berechnen von abgeleiteten Attributen

## Eigenschaften
- Sind DB-Objekte und immer einer Tabelle zugeordnet
- Werden in Stored Procedures programmiert
- Sind parameterlos
- Werden beim Eintreten eines Events vom DBMS ausgeführt, nicht manuell

## Ausführung
- "Before" Triggers können Änderungen an einer Row vornehmen
- "After" Triggers können nur reagieren, der Returnwert wird ignoriert
- Triggers werden in alphabetischer Reihenfolge ausgeführt
- Wenn "Before"-Trigger als Rückgabewert NULL liefert, wird die Operation abgebrochen!

## Syntax
- Allgemein (Beispiel)
``` sql
CREATE | ALTER TRIGGER BEFORE | AFTER INSERT [OR UPDATE [OF attribute] [OR ...]]
ON table
FOR EACH ROW | STATEMENT
EXECUTE PROCEDURE mytriggerfunc();
```
- Trigger-Funktion (Procedure)
```sql
CREATE FUNCTION mytrigger_func()
RETURNS TRIGGER -- special meaning
AS $$
<<body>>
$$ language plpgsql;
```
- Die Eigenschaften eines Triggers, z.B. ob `BEFORE` oder `AFTER`, auf welche Operation getriggert wird, Name der Tabelle, etc. wird in Variablen der Funktion übergeben, alle mit dem Prefix `TG_`
- Mit der Variable `NEW` kann eine neue, leere Row gefüllt werden (nur bei INSERT UND UPDATE)
- Mit der `OLD`-Variable wird die "alte" Row angesprochen (nur bei UPDATE und DELETE)

## Beispiele
```sql
CREATE OR REPLACE FUNCTION dt_trigger_func()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        NEW.creation_date := now();
    ELSIF (TG_OP = 'UPDATE') THEN
        NEW.modification_date := now();
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;
```

### Before Delete
```sql
CREATE OR REPLACE FUNCTION delete_tbl_trigger_fn()
RETURNS trigger AS $$
BEGIN
    UPDATE tbl SET deleted=true WHERE id=OLD.id;
    RETURN NULL; -- Note RETURN NULL, not RETURN OLD!
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_tbl_trigger
BEFORE DELETE
ON tbl
FOR EACH ROW
EXECUTE PROCEDURE delete_tbl_trigger_fn();
```

### Abgeleitete Attribute
```sql
CREATE OR REPLACE function increment_salaer
( v_salaer IN Firma.SalaerSumme%TYPE)
RETURNS null
AS $$
BEGIN
    UPDATE Firma
    SET SalaerSumme = coalesce (SalaerSumme ,0) + v_salaer;
END ;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION berechne_SalSumme_trigger_fn()
RETURNS trigger AS $$
BEGIN
    IF TG_OP='DELETE' THEN PERFORM increment_salaer( -1 * OLD.salaer);
    ELSIF TG_OP='UPDATE' THEN
        PERFORM increment_salaer(NEW.Salaer-OLD.Salaer);
    ELSE /*inserting*/ PERFORM increment_salaer(NEW.salaer);
    END IF;
    RETURN null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER berechne_Salaersumme
AFTER INSERT OR UPDATE OF Salaer OR DELETE ON Angestellter
FOR EACH ROW
EXECUTE PROCEDURE berechne_SalSumme_trigger_fn();
```
### Auditing
```sql
CREATE OR REPLACE FUNCTION process_ang_audit() RETURNS
TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO ang_audit
            SELECT 'D', now(), user, OLD.name, OLD.salaer;
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO ang_audit
            SELECT 'U', now(), user, NEW.name, NEW.salaer;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO ang_audit
            SELECT 'I', now(), user, NEW.name, NEW.salaer;
    END IF;
    RETURN NULL;
    -- result is ignored since this is an AFTER trigger
END;
$$ language plpgsql;
```
