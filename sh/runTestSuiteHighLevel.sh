#!/bin/bash

TIMEOUT=40
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/
PATH=${PATH}:${RUNDECK_HOME}tools/bin

tests=( "$@" )
OAKS_NUMBER=${ENV_OAKS_NUMBER}
echo "The following tests will be executed ${tests[@]}"

for test in "${tests[@]}"
do
 echo "Running ${test}"
 run -j d-runTests -p oakScalabilityHighLevel --follow -- -TEST_NAME ${test} -RUNTIME ${RUNTIME} -OAKS_NUMBER $OAKS_NUMBER
 sleep $TIMEOUT
done 
