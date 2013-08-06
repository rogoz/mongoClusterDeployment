#!/bin/bash


# Create database mongos nodes.This script must run on the rundeck local server.
# MONGOS_NUMBER is defined as a rundeck job option

RAND=$(( $RANDOM % 100000 ))
MONGOS_KEY=s${RAND}
SHARDS_KEY=`xmllint --xpath 'string(/project/node[1]/attribute[@name="key"]/@value)' shards.xml`
MONGOS_NUMBER=$1
PROVISIONR_PATH=$2
PROVISIONR_HOST=localhost 
PROVISIONR_PORT=8181 
AWS_ACCOUNT_NUMBER=2746-7893-5004

# creates new instances on amazon
${PROVISIONR_PATH}client "provisionr:create --id amazon --key ${MONGOS_KEY} --size ${MONGOS_NUMBER} --hardware-type m1.large --template mongos --image-id ami-4965f479 --timeout 600"
# wait for the instances to be created
sleep 600

# create mongos connection file on localhost
rm -rf mongos.xml 
wget http://${PROVISIONR_HOST}:${PROVISIONR_PORT}/rundeck/machines.xml -O mongos.xml


# send the shards.xml and mongos.xml files to the mongos platforms

TEMP=`xmllint --xpath '/project/node/attribute[@name="publicIp"]/@value' mongos.xml | sed -e "s/ value=/ /g"| sed -e "s/\"/'/g"`
declare -a MONGOS=($TEMP)
echo MONGOS=${MONGOS[@]}

for ip in "${MONGOS[@]}"
do
  echo Sending the shards connection parameters to "${ip}"
  trim_ip=`echo $ip|tr -d ''\'''`
  echo scpcommand="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no shards.xml ${USER}@${trim_ip}:/home/${USER}/shards.xml"
  # send shards to mongos platforms	
  scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no shards.xml ${USER}@${trim_ip}:/home/${USER}/shards.xml
  scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no mongos.xml ${USER}@${trim_ip}:/home/${USER}/mongos.xml
done

# open the ports between shards and mongos
echo "Authorize communication between security groups -> network-${MONGOS_KEY}(mongos) and network-${SHARDS_KEY} (shards)"
ec2-authorize network-${SHARDS_KEY} -o network-${MONGOS_KEY} -u $AWS_ACCOUNT_NUMBER
ec2-authorize network-${SHARDS_KEY} -o network-${SHARDS_KEY} -u $AWS_ACCOUNT_NUMBER
ec2-authorize network-${MONGOS_KEY} -o network-${SHARDS_KEY} -u $AWS_ACCOUNT_NUMBER
