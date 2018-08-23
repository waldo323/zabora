SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TO_CHAR(trunc( (CAST( (from_tz(CAST(MAX(end_time) AS TIMESTAMP),sessiontimezone) AT TIME ZONE 'GMT') AS DATE) - TO_DATE('01.01.1970','DD.MM.YYYY') ) * 86400),'FM99999999999999990') retvalue
FROM
    v$rman_backup_job_details
WHERE
    status = 'COMPLETED'
    AND input_type = 'DB INCR';
QUIT;
