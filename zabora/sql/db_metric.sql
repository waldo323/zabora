SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
        CASE metric_name
            WHEN 'SQL Service Response Time'   THEN round( (average / 100),2)
            WHEN 'Response Time Per Txn'       THEN round( (average / 100),2)
            ELSE average
        END
    average
FROM
    sys.v_$sysmetric_summary
WHERE
    metric_id = '&1';
QUIT;
