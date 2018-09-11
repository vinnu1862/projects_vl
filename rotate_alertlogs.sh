#!/bin/bash
#  Script for rotating alert logs
#  Date of last update: 01-Aug-2018
#  Version: 01
###############################################################
export DT=`date +%d%m%Y_%H%M%S`

cwd=`dirname $0`
cd ${cwd}
mkdir logs

(
for dbname in `cat /etc/oratab | grep -v ^# | grep -v ^$ | awk -F':' '{print $1}'`
do
#echo "Changing for ${dbname} database ..."
ALERT_LOG_DIR=/u01/app/oracle/diag/rdbms/${dbname}/${dbname}/trace
ALERT_LOG_FILE=alert_${dbname}.log
# Derivative variables for file names
#
ALERT_LOG_FILE_LAST_LINE=${ALERT_LOG_FILE}_last_line
###############################################################
cd ${ALERT_LOG_DIR}
[ ! -f ${ALERT_LOG_FILE}_01 ] && touch ${ALERT_LOG_FILE}_01
[ ! -f ${ALERT_LOG_FILE}_02 ] && touch ${ALERT_LOG_FILE}_02
[ ! -f ${ALERT_LOG_FILE}_03 ] && touch ${ALERT_LOG_FILE}_03
[ ! -f ${ALERT_LOG_FILE}_04 ] && touch ${ALERT_LOG_FILE}_04
[ ! -f ${ALERT_LOG_FILE}_05 ] && touch ${ALERT_LOG_FILE}_05
[ ! -f ${ALERT_LOG_FILE}_06 ] && touch ${ALERT_LOG_FILE}_06
[ ! -f ${ALERT_LOG_FILE}_07 ] && touch ${ALERT_LOG_FILE}_07
[ ! -f ${ALERT_LOG_FILE}_08 ] && touch ${ALERT_LOG_FILE}_08
[ ! -f ${ALERT_LOG_FILE}_09 ] && touch ${ALERT_LOG_FILE}_09
[ ! -f ${ALERT_LOG_FILE}_10 ] && touch ${ALERT_LOG_FILE}_10

>${ALERT_LOG_FILE}_10

mv ${ALERT_LOG_FILE}_09 ${ALERT_LOG_FILE}_10
mv ${ALERT_LOG_FILE}_08 ${ALERT_LOG_FILE}_09
mv ${ALERT_LOG_FILE}_07 ${ALERT_LOG_FILE}_08
mv ${ALERT_LOG_FILE}_06 ${ALERT_LOG_FILE}_07
mv ${ALERT_LOG_FILE}_05 ${ALERT_LOG_FILE}_06
mv ${ALERT_LOG_FILE}_04 ${ALERT_LOG_FILE}_05
mv ${ALERT_LOG_FILE}_03 ${ALERT_LOG_FILE}_04
mv ${ALERT_LOG_FILE}_02 ${ALERT_LOG_FILE}_03
mv ${ALERT_LOG_FILE}_01 ${ALERT_LOG_FILE}_02

cp ${ALERT_LOG_FILE} ${ALERT_LOG_FILE}_01
>  ${ALERT_LOG_FILE}

touch      ${ALERT_LOG_FILE_LAST_LINE}
echo "0" > ${ALERT_LOG_FILE_LAST_LINE}

done
) 2>&1 | tee /u01/app/oracle/admin/scripts/logs/rotate_alertlogs_${DT}.log
