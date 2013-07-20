#!/bin/bash 

# Step1
# Create database cluster node

RAND=$(( $RANDOM % 1000 ))
# KEY=k${RAND}
PROVISIONR_PATH=/home/tudor/repos/incubator-provisionr/karaf/assembly/target/org.apache.provisionr-0.4.0-incubating-SNAPSHOT/bin/
KEY=$1
${PROVISIONR_PATH}client "provisionr:destroy -k ${KEY}"
# wait for the instances to be created
