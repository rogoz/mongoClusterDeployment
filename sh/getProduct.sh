#!/bin/bash

ID=$1
KEY=$2
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/
PATH=${PATH}:${RUNDECK_HOME}tools/bin

run -j i-getTests -p oakScalabilityHighLevel --follow -- -ID ${ID} -KEY ${KEY}
