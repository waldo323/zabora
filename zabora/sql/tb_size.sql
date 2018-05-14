SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
SELECT
    TRIM(trunc( (10000 * (x.used) ) / y.mbytes) / 100) "pct_used"
FROM
    (
        SELECT
            b.tablespace_name name,
            ( SUM(b.bytes) / COUNT(DISTINCT a.file_id
            || '.'
            || a.block_id) - SUM(DECODE(a.bytes,NULL,0,a.bytes) ) / COUNT(DISTINCT b.file_id) ) used,
            ( SUM(DECODE(a.bytes,NULL,0,a.bytes) ) / COUNT(DISTINCT b.file_id) ) free
        FROM
            sys.dba_data_files b,
            sys.dba_free_space a
        WHERE
            a.tablespace_name = upper('&1')
            AND   a.tablespace_name = b.tablespace_name
        GROUP BY
            a.tablespace_name,
            b.tablespace_name
    ) x,
    (
        SELECT
            c.tablespace_name name,
            ( SUM(nvl(DECODE(c.maxbytes,0,c.bytes,c.maxbytes),c.bytes) ) ) mbytes
        FROM
            sys.dba_data_files c
        GROUP BY
            c.tablespace_name
    ) y
WHERE
    x.name = y.name;
--AND    x.name<>'UNDOTBS1';
QUIT;
