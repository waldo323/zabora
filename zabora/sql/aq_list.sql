SET	 pagesize 0
SET	 heading OFF
SET	 feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TRIM(name)
FROM
    dba_queues
WHERE
    queue_type = 'NORMAL_QUEUE'
    AND owner NOT IN (
        'SYS',
        'SYSTEM',
        'WMSYS',
        'SYSMAN'
    );
QUIT;
