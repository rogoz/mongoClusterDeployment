#!/bin/bash

JMETER_HOME=/usr/share/jmeter/
JMETER_EX_HOME=${JMETER_HOME}lib/ext
# Download and set Java
if [ ! -f jdk-6u33-linux-x64.bin ]; then
    wget http://ubuntuone.com/1R6uULElw2AJ2E0ymvqURY --output-document jdk-6u33-linux-x64.bin   
    chmod a+x jdk-6u33-linux-x64.bin
    yes | ./jdk-6u33-linux-x64.bin
    mv jdk1.6.0_37 jdk1.6.0_33
fi

sudo chmod -R a+x ${JMETER_HOME}
sudo rm -rf JMeterPlugins-Standard-1.1.2.zip
sudo rm -rf ${JMETER_HOME}/JMeterPlugins-Standard-1.1.2.zip
sudo wget http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.1.2.zip
sudo cp JMeterPlugins-Standard-1.1.2.zip ${JMETER_HOME}/JMeterPlugins-Standard-1.1.2.zip
cd ${JMETER_HOME}
sudo unzip -o JMeterPlugins-Standard-1.1.2.zip
ulimit -n 
ulimit -Hn 

