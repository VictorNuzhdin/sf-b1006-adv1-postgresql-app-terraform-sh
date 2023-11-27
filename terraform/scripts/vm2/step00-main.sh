#!/bin/sh

## [vm2.dotspace.ru]
SCRIPTS_PATH=/home/ubuntu/scripts
LOG_PATH=$SCRIPTS_PATH/step00-main.log




##--STEP#00 :: Execution of individual scripts
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Scripts execution started.." >> $LOG_PATH
#
chmod +x $SCRIPTS_PATH/step01-system-setup.sh
sudo bash $SCRIPTS_PATH/step01-system-setup.sh
#
chmod +x $SCRIPTS_PATH/step02-users.sh
sudo bash $SCRIPTS_PATH/step02-users.sh
#
chmod +x $SCRIPTS_PATH/step03-packages.sh
sudo bash $SCRIPTS_PATH/step03-packages.sh
#
chmod +x $SCRIPTS_PATH/step04-nginx.sh
sudo bash $SCRIPTS_PATH/step04-nginx.sh
#
#..configuring FreeDNS Client
chmod +x $SCRIPTS_PATH/step05-freedns.sh
sudo bash $SCRIPTS_PATH/step05-freedns.sh
#
#..configuring PostgreSQL Client
chmod +x $SCRIPTS_PATH/step06-pgsql-client.sh
sudo bash $SCRIPTS_PATH/step06-pgsql-client.sh
#
#..configuring Firewall (ufw)
chmod +x $SCRIPTS_PATH/step66-firewall.sh
sudo bash $SCRIPTS_PATH/step66-firewall.sh
#
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Scripts execution done!" >> $LOG_PATH
