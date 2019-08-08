SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TO_CHAR(total_mb * 1024 * 1024,'FM99999999999999990') AS bytes
FROM
    v$asm_diskgroup_stat
WHERE
    name = upper('&1');
QUIT;
