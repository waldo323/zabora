SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TO_CHAR(ta.used_space * tb.block_size,'FM99999999999999990') AS bytes
FROM
    dba_tablespace_usage_metrics ta
    JOIN dba_tablespaces tb ON ta.tablespace_name = tb.tablespace_name
WHERE
    ta.tablespace_name = upper('&1');
QUIT;
