SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TRIM(limit_value - current_utilization)
FROM
    v$resource_limit
WHERE
    resource_name = 'processes';
QUIT;
