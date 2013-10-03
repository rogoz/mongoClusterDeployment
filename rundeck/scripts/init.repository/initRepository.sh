#!/bin/bash

TEST_NAME=$1
CURRENT_NODE=$2
DATABASE_NAME=$3
DROP_DB=false
MONGOS_PORT=27017
MONGOS_MAIN_PLATFORM=`xmllint --xpath 'string(/project/node[1]/@hostname)' mongos.xml`


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
 java -Dwarmup=0 -Druntime=0 -jar /home/${USER}/jackrabbit-oak/oak-run/target/oak-run-*.jar benchmark $TEST_NAME Oak-Mongo --db $DATABASE_NAME --dropDBAfterTest $DROP_DB
fi

