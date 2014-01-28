#!/bin/bash

TEST_NAME=$1
CURRENT_NODE=$2
DATABASE_NAME=$3
DROP_DB=false
MONGOS_PORT=27017
MONGOS_MAIN_PLATFORM=`xmllint --xpath 'string(/project/node[1]/@hostname)' mongos.xml`
REPOSITORY_FIXTURE=Oak-MongoNS

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
 echo InitCommand="java -Dwarmup=0 -Druntime=1 -jar /home/${USER}/jackrabbit-oak/oak-run/target/oak-run-*.jar benchmark $TEST_NAME ${REPOSITORY_FIXTURE} --db $DATABASE_NAME --dropDBAfterTest $DROP_DB"
 java -Dwarmup=0 -Druntime=1 -jar /home/${USER}/jackrabbit-oak/oak-run/target/oak-run-*.jar benchmark $TEST_NAME ${REPOSITORY_FIXTURE} --db $DATABASE_NAME --dropDBAfterTest $DROP_DB &
 PID=`echo $!`
 sleep 50
 kill -9 $PID
fi


