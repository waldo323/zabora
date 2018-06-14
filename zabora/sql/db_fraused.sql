SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET      verify OFF
SELECT
    CASE
        WHEN cant = TO_CHAR(0) THEN TO_CHAR(0)
        ELSE (
            SELECT
                TO_CHAR(space_used - space_reclaimable,'FM99999999999999990')
            FROM
                v$recovery_file_dest
        )
    END
FROM
    (
        SELECT
            TO_CHAR(COUNT(*) ) cant
        FROM
            v$recovery_file_dest
    );
QUIT;
