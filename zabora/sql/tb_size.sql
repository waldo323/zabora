SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
SELECT
    byte
FROM
    (
        SELECT
            SUM(bytes) AS byte
        FROM
            dba_data_files
        WHERE
            tablespace_name = upper('&1')
        UNION ALL
        SELECT
            SUM(bytes) AS byte
        FROM
            dba_temp_files
        WHERE
            tablespace_name = upper('&1')
    )
WHERE
    byte IS NOT NULL;
QUIT;
