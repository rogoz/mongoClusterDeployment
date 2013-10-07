#!/bin/bash

ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
PROVISIONR_HOME=${ABSOLUTE_PATH}/org.apache.provisionr-0.4.0-incubating-SNAPSHOT/
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/

# start provisionr

cd ${PROVISIONR_HOME}/bin
ls
./start

sleep 60

# start rundeck

cd ${RUNDECK_HOME}
java -jar rundeck*.jar &
sleep 120
clear



