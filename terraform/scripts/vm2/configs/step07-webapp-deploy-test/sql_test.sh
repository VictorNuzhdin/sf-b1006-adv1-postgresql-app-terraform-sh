#!/bin/bash

SCRIPTS_PATH=/home/ubuntu/scripts
CONFIGS_PATH=/home/ubuntu/scripts/configs/step07-webapp-deploy-test
SQL_SCRIPTS_PATH=$CONFIGS_PATH/sql
LOG_PATH=$SCRIPTS_PATH/step07-webapp-deploy-test_query.log
#
PG_SERVER_ADDR="vm1.dotspace.ru"
PG_SERVER_PORT="5432"
PG_SYSTEM_USER="postgres"
WEBAPP_PG_DB="pydb"
WEBAPP_PG_USER="pyuser"
WEBAPP_PG_USER_PASS="pyuser@pg_pass"
export PGPASSWORD=$WEBAPP_PG_USER_PASS



##..SELECTING DATA
echo "--Selecting data from remote db server [$PG_SERVER_ADDR].." >> $LOG_PATH
echo '' >> $LOG_PATH
psql -t postgres://$PG_SERVER_ADDR:$PG_SERVER_PORT/$WEBAPP_PG_DB?sslmode=disable -U $WEBAPP_PG_USER -f $SQL_SCRIPTS_PATH/select_test_1.sql >> $LOG_PATH
#
#PGPASSWORD=pyuser@pg_pass psql -t postgres://vm1.dotspace.ru:5432/pydb?sslmode=disable -U pyuser -c "SELECT class, name FROM animals;"
echo ''


##=OUTPUT
##
## --Selecting data from remote database..
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
