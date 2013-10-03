#!/bin/bash

TEST_NAME=$1
CURRENT_NODE=$2
DATABASE_NAME=Oak-database-$RANDOM
MONGOS_PORT=27017
MONGOS_MAIN_PLATFORM=`xmllint --xpath 'string(/project/node[1]/@hostname)' mongos.xml`
# Download and set Java  
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk6-downloads-1637591.html;" http://download.oracle.com/otn-pub/java/jdk/6u33-b03/jdk-6u33-linux-x64.bin   
chmod a+x jdk-6u33-linux-x64.bin
yes | ./jdk-6u33-linux-x64.bin
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
 java -jar /home/${USER}/jackrabbit-oak/oak-run/target/oak-run-*.jar benchmark $TEST_NAME Oak-Mongo
else
 sleep 60
 java -jar /home/${USER}/jackrabbit-oak/oak-run/target/oak-run-*.jar benchmark $TEST_NAME Oak-Mongo
fi


