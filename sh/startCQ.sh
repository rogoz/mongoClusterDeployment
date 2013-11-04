#!/bin/bash

PORT=$1
REPOSITORY=$2
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/
PATH=${PATH}:${RUNDECK_HOME}tools/bin
OAKS_NUMBER=5
run -j b-installProduct -p oakScalabilityHighLevel --follow -- -PORT ${PORT} -REPOSITORY ${REPOSITORY} -REINSTALL ${REINSTALL}
# get install log from all 5 instances
run -j e-getLogs -p oakScalabilityHighLevel --follow -- -OAKS_NUMBER ${OAKS_NUMBER}
