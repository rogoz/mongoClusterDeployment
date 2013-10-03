#!/bin/bash

TEST_NAME=$1
CURRENT_NODE=$2
DROP_DB=$3
OAKS_NUMBER=$4
DATABASE_NAME=Oak-database-$RANDOM

TEMP=`xmllint --xpath '/project/node/@hostname' shards.xml|sed -e "s/ hostname=/ /g"| sed -e "s/\"/'/g"` 
declare -a all_mongos=($TEMP)
for i in {1..$OAKS_NUMBER}
do
 mongos_trim=`echo ${all_mongos[i-1]}|tr -d ''\'''`
 mongos[i-1]=${mongos_trim}
done
echo "test_platoforms=${mongos[@]}"

MONGOS_PORT=27017
MONGOS_MAIN_PLATFORM=`xmllint --xpath 'string(/project/node[1]/@hostname)' mongos.xml`
TIMEOUT=60

# Download and set Java  
export JAVA_HOME=/home/${USER}/jdk1.6.0_33/
export PATH=${JAVA_HOME}bin:$PATH

if [ "$CURRENT_NODE" == "$MONGOS_MAIN_PLATFORM" ]; then 
 mongo --host localhost $DATABASE_NAME --port $MONGOS_PORT --eval "db.createCollection(\"nodes\")"
 mongo --host localhost $DATABASE_NAME --port $MONGOS_PORT --eval "db.createCollection(\"blobs\")"
 echo "Enable sharding on $DATABASE_NAME"
 mongo --host localhost $DATABASE_NAME --port $MONGOS_PORT --eval "sh.enableSharding(\"$DATABASE_NAME\")"  
 mongo --host localhost $DATABASE_NAME --port $MONGOS_PORT --eval "sh.shardCollection(\"$DATABASE_NAME.nodes\", { \"_id\": 1 }, true)" 
 mongo --host localhost $DATABASE_NAME --port $MONGOS_PORT --eval "sh.shardCollection(\"$DATABASE_NAME.blobs\", { \"_id\": 1 }, true)" 
 echo "Start tests on the main mongos platform"
 java -jar /home/${USER}/jackrabbit-oak/oak-run/target/oak-run-*.jar benchmark $TEST_NAME Oak-Mongo --db $DATABASE_NAME --dropDBAfterTest $DROP_DB
else
 sleep $TIMEOUT
 # Starts the tests only if is part of the 
 echo ${mongos[@]}}|grep ${CURRENT_NODE}&&java -jar /home/${USER}/jackrabbit-oak/oak-run/target/oak-run-*.jar benchmark $TEST_NAME Oak-Mongo --db $DATABASE_NAME --dropDBAfterTest $DROP_DB
fi


