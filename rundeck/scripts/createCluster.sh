#!/bin/bash

RUNDECK_HOME=/home/tudor/Tools/rundeck/
PATH=${PATH}:${RUNDECK_HOME}tools/bin
HDD_SIZE=25
PROVISIONR_PATH=/home/tudor/repos/incubator-provisionr/karaf/assembly/target/org.apache.provisionr-0.4.0-incubating-SNAPSHOT/bin/


# Create shards
echo "***** Step 1: Creating cluster's shards. *****"
echo "Number of shards ${SHARDS_NUMBER}.ETA 10 minutes."
run -i 7 --follow -- -SHARDS_NUMBER ${SHARDS_NUMBER} -HDD_SIZE ${HDD_SIZE} -PROVISIONR_PATH ${PROVISIONR_PATH}
echo "***** Step 1: Completed. *****"

# Configure shards
echo "***** Step 2: Configure cluster's shards. *****"
run -i 1 --follow
echo "***** Step 2: Completed. *****"

# Create mongos
echo "***** Step 3: Create mongos platforms. *****"
run -i 3 --follow -- -MONGOS_NUMBER ${MONGOS_NUMBER} -PROVISIONR_PATH ${PROVISIONR_PATH}
echo "***** Step 3: Completed. *****"

#Configure mongos
echo "***** Step 4: Configure mongos platforms. *****"
run -i 6 --follow
echo "***** Step 4: Completed. *****"

