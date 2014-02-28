#!/bin/bash

ID=$1
KEY=$2
PRODUCT_NAME=$3
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/
PATH=${PATH}:${RUNDECK_HOME}tools/bin

run -j a-downloadProduct -p oakScalabilityHighLevel --follow -- -ID ${ID} -KEY ${KEY} -PRODUCT_NAME ${PRODUCT_NAME}
