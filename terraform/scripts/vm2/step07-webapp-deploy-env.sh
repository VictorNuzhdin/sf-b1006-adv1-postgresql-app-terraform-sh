#!/bin/sh

## [vm2.dotspace.ru]
SCRIPTS_PATH=/home/ubuntu/scripts
CONFIGS_PATH=/home/ubuntu/scripts/configs/step07-webapp-deploy-test
#CONFIGS_PATH=/home/ubuntu/scripts/configs/step07-webapp-deploy-env
LOG_PATH=$SCRIPTS_PATH/step07-webapp-deploy-env.log
#
PG_SYSTEM_USER="postgres"
WEBAPP_PG_DB="pydb"
WEBAPP_PG_USER="pyuser"
WEBAPP_PG_USER_PASS="pyuser@pg_pass"
#
echo $WEBAPP_PG_DB > ./tmpAppDb
echo $WEBAPP_PG_USER > ./tmpAppUser



##--STEP#07 :: Deploying webapp Environment..
##
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs started.." >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.1 - Executing test script (creates database, insert and select data)..' >> $LOG_PATH
chmod +x $CONFIGS_PATH/sql_test.sh
sudo bash $CONFIGS_PATH/sql_test.sh
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo ""
echo "" >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
