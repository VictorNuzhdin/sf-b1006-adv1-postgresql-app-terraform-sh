#!/bin/sh

SCRIPTS_PATH=/home/ubuntu/scripts
LOG_PATH=$SCRIPTS_PATH/step02-users.log
NEW_USER_LOGIN=devops
NEW_USER_PSSWD='$6$JCziDafoOKooaSuV$rtfGzVfYbJukSPi7qs.RvNcLeOH62GxwhURWK7Xm5p.GiVersxf7eB6fzdIM0BEgmRfS82lpkN.vpwvSGYWhU.'
##              crypt(3) SHA-512 format generated by "mkpasswd" from secret keyphrase (clo**)


##--STEP#01 :: Create new user "devops" with sudo permissions and ssh-key authentication
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs started.." >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "" >> $LOG_PATH

sudo useradd -p $NEW_USER_PSSWD --create-home --shell /bin/bash -G adm,sudo $NEW_USER_LOGIN

sudo chmod ug+w /etc/sudoers
sudo bash -c "echo '' >> /etc/sudoers"
sudo bash -c "echo '## CUSTOM_RECORDS' >> /etc/sudoers"
sudo bash -c "echo '$NEW_USER_LOGIN    ALL=(ALL:ALL)    NOPASSWD: ALL' >> /etc/sudoers"
sudo chmod ug=r /etc/sudoers

sudo mkdir /home/$NEW_USER_LOGIN/.ssh
sudo cp /tmp/.ssh/id_ed25519 /home/$NEW_USER_LOGIN/.ssh/
sudo cp /tmp/.ssh/id_ed25519.pub /home/$NEW_USER_LOGIN/.ssh/
sudo bash -c "cat /tmp/.ssh/id_ed25519.pub >> /home/$NEW_USER_LOGIN/.ssh/authorized_keys"
rm -rf /tmp/.ssh

sudo chmod 700 /home/$NEW_USER_LOGIN/.ssh
sudo chmod 600 /home/$NEW_USER_LOGIN/.ssh/id_ed25519
sudo chmod 600 /home/$NEW_USER_LOGIN/.ssh/id_ed25519.pub
sudo chmod 600 /home/$NEW_USER_LOGIN/.ssh/authorized_keys
sudo chown -R devops:devops /home/$NEW_USER_LOGIN/.ssh/

##..Disabling "Message Of The Day" (motd)
##  https://askubuntu.com/questions/804095/how-do-i-disable-the-message-of-the-day-motd-on-ubuntu-14-04
##  https://raymii.org/s/tutorials/Disable_dynamic_motd_and_motd_news_spam_on_Ubuntu_18.04.html
#
sudo bash -c "touch /home/$NEW_USER_LOGIN/.hushlogin"
sudo chown -R devops:devops /home/$NEW_USER_LOGIN/.hushlogin

echo "" >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
