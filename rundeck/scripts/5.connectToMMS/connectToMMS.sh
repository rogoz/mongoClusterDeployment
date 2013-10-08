#!/bin/bash

COOKIES_FILE=cookie.txt
MMS_USER=$1
MMS_PASS=$2
MONGOS_HOST=`xmllint --xpath 'string(/project/node[1]/@hostname)' mongos.xml`
MONGOS_PORT=27017

echo User=$MMS_USER
echo Pass=$MMS_PASS

# login
curl -c cookies.txt 'https://mms.mongodb.com/user/v1/auth' -H 'Origin: https://mms.mongodb.com' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Host: mms.mongodb.com' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36' -H 'Content-Type: application/json; charset=UTF-8' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://mms.mongodb.com/' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data-binary "{\"username\":\"$MMS_USER\",\"password\":\"$MMS_PASS\"}" --compressed

# add cluster mongos platform
curl --user $MMS_USER:$MMS_PASS -b cookies.txt 'https://mms.mongodb.com/host/addHost/52501a707ec5df2d7b07a6a3' -H 'Origin: https://mms.mongodb.com' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Host: mms.mongodb.com' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://mms.mongodb.com/host/list/52501a707ec5df2d7b07a6a3' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data "hostname=$MONGOS_HOST&port=$MONGOS_PORT&username=&password=" --compressed
