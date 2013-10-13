#!/bin/bash

ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/
PATH=${PATH}:${RUNDECK_HOME}tools/bin
echo $PATH
run -j i-getTests -p oakScalability --follow
