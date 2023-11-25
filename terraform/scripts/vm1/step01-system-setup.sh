#!/bin/sh

SCRIPTS_PATH=/home/ubuntu/scripts
LOG_PATH=$SCRIPTS_PATH/step01-system-setup.log
TZ_LOCAL=Asia/Omsk




##--STEP#00 :: Various OS settings
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs started.." >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "" >> $LOG_PATH

echo '## Step00.1 - Set Timezone..' >> $LOG_PATH
##..checkout:before
echo "datetime_before: $(date +'%Y-%m-%d %H:%M:%S')" >> $LOG_PATH
##..setup
sudo timedatectl set-timezone $TZ_LOCAL
##..checkout:after
echo "datetime_after.: $(date +'%Y-%m-%d %H:%M:%S')" >> $LOG_PATH
echo "" >> $LOG_PATH
echo "timedatectl....:" >> $LOG_PATH
timedatectl >> $LOG_PATH
echo "" >> $LOG_PATH


echo "" >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
