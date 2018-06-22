SET	 pagesize 0
SET	 heading OFF
SET	 feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TRIM(tablespace_name)
FROM
    dba_tablespaces;
QUIT;
