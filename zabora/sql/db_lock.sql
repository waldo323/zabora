SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    COUNT(*)
FROM
    v$session,
    dba_waiters
WHERE
    seconds_in_wait / 60 >= 1
    AND   state = 'WAITING'
    AND   sid = holding_session;
QUIT;
