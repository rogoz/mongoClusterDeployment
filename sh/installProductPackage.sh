#!/bin/bash

PACKAGE_LINK=$1

ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
RUNDECK_HOME=${ABSOLUTE_PATH}/rundeck/

rm -rf ${ABSOLUTE_PATH}/productPackage
mkdir -p ${ABSOLUTE_PATH}/productPackage

# get/install/update product package
s3curl.pl --id=toto -- ${PACKAGE_LINK}>${ABSOLUTE_PATH}/productPackage/rundeckPackage.tar.gz
cd ${ABSOLUTE_PATH}/productPackage/
tar xvfz rundeckPackage.tar.gz

${RUNDECK_HOME}/tools/bin/rd-project -a create -p oakScalabilityHighLevel --project.ssh-keypath=${HOME}/.ssh/id_rsa --project.resources.url=http://localhost:8181/rundeck/machines.xml

${RUNDECK_HOME}/tools/bin/rd-project -a create -p tartan --project.ssh-keypath=${HOME}/.ssh/id_rsa --project.resources.url=http://localhost:8181/rundeck/machines.xml

# import jobs
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${ABSOLUTE_PATH}/productPackage/rundeckResources/jobs/a-downloadProduct.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${ABSOLUTE_PATH}/productPackage/rundeckResources/jobs/b-installProduct.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${ABSOLUTE_PATH}/productPackage/rundeckResources/jobs/c-getTestsOnMongos.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${ABSOLUTE_PATH}/productPackage/rundeckResources/jobs/d-runTests.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${ABSOLUTE_PATH}/productPackage/rundeckResources/jobs/e-getResultsHighLevel.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${ABSOLUTE_PATH}/productPackage/rundeckResources/jobs/e-getLogs.xml
${RUNDECK_HOME}/tools/bin/rd-jobs load -f ${ABSOLUTE_PATH}/productPackage/rundeckResources/jobs/t-installPackage.xml
kill -9 `ps -ef|grep rundeck|grep -v grep|awk '{print $2}'`
