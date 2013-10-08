#!/bin/bash

#!/bin/bash

ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# install PROVISIONR
echo ${ABSOLUTE_PATH}
mkdir -p ${ABSOLUTE_PATH}/org.apache.provisionr-0.4.0-incubating-SNAPSHOT/
tar xvfz ${ABSOLUTE_PATH}/org.apache.provisionr-0.4.0-incubating-SNAPSHOT.tar.gz -C ${ABSOLUTE_PATH}

# install RUNDECK
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/
java -jar ${RUNDECK_HOME}/rundeck*.jar &
sleep 75
# create project
${RUNDECK_HOME}/tools/bin/rd-project -a create -p mongoClusterDeployment --project.ssh-keypath=${HOME}/.ssh/id_rsa --project.resources.url=http://localhost:8181/rundeck/machines.xml
# import jobs
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${RUNDECK_HOME}/Jobs/1-createShards.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${RUNDECK_HOME}/Jobs/2-configureShards.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${RUNDECK_HOME}/Jobs/3-createMongos.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${RUNDECK_HOME}/Jobs/4-configureMongos.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${RUNDECK_HOME}/Jobs/5-monitorCluster.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${RUNDECK_HOME}/Jobs/i-getTests.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${RUNDECK_HOME}/Jobs/ii-runTest.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${RUNDECK_HOME}/Jobs/init.repository.xml
sleep 5
kill -9 `ps -ef|grep rundeck|grep -v grep|awk '{print $2}'`





