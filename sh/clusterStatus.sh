#!/bin/bash

ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
PROVISIONR_HOME=${ABSOLUTE_PATH}/org.apache.provisionr-0.4.0-incubating-SNAPSHOT/
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/

echo
if [ -f ${RUNDECK_HOME}/shards.xml ];
then
   echo "**** Shards ****";
   cat ${RUNDECK_HOME}/shards.xml; 
else
   echo "Shards not found.No cluster is created";
   exit 1;
fi
echo 
if [ -f ${RUNDECK_HOME}/mongos.xml ];
then
   echo "**** Mongos ****";
   cat ${RUNDECK_HOME}/mongos.xml; 
else
   echo "Mongos not found.No cluster is created";
   exit 1;
fi
