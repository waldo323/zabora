SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET      verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TO_CHAR(
        CASE
            WHEN inst_cnt > 0 THEN 1
            ELSE 0
        END,'FM99999999999999990') retvalue
FROM
    (
        SELECT
            COUNT(*) inst_cnt
        FROM
            v$instance
        WHERE
            status = 'OPEN'
            AND   logins = 'ALLOWED'
            AND   database_status = 'ACTIVE'
    );
QUIT;
