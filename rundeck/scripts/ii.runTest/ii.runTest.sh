#!/bin/bash

TEST_NAME=$1
CURRENT_NODE=$2
DROP_DB=$3
OAKS_NUMBER=$4
DATABASE_NAME=$5
RUNTIME=$6
ENABLE_PROFILE=$7
MONGOS_PORT=27017
TEMP=`xmllint --xpath '/project/node/@hostname' mongos.xml|sed -e "s/ hostname=/ /g"| sed -e "s/\"/'/g"` 
REPOSITORY_FIXTURE=Oak-MongoNS

#cleanup first 
rm -rf ~/results/
mkdir ~/results/

declare -a all_mongos=($TEMP)
for (( i=0; i<${OAKS_NUMBER}; i++ ))
do
 mongos_trim=`echo ${all_mongos[$i]}|tr -d ''\'''`
 mongos[$i]=${mongos_trim}
done
echo "test_platforms=${mongos[@]}"
# Download and set Java  
export JAVA_HOME=/home/${USER}/jdk1.6.0_33/
export PATH=${JAVA_HOME}bin:$PATH
echo CURRENT_NODE=$CURRENT_NODE
echo ${mongos[@]}|grep ${CURRENT_NODE}
STATUS=$?
if [ "$STATUS" -eq "0" ]; then 
 echo "TEST executed on mongos->$CURRENT_NODE"
 echo Running command="java -Dwarmup=0 -Ddebug=true -Dverbose=true -Dincrements=10000,50000,100000,500000 -Dloaders=5 -Druntime=$RUNTIME -Dprofile=$ENABLE_PROFILE -mx1g -server -jar /home/${USER}/jackrabbit-oak/oak-run/target/oak-run-*.jar scalability $TEST_NAME ${REPOSITORY_FIXTURE} --db $DATABASE_NAME --dropDBAfterTest $DROP_DB"
 java -Dwarmup=0 -Ddebug=true -Dverbose=true -Dincrements=10000,50000,100000,500000 -Dloaders=5 -Druntime=$RUNTIME -Dprofile=$ENABLE_PROFILE -mx1g -server -jar /home/${USER}/jackrabbit-oak/oak-run/target/oak-run-*.jar scalability $TEST_NAME ${REPOSITORY_FIXTURE} --db $DATABASE_NAME --dropDBAfterTest $DROP_DB|tee ~/results/${TEST_NAME} 
fi
