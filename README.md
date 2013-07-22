============================================================
Mongo cluster deployment using Apache-provisionr and Rundeck
============================================================

This is a simple solution for automatically deploying Mongo database clusters in the Amazon Cloud.

Prerequisites
-------------

- a running **apache-provisionr** ( http://provisionr.incubator.apache.org )
- a **rundeck** instance running on the same host with provisionr
- **libxml2-utils** package installed (on ubuntu distribution, on other linux distributions can have another name)

Mongo cluster architecture
--------------------------

This solution can create a mongo cluster with **n** shards and **m** mongos instances.Each of the mongo nodes will be hosted on a separate EC2 instance in the Amazon cloud.A mongo shard consists of a single mongo node (mongod process).The scripts will not create mongo replica sets.The sharding property is enabled by default for a single database (Oak), and the sharding key is set to id:1 for both of the nodes and blobs collections.The database configuration can be changed by modifying the configuration scripts.


![ScreenShot](https://raw.github.com/rogoz/mongoClusterDeployment/master/resources/mongoArchitecture.png)


How to use it
-------------

- import in rundeck all 4 jobs from mongoClusterDeployment/rundeck/jobs directory.
- adapt the scripts varables (e.g. PROVISIONR PATH, RUNDECK HOME)
- launch createCluster.sh script (./createCluster.sh -s 3 -m 2)
