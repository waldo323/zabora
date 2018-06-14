SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
SELECT
    TO_CHAR(COUNT(*),'FM99999999999999990') retvalue
FROM
    dba_jobs
WHERE
    broken = 'Y';
QUIT;
