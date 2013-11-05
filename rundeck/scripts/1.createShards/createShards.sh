#!/bin/bash  
 
# Create mongo database shards and downloads the shards connection parameters on the local server.This script should run on the rundeck local server.
# SHARDS_NUMBER, HDD_SIZE and PROVISIONR_PATH are defined as rundeck options.  


PROVISIONR_HOST=localhost 
PROVISIONR_PORT=8181 
RAND=$(( $RANDOM % 100000 ))
SHARDS_KEY=t${RAND} 
SHARDS_NUMBER=$1
HDD_SIZE=$2
PROVISIONR_PATH=$3
TIME_OUT=450

${PROVISIONR_PATH}client "provisionr:create --id amazon --key ${SHARDS_KEY} --size ${SHARDS_NUMBER} --volume /dev/sdh1:${HDD_SIZE} --volume /dev/sdh2:${HDD_SIZE} --volume /dev/sdh3:${HDD_SIZE} --volume /dev/sdh4:${HDD_SIZE} --hardware-type m1.xlarge --template mongod --image-id ami-4965f479 --timeout 450" 
 
# wait 7 minutes for the instances to be created 
sleep $TIME_OUT 
 
# get the shards machine.xml file 
 
rm -rf shards.xml 
wget http://${PROVISIONR_HOST}:${PROVISIONR_PORT}/rundeck/machines.xml -O shards.xml
