#!/bin/bash 
 
# Configure the mongos stations 2.Enable sharding on DATABASE_NAME, and sets the sharding key for blobs and nodes collections.
 
MONGOS_MAIN=`xmllint --xpath 'string(/project/node[1]/@hostname)' mongos.xml` 
CURRENT_NODE=$1
MONGOS_PORT=27017 
MONGOD_PORT=27017 
DATABASE_NAME=Oak 
# get shards Ips 
 
TEMP=`xmllint --xpath '/project/node/@hostname' shards.xml|sed -e "s/ hostname=/ /g"| sed -e "s/\"/'/g"` 
declare -a shards=($TEMP) 
 
function retry {
   nTrys=0
   maxTrys=100
   status=256
   until [ $status == 0 ] ; do
      echo Running command $1
      $1
      status=$?
      nTrys=$(($nTrys + 1))
      if [ $nTrys -gt $maxTrys ] ; then
            echo "Number of re-trys exceeded. Exit code: $status"
            exit $status
      fi
      if [ $status != 0 ] ; then
            echo "Failed (exit code $status)... retry $nTrys"
            sleep 20
      fi
   done
}

TEST_COMMAND='mongo --eval "printjson(db.serverStatus())"'
retry "${TEST_COMMAND}" 

echo "jenkins soft nofile 500000" | sudo tee /etc/security/limits.conf
echo "jenkins hard nofile 500000" | sudo tee /etc/security/limits.conf



 
# configure the cluster from the main platform 
if [ "$CURRENT_NODE" == "$MONGOS_MAIN" ]; then 

	echo MONGOS $MONGOS_MAIN starting to configure the shards 
	# drop Oak databases on each shard
	for shard in "${shards[@]}" 
	do
	  shard_trim=`echo $shard|tr -d ''\'''` 
	  mongo --host $shard_trim Oak --port $MONGOD_PORT --eval "db.dropDatabase()"
	  sleep 2 
	done

	for shard in "${shards[@]}" 
	do 
	  shard_trim=`echo $shard|tr -d ''\'''` 
	  echo "Link shard:sh.addShard(\"${shard_trim}:${MONGOD_PORT}\")" 
	  mongo --host localhost admin --port $MONGOS_PORT --eval "sh.addShard(\"${shard_trim}:${MONGOD_PORT}\")" 
	  sleep 2 
	done 

	# Set sharding key for nodes and blobs on the mongos platform
	mongo --host localhost $DATABASE_NAME --port $MONGOS_PORT --eval "db.createCollection(\"nodes\")"
	mongo --host localhost $DATABASE_NAME --port $MONGOS_PORT --eval "db.createCollection(\"blobs\")"
        echo "Enable sharding"
        mongo --host localhost $DATABASE_NAME --port $MONGOS_PORT --eval "sh.enableSharding(\"$DATABASE_NAME\")"  
	mongo --host localhost $DATABASE_NAME --port $MONGOS_PORT --eval "sh.shardCollection(\"$DATABASE_NAME.nodes\", { \"_id\": 1 }, true)" 
	mongo --host localhost $DATABASE_NAME --port $MONGOS_PORT --eval "sh.shardCollection(\"$DATABASE_NAME.blobs\", { \"_id\": 1 }, true)" 
fi

