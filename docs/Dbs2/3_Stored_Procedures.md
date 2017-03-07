# Stored Procedures / pgSQL

## Stored Procedures
- Funktionen, die auf dem DBMS "nahe den Daten" ausgeführt werden
- Können wiederum von anderen SP, Trigger oder PL/SQL ausgeführt werden
- Sind Datenbankobjekte
- Haben eigenes Recht zur Ausführung
- PL: Prozedurale Sprache für Datenbanken

```sql
CREATE OR REPLACE FUNCTION increment(i INT)
RETURNS INT AS $$
BEGIN
RETURN i + 1;
END;
$$ LANGUAGE plpgsql;

-- use
SELECT increment(10); -- 11
```
- Variablen deklarieren in `DECLARE` Block
- Gefolgt von Logik zwischen `BEGIN` und `END`
- SQL kann direkt eingebettet werden
- IF: `IF expression THEN statements ELSIF cond THEN ... END IF;`
- Exceptions:

```sql
EXCEPTION
WHEN type THEN statement;
WHEN other_type THEN statement;
```

### Select .. Into
```sql
DECLARE
    AngNr Angestellter.PersNr%TYPE;
    -- Typ von Angestellter.PersNr
BEGIN /*lokaler, anonymer Block */
    SELECT Angestellter.PersNr INTO STRICT AngNr
    FROM Angestellter
    WHERE Angestellter.Name = 'Marxer, Markus';
END
```

### Insert ... into
```sql
DECLARE
    PNr Projekt.ProjNr%TYPE;
    AngNr Angestellter.PersNr%TYPE;
    ProzAnt DECIMAL;
BEGIN
--....
    INSERT INTO ProjektZuteilung
    VALUES (AngNr, PNr, ProzAnt, NULL, NULL);
EXCEPTION
    WHEN unique_violation THEN
    /*Projektzuteilung existiert bereits*/
END;
```
- `FOUND` wird `true`, wenn Row gefunden wurde
- In PostgreSQL Terminologie
    - "Stored Procedure" = "Function" mit Returnwert void

### Return Table
```sql
CREATE OR REPLACE FUNCTION get_AbtMA (nr integer)
    RETURNS TABLE (
        abtname VARCHAR,
        abtMA VARCHAR
    )
AS $$
BEGIN
    RETURN QUERY
    SELECT abt.name, ang.name FROM abteilung abt
    join angestellter ang on ang.abtnr=abt.abtnr
    where abt.abtnr=nr
    order by abt.name, ang.name;
END;
$$ LANGUAGE plpgsql;
```

### Return a Set
- Return a set of rows
```sql
CREATE OR REPLACE FUNCTION getAllFoo()
RETURNS SETOF foo AS $$
DECLARE
    r foo%rowtype; -- foo ist tabelle
BEGIN
    FOR r IN SELECT * FROM foo WHERE fooid > 0
    LOOP
        -- do something...
        RETURN NEXT r; -- return current row of SELECT
    END LOOP;
    RETURN;
END
$$ LANGUAGE 'plpgsql';
```

## Cursor
- Ein Cursor zeigt auf ein Tupel in einem ResultSet

1. Cursor deklarieren in `DECLARE`

```sql
AngCursor (abtNr integer) CURSOR FOR
    SELECT Salaer, PersNr FROM Angestellter
    WHERE Angestellter.AbtNr = abtNr;
```
2. Cursor öffnen: `OPEN AngCursor(2)`
3. Fetch records
```sql
LOOP /*Iteration ueber Resulatmenge*/
    FETCH AngCursor INTO AngSalaer, AngPersNr;
    EXIT WHEN NOT FOUND
    SalSumme := SalSumme + AngSalaer;
    RAISE notice 'Angstellter PersNr: % Salaer %',
    AngPersNr, AngSalaer;
END LOOP;
```
4. Cursor schliessen: `CLOSE AngCursor`

### Cursor für UPDATE
```sql
AngCursor CURSOR FOR
    SELECT Salaer, Chef, PersNr FROM Angestellter
    WHERE Angestellter.AbtNr=CurrAbtNr
    FOR UPDATE;
OPEN AngCursor;
LOOP
    FETCH AngCursor INTO AngRec;
    EXIT WHEN NOT FOUND;
    UPDATE Angestellter SET Salaer = MinSalaer
    WHERE CURRENT OF AngCursor; -- <---
END LOOP;
CLOSE AngCursor;
```
