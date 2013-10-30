#!/bin/bash

TEST_NAME=$1
OAKS_NUMBER=$2
mkdir ${WORKSPACE_DIR}/testResultsHighLevel/
OUTPUT_DIR=${WORKSPACE_DIR}/testResultsHighLevel/

#check the test platforms
TEMP=`xmllint --xpath '/project/node/@hostname' mongos.xml|sed -e "s/ hostname=/ /g"| sed -e "s/\"/'/g"` 
declare -a all_mongos=($TEMP)
for (( i=0; i<${OAKS_NUMBER}; i++ ))
do
 mongos_trim=`echo ${all_mongos[$i]}|tr -d ''\'''`
 mongos[$i]=${mongos_trim}
done
echo "test_platforms=${mongos[@]}"

mkdir -p ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}/${OAKS_NUMBER}/${TEST_NAME}/


RESULTS_PATH=${OUTPUT_DIR}/${OAKS_NUMBER}/${TEST_NAME}/
# scp the test results from the test platforms

for mongosInstance in "${mongos[@]}" 
do
  scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${USER}@${mongosInstance}:~/testResultsHighLevel/${TEST_NAME}.xml ${RESULTS_PATH}/${mongosInstance}.xml
  sleep 2 
done
