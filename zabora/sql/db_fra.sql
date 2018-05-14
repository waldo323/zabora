SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET      verify OFF
SELECT
    CASE
        WHEN cant = 0  THEN 0
        ELSE (
            SELECT
                DECODE(nvl(space_used,0),0,0,ceil( ( (space_used - space_reclaimable) / space_limit) * 100) )
            FROM
                v$recovery_file_dest
        )
    END
FROM
    (
        SELECT
            COUNT(*) cant
        FROM
            v$recovery_file_dest
    );
QUIT;
