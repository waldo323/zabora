SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    TO_CHAR(COUNT(*),'FM99999999999999990') retvalue
FROM
    all_indexes
WHERE
    status != 'VALID'
    AND (
        status != 'N/A'
        OR index_name IN (
            SELECT
                index_name
            FROM
                all_ind_partitions
            WHERE
                status != 'USABLE'
                AND (
                    status != 'N/A'
                    OR index_name IN (
                        SELECT
                            index_name
                        FROM
                            all_ind_subpartitions
                        WHERE
                            status != 'USABLE'
                    )
                )
        )
    );
QUIT;
