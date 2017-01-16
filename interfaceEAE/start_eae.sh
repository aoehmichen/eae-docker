#!/usr/bin/env bash

# We get the environment set to get access to the openlava's bhosts, bqueues etc...
. /etc/profile.d/openlava.sh

# We restart the openlava services
service openlava restart
service ssh restart

# We restart tomcat
killall java
mkdir -p /var/cache/tomcat7/Catalina/localhost
chown -R eae:eae /var/cache/tomcat7/Catalina

cat /home/eae/.ssh/id_rsa.pub > /home/eae/.ssh/authorized_keys
chmod 600 /home/eae/.ssh/id_rsa
chown -R eae:eae /home/eae/.ssh/
chown openlava:openlava /opt/openlava-3.3/etc/*
chown -R eae:eae /home/eae/.grails/interfaceEAEConfig

## build a local mongo if a remote one is not provided
if [[ $2 == "Unsecure" ]]; then
    ## We need to download and deploy an interfaceEAE version without user authentication
    rm -rf /var/lib/tomcat/webapps/interfaceEAE*
    rm -rf /var/lib/tomcat/logs/*
    curl -L https://github.com/aoehmichen/eae-files/raw/master/interfaceEAE_unsecure.war -o /var/lib/tomcat7/webapps/interfaceEAE.war
fi

service tomcat7 restart

### Sometimes the openlava master and workers are out of sync so we restart the service to make sure that every worker
### is accounted for.
sleep 60
service openlava restart

## Hook on the container
if [[ $1 == "-deamon" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
