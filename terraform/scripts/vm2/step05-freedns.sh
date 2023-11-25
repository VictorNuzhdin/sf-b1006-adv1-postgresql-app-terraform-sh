#!/bin/sh

## [vm2.dotspace.ru]
SCRIPTS_PATH=/home/ubuntu/scripts
LOG_PATH=$SCRIPTS_PATH/step05-freedns.log
FREEDNS_CLIENT_SCRIPT=freeDNSupdateIP.sh
FREEDNS_API_TOKEN='yLpeGsgPf5tEDSebTvwT2rcb'


##--STEP#77 :: Configuring FreeDNS Client
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs started.." >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "" >> $LOG_PATH

echo '## Step01 - Building API Client script..' >> $LOG_PATH
touch $SCRIPTS_PATH/$FREEDNS_CLIENT_SCRIPT
chmod +x $SCRIPTS_PATH/$FREEDNS_CLIENT_SCRIPT
echo '' >> $LOG_PATH

echo $FREEDNS_API_TOKEN > $SCRIPTS_PATH/secret

##-->start_script_body
cat <<'EOF'>> $SCRIPTS_PATH/$FREEDNS_CLIENT_SCRIPT
#!/bin/bash

##=UPDATE CURRENT SERVER PUBLIC IP ADDRESS RECORD ON FreeDNS SERVICE (freedns.afraid.org)
## *examples:
##  curl -sk  "http://sync.afraid.org/u/<API_TOKEN>/?ip=<CURRENT_SERVER_PUBLIC_IPV4_ADRESS>"
##  curl -sk "https://sync.afraid.org/u/<API_TOKEN>/?ip=<CURRENT_SERVER_PUBLIC_IPV4_ADRESS>"
#
LOG_PATH=/home/ubuntu/scripts/freeDNSupdateIP.log
TS=$(echo `date +"%Y-%m-%d %H:%M:%S"`)

#..old: getting current VM public IP address using an external service
#CURRENT_SERVER_PUBLIC_IPV4_ADRESS=$(curl -sk https://2ip.ru)
#
#..new: getting current VM public IP address using an internal Yandex.Cloud service
CURRENT_SERVER_PUBLIC_IPV4_ADRESS=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

##..PROBLEM:
#   - external variable $FREEDNS_API_TOKEN doesnt exposing inside script as plain-text, but only due runtime
#   - needed another solution for injecting variable
#
#API_TOKEN=$FREEDNS_API_TOKEN
API_TOKEN=$(cat /home/ubuntu/scripts/secret)


##..do API request for update "vm2.dotspace.ru" DNS-record
API_CALL_RESULT=$(curl -sk "https://sync.afraid.org/u/$API_TOKEN/?ip=$CURRENT_SERVER_PUBLIC_IPV4_ADRESS")

##..log result
echo $TS -- $API_CALL_RESULT >> $LOG_PATH 2>/dev/null
EOF
##<--end_script_body
#
##..checkout
cat $SCRIPTS_PATH/$FREEDNS_CLIENT_SCRIPT >> $LOG_PATH
echo '' >> $LOG_PATH


echo '## Step02 - Adding script to crontab for onBoot execution..' >> $LOG_PATH
sudo crontab -l > crontab_root.backup
echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin" >> cron_tmp
echo "@reboot sleep 60 ; $SCRIPTS_PATH/$FREEDNS_CLIENT_SCRIPT" >> cron_tmp
sudo crontab cron_tmp
rm cron_tmp
sudo service cron reload
sudo systemctl status cron | grep Active | awk '{$1=$1;print}' >> $LOG_PATH
sudo crontab -l | tail -n 2 >> $LOG_PATH
echo '' >> $LOG_PATH

echo '## Step03 - Execute script immediately..' >> $LOG_PATH
$SCRIPTS_PATH/freeDNSupdateIP.sh

echo '## Step04 - Show script log..' >> $LOG_PATH
cat $SCRIPTS_PATH/freeDNSupdateIP.log | tail -n 2


echo "" >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
