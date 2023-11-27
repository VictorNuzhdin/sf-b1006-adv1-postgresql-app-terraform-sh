#!/bin/sh

## [vm2.dotspace.ru]
SCRIPTS_PATH=/home/ubuntu/scripts
CONFIGS_PATH=/home/ubuntu/scripts/configs/step06-pgsql-client
LOG_PATH=$SCRIPTS_PATH/step06-pgsql-client.log
#
SQLQUERY_DELAY_SEC=300
PG_SERVER="vm1.dotspace.ru"
PG_SYSTEM_DB=postgres
MY_PG_ADMIN=devops
MY_PG_ADMIN_PASS="'devops@pg_pass'"
PGPASSWORD=$MY_PG_ADMIN_PASS


##--STEP#06 :: Installing PostgreSQL Client
##
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs started.." >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "" >> $LOG_PATH

echo '## Step06.1 - Installing some utils..' >> $LOG_PATH
sudo apt install -y wget ca-certificates net-tools 2>/dev/null
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step06.2 - Adding PostgreSQL repository..' >> $LOG_PATH
sudo bash -c "echo 'deb https://apt-archive.postgresql.org/pub/repos/apt/ bionic-pgdg main' >> /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "--/etc/apt/sources.list.d/pgdg.list"
tail -n1 /etc/apt/sources.list.d/pgdg.list >> $LOG_PATH
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step06.3 - Updating package list..' >> $LOG_PATH
sudo apt update -y 2>/dev/null
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step06.4 - Installing PostgreSQL v8.4 Client (latest for current os release)..' >> $LOG_PATH
sudo apt install -y postgresql-client 2>/dev/null
##..checkout
psql --version >> $LOG_PATH
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step06.5 - Getting PostgreSQL Server version from remote host by sql-query..' >> $LOG_PATH
echo "..waiting $SQLQUERY_DELAY_SEC seconds before execute query.." >> $LOG_PATH
sleep $SQLQUERY_DELAY_SEC
psql -t postgres://$PG_SERVER:5432/$PG_SYSTEM_DB?sslmode=disable -U $MY_PG_ADMIN -c "SELECT version()::varchar(100);" | grep PostgreSQL | awk '{print $1" "$2}' >> $LOG_PATH
#PGPASSWORD=devops@pg_pass psql -t postgres://vm1.dotspace.ru:5432/postgres?sslmode=disable -U devops -c "SELECT version()::varchar(100);" | grep PostgreSQL | awk '{print $1" "$2}'
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo ""
echo "" >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
