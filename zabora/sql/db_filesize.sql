SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
SELECT
    TO_CHAR(SUM(bytes),'FM99999999999999990') retvalue
FROM
    dba_data_files;
QUIT;
