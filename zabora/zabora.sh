#!/usr/bin/env ksh
rcode=0
PATH=/usr/local/bin:${PATH}

#################################################################################

#################################################################################
#
#  Variable Definition
# ---------------------
#
APP_NAME=$(basename $0)
APP_DIR=$(dirname $0)
APP_VER="1.5.3.1"
APP_WEB="https://github.com/huna79/zabora"
#
#################################################################################

#################################################################################
#
#  Load Oracle Environment
# -------------------------
#
[ -x ${APP_DIR}/${APP_NAME%.*}.conf ] || . ${APP_DIR}/${APP_NAME%.*}.conf
#
#################################################################################

#################################################################################
#
#  Function Definition
# ---------------------
#
usage() {
    echo "Usage: ${APP_NAME%.*} [Options]"
    echo ""
    echo "Options:"
    echo "  -h            Displays this help message."
    echo "  -a            Query arguments."
    echo "  -s ARG(str)   Query to Oracle."
    echo "  -o ARG(str)   Set SID to make the query."
    echo "  -j            Jsonify output."
    echo "  -v            Show the script version."
    echo "  -d ARG(str)   Discover databases (db) or tablespaces (tbs)."
    echo ""
    exit 1
}

version() {
    echo "${APP_NAME%.*} ${APP_VER}"
    exit 1
}

load_oracle() {
    if [[ -f ${APP_DIR}/zabora.oraenv ]]; then
       . ${APP_DIR}/zabora.oraenv
    else
       ORAENV_ASK=NO
       . /usr/local/bin/oraenv > /dev/null
    fi
}

databases() {
    ps -eo command | grep -v sed | sed -n 's/ora_pmon_\(.*\)/\1/p'
}
#
#################################################################################

#################################################################################
while getopts "s::a:o:hvj:d:" OPTION; do
    case ${OPTION} in
	h)
	    usage
	    ;;
	s)
	    SQL="${APP_DIR}/sql/${OPTARG}"
	    ;;
	o)
	    ORACLE_SID=${OPTARG}
	    ;;
  j)
      JSON=1
	    JSON_ATTR=${OPTARG}
      ;;
  a)
	    SQL_ARGS=${OPTARG}
	    ;;
	v)
	    version
	    ;;
	d)
	    DISCOVER=1
	    DISCOVER_ATTR=${OPTARG}
	    ;;
	\?)
	    exit 1
	    ;;
    esac
done

if [[ -f "${SQL%.sql}.sql" ]]; then
    load_oracle
    rval=$(sqlplus -S -L ${ORACLE_USER}/${ORACLE_PASS} @${SQL} "${SQL_ARGS}") || { echo "ZBX_NOTSUPPORTED"; exit 1; }
    rcode="${?}"
    if [[ ${JSON} -eq 1 ]]; then
       set -A rval ${rval}
       echo '{'
       echo '   "data":['
       count=1
       for i in ${rval[@]};do
          output='{ "'{#${JSON_ATTR}}'":"'${i}'" }'
          if (( ${count} < ${#rval[*]} )); then
             output="${output},"
          fi
          echo "      ${output}"
          let "count=count+1"
       done
       echo '   ]'
       echo '}'
    else
       echo ${rval:-0}
    fi
elif [[ ${DISCOVER} -eq 1 ]] && [[ ${DISCOVER_ATTR} == db ]]; then
    rval=$(databases)
    rcode="${?}"
    if [[ ${JSON} -eq 1 ]]; then
       set -A rval ${rval}
       echo '{'
       echo '   "data":['
       count=1
       for i in ${rval[@]};do
          output='{ "'{#${JSON_ATTR}}'":"'${i}'" }'
          if (( ${count} < ${#rval[*]} )); then
             output="${output},"
          fi
          echo "      ${output}"
          let "count=count+1"
       done
       echo '   ]'
       echo '}'
    else
       echo ${rval:-0}
    fi
elif [[ ${DISCOVER} -eq 1 ]] && [[ ${DISCOVER_ATTR} == tbs ]]; then
    osids=$(databases)
    rcode="${?}"
    osidsc=$(echo ${osids} | wc -w)
    j=1
    for ORACLE_SID in ${osids}; do
       load_oracle
       rval=$(sqlplus -S -L ${ORACLE_USER}/${ORACLE_PASS} @${APP_DIR}/sql/tb_list.sql) || { echo "ZBX_NOTSUPPORTED"; exit 1; }
       rcode="${?}"
       if [[ ${JSON} -eq 1 ]]; then
          set -A rval ${rval}
          if [[ ${j} -eq 1 ]]; then
             echo '{'
             echo '   "data":['
          fi
          count=1
          for i in ${rval[@]};do
             echo "      { \""{#ORACLE_SID}"\":\""${ORACLE_SID}"\", "
             output='  "'{#${JSON_ATTR}}'":"'${i}'" }'
             if [[ ${count} -eq ${#rval[*]} ]] && [[ ${j} -eq ${osidsc} ]]; then
                echo "      ${output}"
                echo '   ]'
                echo '}'
             else
                echo "      ${output},"
             fi
             let "count=count+1"
          done
       else
          echo ${rval:-0}
       fi
       let "j=j+1"
    done
else
    echo "ZBX_NOTSUPPORTED"
    rcode="1"
fi

exit ${rcode}
