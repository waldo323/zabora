SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TO_CHAR(trunc(MAX( (end_time) - TO_DATE('01-JAN-1970','DD-MON-YYYY') ) * (86400) ),'FM99999999999999990') retvalue
FROM
    v$rman_backup_job_details
WHERE
    status = 'COMPLETED'
    AND input_type = 'DB INCR';
QUIT;
