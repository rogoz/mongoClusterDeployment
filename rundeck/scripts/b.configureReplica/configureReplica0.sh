#!/bin/bash  
 

echo "jenkins soft nofile 500000" | sudo tee /etc/security/limits.conf
echo "jenkins hard nofile 500000" | sudo tee -a /etc/security/limits.conf
