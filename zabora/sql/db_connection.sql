SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
SELECT
    TRIM(limit_value - current_utilization)
FROM
    gv$resource_limit
WHERE
    resource_name = 'processes';
QUIT;
