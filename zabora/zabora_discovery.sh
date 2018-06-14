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
APP_VER="1.5.3"
APP_WEB="https://github.com/huna79/zabora"
#
#################################################################################

#################################################################################
#
#  Load Oracle Environment
# -------------------------
#
[ -x ${APP_DIR}/zabora.conf ] || . ${APP_DIR}/zabora.conf
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
    echo "  -j            Jsonify output."
    echo "  -v            Show the script version."
    echo ""
    exit 1
}

version() {
    echo "${APP_NAME%.*} ${APP_VER}"
    exit 1
}

databases() {
    echo $(ps -eo command | grep -v sed | sed -n 's/ora_pmon_\(.*\)/\1/p')
}
#
#################################################################################

#################################################################################
while getopts "hvj:dt" OPTION; do
    case ${OPTION} in
	h)
	    usage
	    ;;
        j)
            JSON=1
	    JSON_ATTR=${OPTARG}
            ;;
	v)
	    version
	    ;;
	d)
	    DISCOVERY_DATABASES=1
	    ;;
	t)
	    DISCOVERY_TABLESPACES=1
	    ;;
         \?)
            exit 1
            ;;
    esac
done

if [[ ${DISCOVERY_DATABASES} -eq 1 ]]; then
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
elif [[ ${DISCOVERY_TABLESPACES} -eq 1 ]]; then
    osids=$(databases)
    rcode="${?}"
    osidsc=$(echo ${osids} | wc -w)
    j=1
    for ORACLE_SID in ${osids}; do
       if [[ -f ${APP_DIR}/zabora.oraenv ]]; then
          . ${APP_DIR}/zabora.oraenv
       else
          ORAENV_ASK=NO
          . /usr/local/bin/oraenv > /dev/null
       fi
    rval=$(sqlplus -s ${ORACLE_USER}/${ORACLE_PASS} @${APP_DIR}/sql/tb_list.sql)
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
