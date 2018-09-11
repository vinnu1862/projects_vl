#!/bin/bash
#  Script for deleting old files 
#  Date of last update: 01-Aug-2018
#  Version: 01
###############################################################
export DT=`date +%d%m%Y_%H%M%S`
cwd=`dirname $0`
cd ${cwd}
mkdir logs

(
find /u01/app/oracle/admin/scripts/logs -type f -mtime +90 -print -exec rm {} ';'
for dbname in `cat /etc/oratab | grep -v ^# | grep -v ^$ | awk -F':' '{print $1}'`
do
ORACLE_HOME=`grep ${dbname} /etc/oratab | awk -F':' '{print $2}'`

echo " Deleting old files for datebase ${dbname} ..."
find ${ORACLE_HOME}/rdbms/log      -type f -mtime +30  -print -exec rm {} ';'
find /u01/app/oracle/admin/${dbname}/adump     -type f -mtime +30  -print -exec rm {} ';'
find /u01/app/oracle/diag/rdbms/${dbname}/${dbname}/trace   -type f -mtime +90  -print -exec rm {} ';'
find /u01/app/oracle/diag/rdbms/${dbname}/${dbname}/alert   -type f -mtime +90  -print -exec rm {} ';'

done
) 2>&1 | tee /u01/app/oracle/admin/scripts/logs/delete_old_files_${DT}.log
