SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET      verify OFF
SELECT
    n.wait_class || ':' ||
    TO_CHAR(m.time_waited/m.INTSIZE_CSEC,'FM99999999999999990.0000') retvalue
FROM
    v$waitclassmetric m, v$system_wait_class n
WHERE
    m.wait_class_id=n.wait_class_id AND n.wait_class != 'Idle';
QUIT;
