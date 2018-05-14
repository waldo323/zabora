SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
SELECT
    COUNT(*)
FROM
    gv$log_history
WHERE
    TO_CHAR(first_time,'YYYY-MM-DD HH24') = TO_CHAR(SYSDATE,'YYYY-MM-DD HH24');
QUIT;
