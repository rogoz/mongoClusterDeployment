#!/bin/bash

PORT=$1
REPOSITORY=$2
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/
PATH=${PATH}:${RUNDECK_HOME}tools/bin

run -j b-installProduct -p oakScalabilityHighLevel --follow -- -PORT ${PORT} -REPOSITORY ${REPOSITORY} -REINSTALL ${REINSTALL}
