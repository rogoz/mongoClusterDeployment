#!/bin/bash

ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/
PATH=${PATH}:${RUNDECK_HOME}tools/bin

MMS_USER=$1
MMS_PASS=$2

echo "***** Add cluster to the Mongo Management Service"
run -j 5-monitorCluster -p mongoClusterDeployment --follow -- -MMS_USER ${MMS_USER} -MMS_PASS ${MMS_PASS}



