#!/bin/bash

#timeout between tests
TIMEOUT=40
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/
PATH=${PATH}:${RUNDECK_HOME}tools/bin
DROP_DB=false
INIT_TEST=CreateNodesBenchmark
tests=( "$@" )
OAKS_NUMBER=${ENV_OAKS_NUMBER}

echo "The following tests will be executed ${tests[@]}"

for test in "${tests[@]}"
do
 # init database
 DATABASE_SUFIX=$RANDOM
 echo "Running ${test} on database Oak-database-$DATABASE_SUFIX"
 run -j init.repository -p oakScalability --follow -- -TEST_NAME ${INIT_TEST} -DATABASE_NAME Oak-database-$DATABASE_SUFIX
 run -j ii-runTest -p oakScalability --follow -- -TEST_NAME ${test} -DROP_DB ${DROP_DB} -OAKS_NUMBER $OAKS_NUMBER -DATABASE_NAME Oak-database-$DATABASE_SUFIX -RUNTIME ${RUNTIME} -ENABLE_PROFILE ${ENABLE_PROFILE}
 run -j iii-collectResults -p oakScalability --follow -- -TEST_NAME ${test} -OAKS_NUMBER $OAKS_NUMBER
 sleep $TIMEOUT
done 

