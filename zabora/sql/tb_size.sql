SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
SELECT
    SUM(sum_bytes) bytes
FROM
    (
        SELECT
            1,
            d.tablespace_name,
            nvl(SUM(bytes),0) AS sum_bytes
        FROM
            dba_data_files d,
            dba_tablespaces t
        WHERE
            d.tablespace_name = t.tablespace_name
        GROUP BY
            1,
            d.tablespace_name
        UNION ALL
        SELECT
            2,
            d.tablespace_name,
            nvl(SUM(bytes),0) AS sum_bytes
        FROM
            dba_temp_files d,
            dba_tablespaces t
        WHERE
            d.tablespace_name = t.tablespace_name
        GROUP BY
            2,
            d.tablespace_name
    )
WHERE
    tablespace_name = '&1'
GROUP BY
    tablespace_name;
QUIT;
