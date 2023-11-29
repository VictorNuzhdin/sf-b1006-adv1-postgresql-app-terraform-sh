#!/bin/sh

## [vm1.dotspace.ru]
SCRIPTS_PATH=/home/ubuntu/scripts
CONFIGS_PATH=/home/ubuntu/scripts/configs/step07-webapp-deploy-env
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


echo '## Step07.1 - Configuring PostgreSQL permissions..' >> $LOG_PATH
sudo bash -c 'echo "host    $(cat ./tmpAppDb)        $(cat ./tmpAppUser)      0.0.0.0/0             md5" >> /etc/postgresql/8.4/main/pg_hba.conf'
#sudo bash -c 'echo "host    pydb        pyuser      0.0.0.0/0             md5" >> /etc/postgresql/8.4/main/pg_hba.conf'
sudo rm -f ./tmpAppDb
sudo rm -f ./tmpAppUser
##..checkout
sudo tail -n 3 /etc/postgresql/8.4/main/pg_hba.conf >> $LOG_PATH
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.2 - Restarting PostgreSQL service..' >> $LOG_PATH
sudo systemctl restart postgresql.service
##..checkout
systemctl status postgresql@8.4-main.service | grep Active | awk '{$1=$1;print}' >> $LOG_PATH
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step07.3 - Executing test script (creates database, insert data and select)..' >> $LOG_PATH
chmod +x $CONFIGS_PATH/sql_test.sh
sudo bash $CONFIGS_PATH/sql_test.sh
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo ""
echo "" >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
