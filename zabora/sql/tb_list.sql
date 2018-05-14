SET	 pagesize 0
SET	 heading OFF
SET	 feedback OFF
SET	 verify OFF
SELECT
    TRIM(tablespace_name)
FROM
    dba_tablespaces
WHERE
    contents NOT IN (
        'UNDO',
        'TEMPORARY'
    );
QUIT;
