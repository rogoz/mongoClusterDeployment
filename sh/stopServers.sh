#!/bin/bash

ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
PROVISIONR_HOME=${ABSOLUTE_PATH}/provisionr-0.4.0-incubating/
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/

# stop provisionr

cd ${PROVISIONR_HOME}
./bin/stop 

sleep 2
# stop rundeck

kill -9 `ps -ef|grep rundeck|grep -v grep|awk '{print $2}'`

