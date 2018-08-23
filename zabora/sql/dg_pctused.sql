SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    round( ( (total_mb - free_mb) / total_mb) * 100,2) AS pct
FROM
    v$asm_diskgroup_stat
WHERE
    name = upper('&1');
QUIT;
