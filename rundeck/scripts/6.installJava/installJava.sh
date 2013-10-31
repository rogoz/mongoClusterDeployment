#!/bin/bash

JMETER_HOME=/usr/share/jmeter/
JMETER_EX_HOME=${JMETER_HOMElib}/ext
# Download and set Java
if [ ! -f jdk-6u33-linux-x64.bin ]; then
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk6-downloads-1637591.html;" http://download.oracle.com/otn-pub/java/jdk/6u33-b03/jdk-6u33-linux-x64.bin   
    chmod a+x jdk-6u33-linux-x64.bin
    yes | ./jdk-6u33-linux-x64.bin
fi

#Install Jmeter plugin
if [ ! -f jdk-6u33-linux-x64.bin ]; then
    wget http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.1.2.zip
    sudo cp JMeterPlugins-Standard-1.1.2.zip /usr/share/jmeter/JMeterPlugins-Standard-1.1.2.zip
    sudo unzip JMeterPlugins-Standard-1.1.2.zip
fi
