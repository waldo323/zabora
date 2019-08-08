SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET      verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TO_CHAR(SUM(nvl(a.bytes - nvl(f.bytes,0),0) ),'FM99999999999999990') retvalue
FROM
    sys.dba_tablespaces d,
    (
        SELECT
            tablespace_name,
            SUM(bytes) bytes
        FROM
            dba_data_files
        GROUP BY
            tablespace_name
    ) a,
    (
        SELECT
            tablespace_name,
            SUM(bytes) bytes
        FROM
            dba_free_space
        GROUP BY
            tablespace_name
    ) f
WHERE
    d.tablespace_name = a.tablespace_name (+)
    AND   d.tablespace_name = f.tablespace_name (+)
    AND   NOT (
        d.extent_management LIKE 'LOCAL'
        AND   d.contents LIKE 'TEMPORARY'
    );
QUIT;
