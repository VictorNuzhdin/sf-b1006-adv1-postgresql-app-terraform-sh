#!/bin/sh

## [vm1.dotspace.ru]
SCRIPTS_PATH=/home/ubuntu/scripts
CONFIGS_PATH=/home/ubuntu/scripts/configs/step06-pgsql-server
LOG_PATH=$SCRIPTS_PATH/step06-pgsql-server.log
#
PG_SYSTEM_USER=postgres
PG_SYSTEM_DB=postgres
MY_PG_ADMIN=devops
MY_PG_ADMIN_PASS="'devops@pg_pass'"
#
echo $PG_SYSTEM_USER > ./tmpSystemUser
echo $PG_SYSTEM_DB > ./tmpSystemDb
echo $MY_PG_ADMIN > ./tmpMyPgAdmin


##--STEP#06 :: Installing PostgreSQL Server
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


echo '## Step06.4 - Installing PostgreSQL v8.4 Server and components..' >> $LOG_PATH
sudo DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get --option Dpkg::Options::=--force-confold -q -y install postgresql-8.4 postgresql-contrib-8.4
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step06.5 - Starting PostgreSQL service..' >> $LOG_PATH
sudo systemctl start postgresql.service
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step06.6 - Configuring PostgreSQL permissions for system db access..' >> $LOG_PATH
sudo bash -c "echo '#' >> /etc/postgresql/8.4/main/postgresql.conf"
sudo bash -c "echo '# CUSTOM SETTINGS (postgresql.conf)' >> /etc/postgresql/8.4/main/postgresql.conf"
sudo bash -c "echo listen_addresses=\'*\' >> /etc/postgresql/8.4/main/postgresql.conf"
#
sudo bash -c "echo '#' >> /etc/postgresql/8.4/main/pg_hba.conf"
sudo bash -c "echo '# CUSTOM SETTINGS (pg_hba.conf)' >> /etc/postgresql/8.4/main/pg_hba.conf"
sudo bash -c 'echo "host    $(cat ./tmpSystemDb)    $(cat ./tmpMyPgAdmin)      0.0.0.0/0             md5" >> /etc/postgresql/8.4/main/pg_hba.conf'
#sudo bash -c 'echo "host    postgres    devops      0.0.0.0/0             md5" >> /etc/postgresql/8.4/main/pg_hba.conf'
sudo rm -f ./tmpSystemUser
sudo rm -f ./tmpSystemDb
sudo rm -f ./tmpMyPgAdmin
##..checkout :: listen addresses
sudo tail -n 3 /etc/postgresql/8.4/main/postgresql.conf >> $LOG_PATH
echo "" >> $LOG_PATH
##..checkout :: access rules
sudo tail -n 3 /etc/postgresql/8.4/main/pg_hba.conf >> $LOG_PATH
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step06.7 - Creating PostgreSQL user for SELECT queries..' >> $LOG_PATH
#sudo -u postgres psql -c "CREATE USER devops WITH PASSWORD 'devops@pg_pass';"
sudo -u $PG_SYSTEM_USER psql -c "CREATE USER $MY_PG_ADMIN WITH PASSWORD $MY_PG_ADMIN_PASS;" >> $LOG_PATH
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step06.8 - Restarting PostgreSQL service..' >> $LOG_PATH
sudo systemctl restart postgresql.service
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Step06.9 - Checking PostgreSQL Server..' >> $LOG_PATH
##..path and version..
find / -wholename '*/bin/postgres' 2>&- | xargs -i xargs -t '{}' -V >> $LOG_PATH
echo "" >> $LOG_PATH
##..service status..
systemctl status postgresql.service >> $LOG_PATH
echo "" >> $LOG_PATH
##..service instance status..
systemctl status postgresql@8.4-main.service >> $LOG_PATH
echo "" >> $LOG_PATH
##..checking listening tcp port (5432)..
sudo netstat -tulpn | grep LISTEN | grep postgres >> $LOG_PATH
echo "" >> $LOG_PATH
##..getting server version from system table by sql-query
echo "--get version by $PG_SYSTEM_USER" >> $LOG_PATH
sudo -u $PG_SYSTEM_USER psql -c "select version()::varchar(100);" | grep PostgreSQL | awk '{print $1" "$2}' >> $LOG_PATH
#sudo -u postgres psql -c "select version()::varchar(100);" | grep PostgreSQL | awk '{print $1" "$2}' >> $LOG_PATH
echo "" >> $LOG_PATH
echo "--get version by $MY_PG_ADMIN" >> $LOG_PATH
sudo -u $MY_PG_ADMIN psql -d $PG_SYSTEM_DB -c "select version()::varchar(100);" | grep PostgreSQL | awk '{print $1" "$2}'
echo "" >> $LOG_PATH
echo "--get version with sql-query by $MY_PG_ADMIN" >> $LOG_PATH
PGPASSWORD=$MY_PG_ADMIN_PASS psql -t postgres://127.0.0.1:5432/$PG_SYSTEM_DB?sslmode=disable -U $MY_PG_ADMIN -c "SELECT version()::varchar(100);" | grep PostgreSQL | awk '{print $1" "$2}'
#PGPASSWORD=devops@pg_pass psql -t postgres://127.0.0.1:5432/postgres?sslmode=disable -U devops -c "SELECT version()::varchar(100);" | grep PostgreSQL | awk '{print $1" "$2}'
echo "DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


echo ""
echo "" >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
