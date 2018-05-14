SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET	 verify OFF
SELECT
    TRIM(DECODE(SUM(estado),0,0,NULL,-1,1) )
FROM
    (
        SELECT
            to_number(DECODE(status,'COMPLETED',0,'RUNNING',0,'COMPLETED WITH WARNINGS',1,'COMPLETED WITH ERRORS',2,3) ) "ESTADO",
            TO_CHAR(operation)
            || '('
            || TO_CHAR(nvl(object_type,'-') )
            || ') - '
            || TO_CHAR(status)
            || ' - DURACION: '
            || TO_CHAR(round( (end_time - start_time) * 24 * 60,2) )
            || ' MIN' "DETALLE"
        FROM
            v$rman_status
        WHERE
            start_time > SYSDATE - 1
            AND   command_id = (
                SELECT
                    MAX(command_id)
                FROM
                    v$rman_status
            )
        ORDER BY
            estado DESC,
            start_time
    );
QUIT;
