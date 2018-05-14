SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
SELECT
    round(used_percent,2) pct
FROM
    dba_tablespace_usage_metrics
WHERE
    tablespace_name = upper('&1');
QUIT;
