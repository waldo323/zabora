SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
SELECT
    COUNT(*)
FROM
    dba_objects o
WHERE
    status != 'VALID'
    AND   NOT EXISTS (
        SELECT
            1
        FROM
            dba_snapshots s
        WHERE
            s.name = o.object_name
            AND   s.status = 'VALID'
    )
    AND   o.object_name NOT LIKE 'BIN$%'
    AND   o.object_type <> 'SYNONYM';
QUIT;
