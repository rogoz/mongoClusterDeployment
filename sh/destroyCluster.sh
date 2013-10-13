#!/bin/bash 

# Destroy mongo cluster
ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
PROVISIONR_HOME=${ABSOLUTE_PATH}/apache-provisionr/
PROVISIONR_PATH=${PROVISIONR_HOME}bin/
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/

MONGOS_KEY=`xmllint --xpath 'string(/project/node[1]/attribute[2]/@value)' ${RUNDECK_HOME}/mongos.xml`
SHARDS_KEY=`xmllint --xpath 'string(/project/node[1]/attribute[2]/@value)' ${RUNDECK_HOME}/shards.xml` 
echo "MONGOS KEY = "${MONGOS_KEY} 
echo "SHARDS KEY = "${SHARDS_KEY}

${PROVISIONR_PATH}client "provisionr:destroy -k ${MONGOS_KEY}"
sleep 10
rm -rf ${RUNDECK_HOME}shards.xml
${PROVISIONR_PATH}client "provisionr:destroy -k ${SHARDS_KEY}"
sleep 10
rm -rf ${RUNDECK_HOME}mongos.xml




 

