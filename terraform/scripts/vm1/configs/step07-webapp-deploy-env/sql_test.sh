#!/bin/bash

SCRIPTS_PATH=/home/ubuntu/scripts
CONFIGS_PATH=/home/ubuntu/scripts/configs/step07-webapp-deploy-env
SQL_SCRIPTS_PATH=$CONFIGS_PATH/sql
LOG_PATH=$SCRIPTS_PATH/step07-webapp-deploy-env_query.log
#
PG_SERVER_ADDR="127.0.0.1"
PG_SERVER_PORT="5432"
PG_SYSTEM_USER="postgres"
WEBAPP_PG_DB="pydb"
WEBAPP_PG_USER="pyuser"
WEBAPP_PG_USER_PASS="pyuser@pg_pass"
export PGPASSWORD=$WEBAPP_PG_USER_PASS



##..CREATING DATA
#sudo -u postgres psql -c "CREATE USER pyuser WITH PASSWORD 'pyuser@pg_pass';"
#sudo -u postgres psql -c "CREATE DATABASE pydb;"
#sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE pydb to pyuser;"
#
#PGPASSWORD=pyuser@pg_pass psql -t postgres://127.0.0.1:5432/pydb?sslmode=disable -U pyuser -c "CREATE TABLE animals (name VARCHAR (10) UNIQUE NOT NULL, class VARCHAR (20) NOT NULL, gender VARCHAR(1) NOT NULL);"
#PGPASSWORD=pyuser@pg_pass psql -t postgres://127.0.0.1:5432/pydb?sslmode=disable -U pyuser -c "INSERT INTO animals (name, class, gender) values ('spike', 'dog', 'm'), ('skooby', 'dog', 'm'), ('sandra', 'dog', 'f'), ('luna', 'cat', 'f'), ('sugar', 'cat', 'f'), ('tom', 'cat', 'm'), ('watson', 'cat', 'm'), ('jake', 'parrot', 'm'), ('mary', 'parrot', 'f');"
#
sudo -u $PG_SYSTEM_USER psql -f $SQL_SCRIPTS_PATH/deploy_s1_meta.sql >> $LOG_PATH
psql -t postgres://$PG_SERVER_ADDR:$PG_SERVER_PORT/$WEBAPP_PG_DB?sslmode=disable -U $WEBAPP_PG_USER -f $SQL_SCRIPTS_PATH/deploy_s2_data.sql >> $LOG_PATH
#
#PGPASSWORD=pyuser@pg_pass psql -t postgres://127.0.0.1:5432/pydb?sslmode=disable -U pyuser -f ./deploy_s2_data.sql
echo '' >> $LOG_PATH


##..SELECTING DATA
echo "--Selecting data from database.." >> $LOG_PATH
echo '' >> $LOG_PATH
psql -t postgres://$PG_SERVER_ADDR:$PG_SERVER_PORT/$WEBAPP_PG_DB?sslmode=disable -U $WEBAPP_PG_USER -f $SQL_SCRIPTS_PATH/select_test_1.sql >> $LOG_PATH
#
#PGPASSWORD=pyuser@pg_pass psql -t postgres://127.0.0.1:5432/pydb?sslmode=disable -U pyuser -c "SELECT class, name FROM animals;"
echo '' >> $LOG_PATH


##..DESTROYING DATA -- PERMANENTLY_DISABLED (reason: executing this block unable to select data on client host, due Data is missing in database)
#sudo -u postgres psql -d pydb -c "DROP TABLE animals;"
#sudo -u postgres psql -c "DROP DATABASE pydb;"
#sudo -u postgres psql -c "DROP USER pyuser;"
#
#sudo -u postgres psql -d pydb -f $SQL_SCRIPTS_PATH/destroy_s1_data.sql >> $LOG_PATH
#sudo -u postgres psql -f $SQL_SCRIPTS_PATH/destroy_s2_meta.sql >> $LOG_PATH
#
#sudo -u postgres psql -d pydb -f ./destroy_data.sql
#sudo -u postgres psql -f ./destroy_meta.sql
echo ''


##=OUTPUT
##
## CREATE ROLE
## CREATE DATABASE
## GRANT
## psql:./deploy_data.sql:8: NOTICE:  CREATE TABLE / UNIQUE will create implicit index "animals_name_key" for table "animals"
## CREATE TABLE
## INSERT 0 9
##
## --Selecting data from database..
##
##  dog    | spike
##  dog    | skooby
##  dog    | sandra
##  cat    | luna
##  cat    | sugar
##  cat    | tom
##  cat    | watson
##  parrot | jake
##  parrot | mary
##
## DROP TABLE
## DROP DATABASE
## DROP ROLE
##
