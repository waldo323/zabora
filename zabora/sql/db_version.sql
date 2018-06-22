SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    banner
FROM
    v$version
WHERE
    ROWNUM = 1;
QUIT;
