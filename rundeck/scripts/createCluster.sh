#!/bin/bash

RUNDECK_HOME=/home/tudor/Tools/rundeck/
PROVISIONR_HOME=/home/tudor/repos/incubator-provisionr/karaf/assembly/target/org.apache.provisionr-0.4.0-incubating-SNAPSHOT/

HDD_SIZE=25
PATH=${PATH}:${RUNDECK_HOME}tools/bin
PROVISIONR_PATH=${PROVISIONR_HOME}bin/

# use -s for the number of shards and -m for the number of mongos instances

while getopts s:m: option
do
        case "${option}"
        in
                s) SHARDS_NUMBER=${OPTARG};;
                m) MONGOS_NUMBER=${OPTARG};;
        esac
done

# Create shards
echo "***** Step 1: Creating cluster's shards. *****"
run -i 11 --follow -- -SHARDS_NUMBER ${SHARDS_NUMBER} -HDD_SIZE ${HDD_SIZE} -PROVISIONR_PATH ${PROVISIONR_PATH}
echo "***** Step 1: Completed. *****"

# Configure shards
echo "***** Step 2: Configure cluster's shards. *****"
run -i 12 --follow
echo "***** Step 2: Completed. *****"

# Create mongos
echo "***** Step 3: Create mongos platforms. *****"
run -i 13 --follow -- -MONGOS_NUMBER ${MONGOS_NUMBER} -PROVISIONR_PATH ${PROVISIONR_PATH}
echo "***** Step 3: Completed. *****"

#Configure mongos
echo "***** Step 4: Configure mongos platforms. *****"
run -i 14 --follow
echo "***** Step 4: Completed. *****"

