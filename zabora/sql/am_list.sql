SET	 pagesize 0
SET	 heading OFF
SET	 feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TRIM(name)
FROM
    v$asm_diskgroup_stat;
QUIT;
