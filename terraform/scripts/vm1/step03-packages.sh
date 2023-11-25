#!/bin/sh

## [vm1.dotspace.local]
SCRIPTS_PATH=/home/ubuntu/scripts
LOG_PATH=$SCRIPTS_PATH/step03-packages.log




##--STEP#02 :: Installing packages :: Python
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs started.." >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "" >> $LOG_PATH

echo '## Updating local apt packages database..' >> $LOG_PATH
sudo apt update -y
#sudo apt upgrade -y                             ## Needed interactive actions and rebooting
echo "" >> $LOG_PATH

#echo '## Installing Python 3' >> $LOG_PATH
#sudo apt install -y python3                     ## в образе от 2023.08.28 уже есть Python 3.10.12, обновление системы не меняет версию Python
#sudo apt -y autoremove >> $LOG_PATH             ## After this operation, 596 MB disk space will be freed.
#python3 --version
#whereis python3
#echo "" >> $LOG_PATH

echo '## Installing Whois package (includes mkpasswd)..' >> $LOG_PATH
sudo apt update -y
sudo apt install -y whois
echo "" >> $LOG_PATH
whois --version | head -n 1 >> $LOG_PATH
whereis whois >> $LOG_PATH
echo "" >> $LOG_PATH
mkpasswd --version | head -n 1 >> $LOG_PATH
whereis mkpasswd >> $LOG_PATH
echo "" >> $LOG_PATH

echo '## Installing Midnight Commander..' >> $LOG_PATH
sudo apt install -y mc
echo "" >> $LOG_PATH
mc --version | head -n 1 >> $LOG_PATH
whereis mc >> $LOG_PATH
echo "" >> $LOG_PATH

echo '## Installing Tree package..' >> $LOG_PATH
sudo apt install -y tree
echo "" >> $LOG_PATH
tree --version >> $LOG_PATH
whereis tree >> $LOG_PATH
echo "" >> $LOG_PATH

echo "" >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
