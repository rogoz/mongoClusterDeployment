=============================================================
Tool for Mongo database cluster deployment in Amazon Cloud
=============================================================

This is a simple solution for automatically deploying Mongo database clusters in the Amazon Cloud.

Compatibility
-------------

- Linux (tested on ubuntu)
- Mac OS


Prerequisites
-------------

- **libxml2-utils** package  (on ubuntu distribution, on other linux distributions can have another name)
- **amazon ec2 tools** 
- **wget**
- an Amazon EC2 account
- Ports 4440, 8181 must be free.

Installation
------------

1. Clone the repository
2. Run **[installationFolder]/build.sh**
3. Run **[installationFolder]/build/install.sh**
4. Configure your AWS account in **[installationFolder]/build/provisionr-0.4.0-incubating/etc/org.apache.provisionr.amazon.cfg** 
4. Run **[installationFolder]/build/startServers.sh**

Mongo cluster architecture
--------------------------

This solution can create a mongo cluster with **n** shards and **m** mongos instances.Each of the mongo nodes will be hosted on a separate EC2 instance in the Amazon cloud.A mongo shard consists of a single mongo node (mongod process).The scripts will not create mongo replica sets.The sharding property is enabled by default for a single database (Oak), and the sharding key is set to id:1 for both the nodes and blobs collections.


![ScreenShot](https://raw.github.com/rogoz/mongoClusterDeployment/master/resources/mongoArchitecture.png)


How to use it
-------------

- launch **<installation folder>/build/createCluster.sh** script (./createCluster.sh -s 3 -m 2) for creating a cluster
- use **<installation folder>/build/destroyCluster.sh** for removing the cluster
