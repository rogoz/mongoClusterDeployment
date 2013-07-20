#!/bin/bash  
 
# Configure the mongos stations.Starts the mongos process on each platform.The script must run on each mongos platform. 
 
LOG_DIR=/home/${USER}/MONGOS 
CONFIG_PORT=20001 
MONGOS_PORT=27017 
PROVISIONR_HOST=localhost  
PROVISIONR_PORT=8181  
 
mkdir ${LOG_DIR} 
MONGOS_MAIN=`xmllint --xpath 'string(/project/node[1]/@hostname)' mongos.xml` 
echo "Mongos main platform is "${MONGOS_MAIN} 
 
# build mongos command 
 
TEMP=`xmllint --xpath '/project/node/@hostname' shards.xml|sed -e "s/ hostname=/ /g"| sed -e "s/\"/'/g"` 
declare -a shards=($TEMP) 
echo shards=${shards[@]} 
 
AUX=
# total=${#shards[@]}
for (( i=0; i<=2; i++ ))
do 
  shard_trim=`echo ${shards[$i]}|tr -d ''\'''` 
  AUX=${AUX},${shard_trim}:${CONFIG_PORT} 
done 
AUX=${AUX:1} 
 
# kill  mongod process 
sudo killall -v mongod 
sleep 20
 
# start mongos process 
echo mongosCommand="mongos --port $MONGOS_PORT --configdb ${AUX} --fork --logpath ${LOG_DIR}/mongos.log" 
mongos --port $MONGOS_PORT --configdb ${AUX} --fork --logpath ${LOG_DIR}/mongos.log 

# wait 20 seconds for mongos to start 
sleep 20
