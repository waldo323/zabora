SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TO_CHAR(v.waiting + v.ready,'FM99999999999999990') sum_open
FROM
    dba_queues q,
    v$aq v
WHERE
    q.qid = v.qid
    AND q.name = '&1';
QUIT;
