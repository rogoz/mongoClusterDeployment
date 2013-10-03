#!/bin/bash

echo Clone oak repository  
rm -rf jackrabbit-oak
git clone https://github.com/apache/jackrabbit-oak.git

# Download and set Java  
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk6-downloads-1637591.html;" http://download.oracle.com/otn-pub/java/jdk/6u33-b03/jdk-6u33-linux-x64.bin   
chmod a+x jdk-6u33-linux-x64.bin
yes | ./jdk-6u33-linux-x64.bin
export JAVA_HOME=/home/${USER}/jdk1.6.0_33/
export PATH=${JAVA_HOME}bin:$PATH


# Download and set Maven  
wget http://mirrors.hostingromania.ro/apache.org/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
mkdir maven
tar -xvf apache-maven-3.0.5-bin.tar.gz --strip 1 --directory maven
export M2=/home/${USER}/maven/bin
export MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=128m"
export PATH=$PATH:$M2

# build oak
mvn -f ./jackrabbit-oak/pom.xml clean install -DskipTests 
