#!/bin/bash

TEST_NAME=$1
OAKS_NUMBER=$2
OUTPUT_DIR=${WORKSPACE_DIR}/build/results
CHART_DIR=${WORKSPACE_DIR}/build/finalResults
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
mkdir -p ${CHART_DIR}
mkdir -p ${CHART_DIR}/${OAKS_NUMBER}/${TEST_NAME}

RESULTS_PATH=${OUTPUT_DIR}/${OAKS_NUMBER}/${TEST_NAME}/
CHART_RESULTS_PATH=${CHART_DIR}/${OAKS_NUMBER}/${TEST_NAME}/
# scp the test results from the test platforms

for mongosInstance in "${mongos[@]}" 
do
  scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${USER}@${mongosInstance}:~/results/${TEST_NAME} ${RESULTS_PATH}/${mongosInstance}.txt
  sleep 2 
done

# create the charts files (for jenkins charts plugin)- maximum 5 oaks
index=0
# get the 90% metric from each instance
for mongosInstance in "${mongos[@]}" 
do
 NUMBER_OF_LINES=`cat ${RESULTS_PATH}/${mongosInstance}.txt|wc -l`
 var=`sed "${NUMBER_OF_LINES}!d" ${INITIAL_RESULTS}/${mongosInstance}.txt|sed 's/[^0-9]*//'|sed 's/[ \t]* / | /g'`
 echo var=$var
 echo index=$index
 echo expectedResult="TESTCASEONLY |   | ${test} | test | date | "${var%|*}
 index=$(( $index + 1 ))
done
# echo "Test Suite | Test Case | Test Class | Test Method | DateTime | min | 10% | 50% | 90% | max " > ${CHART_RESULTS_PATH}/${mongosInstance}.txt
