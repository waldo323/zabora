SET      pagesize 0
SET      heading OFF
SET      feedback OFF
SET      verify OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
SELECT
    'wait_class_' || wait_class# || ':' ||
    TO_CHAR(time_waited/INTSIZE_CSEC,'FM99999999999999990.0000') retvalue
FROM
    v$waitclassmetric;
QUIT;
