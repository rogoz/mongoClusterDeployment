#!/bin/bash

PROVISIONR_DOWNLOAD_LINK=http://www.us.apache.org/dist/incubator/provisionr/stable/provisionr-0.4.0-incubating.tar.gz
RUNDECK_DOWNLOAD_LINK=http://download.rundeck.org/jar/rundeck-launcher-2.0.1.jar


ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

rm -rf ${ABSOLUTE_PATH}/build
mkdir -p ${ABSOLUTE_PATH}/build
mkdir -p ${ABSOLUTE_PATH}/build/rundeck
mkdir -p ${ABSOLUTE_PATH}/build/rundeck/Jobs
echo Download provisionr
wget --output-document ${ABSOLUTE_PATH}/build/org.apache.provisionr-0.4.0-incubating-SNAPSHOT.tar.gz ${PROVISIONR_DOWNLOAD_LINK} 
echo Download rundeck
wget -P ${ABSOLUTE_PATH}/build/rundeck ${RUNDECK_DOWNLOAD_LINK}
# copy all the bash scripts
cp ${ABSOLUTE_PATH}/sh/* ${ABSOLUTE_PATH}/build
# copy rundeck jobs
cp ${ABSOLUTE_PATH}/rundeck/jobsConfiguration/* ${ABSOLUTE_PATH}/build/rundeck/Jobs
# build the archive
tar -zcvf buildMongoDeployment.tar.gz build/

