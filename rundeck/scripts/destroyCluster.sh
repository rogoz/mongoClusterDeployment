#!/bin/bash 

# Destroy mongo cluster

RUNDECK_HOME=/home/tudor/Tools/rundeck/
PROVISIONR_PATH=/home/tudor/repos/incubator-provisionr/karaf/assembly/target/org.apache.provisionr-0.4.0-incubating-SNAPSHOT/bin/

MONGOS_KEY=`xmllint --xpath 'string(/project/node[1]/attribute[2]/@value)' ${RUNDECK_HOME}mongos.xml`
SHARDS_KEY=`xmllint --xpath 'string(/project/node[1]/attribute[2]/@value)' ${RUNDECK_HOME}shards.xml` 
echo "MONGOS KEY = "${MONGOS_KEY} 
echo "SHARDS KEY = "${SHARDS_KEY}

${PROVISIONR_PATH}client "provisionr:destroy -k ${MONGOS_KEY}"
sleep 10
${PROVISIONR_PATH}client "provisionr:destroy -k ${SHARDS_KEY}"
sleep 10




 

