#!/bin/bash

echo Clone oak repository  
git clone https://github.com/apache/jackrabbit-oak.git  
# build oak
mvn -f ./jackrabbit-oak/pom.xml clean install -DskipTests 
