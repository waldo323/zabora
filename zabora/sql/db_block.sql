SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    COUNT(*)
FROM
    gv$session_blockers a,
    v$session v
WHERE
    a.blocker_sid = v.sid
    AND   v.username IS NOT NULL
    AND   EXISTS (
        SELECT
            1
        FROM
            v$session v2
        WHERE
            a.sid = v2.sid
            AND   v2.username IS NOT NULL
            AND   seconds_in_wait / 60 >= 1
    );
QUIT;
