#!/bin/bash

ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
PROVISIONR_HOME=${ABSOLUTE_PATH}/provisionr-0.4.0-incubating/
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/

HDD_SIZE=60
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
if [ $OPTIND -eq 1 ]; then echo "No options were passed.Is mandatory to use both -s and -m options.Usage example ./createCluster -s <shards number> -m <mongosNumber>";exit 1; fi

# Create replicas
echo "***** Step 1: Creating cluster's replica members. *****"
run -j a-createReplicas -p mongoClusterDeployment --follow -- -SHARDS_NUMBER ${SHARDS_NUMBER} -HDD_SIZE ${HDD_SIZE} -PROVISIONR_PATH ${PROVISIONR_PATH}
echo "***** Step 1: Completed. *****"

# Configure replicas
echo "***** Step 2: Configure cluster's replicas. *****"
run -j b-configureReplicas -p mongoClusterDeployment --follow
echo "***** Step 2: Completed. *****"

# Create mongos
echo "***** Step 3: Create mongos platforms. *****"
run -j 3-createMongos -p mongoClusterDeployment --follow -- -MONGOS_NUMBER ${MONGOS_NUMBER} -PROVISIONR_PATH ${PROVISIONR_PATH}
echo "***** Step 3: Completed. *****"

#Configure mongos
echo "***** Step 4: Configure mongos platforms. *****"
run -j 4-configureMongos -p mongoClusterDeployment --follow
echo "***** Step 4: Completed. *****"
#Install Java
echo "***** Step 4: Configure mongos platforms. *****"
run -j 6-installJava -p mongoClusterDeployment --follow
echo "***** Step 4: Completed. *****"


