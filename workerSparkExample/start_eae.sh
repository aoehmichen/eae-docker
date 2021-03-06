#!/usr/bin/env bash

# We get the environment set to get access to the openlava's bhosts, bqueues etc...
. /etc/profile.d/openlava.sh

# We restart the ssh services
service ssh restart

## Hosts file configuration change for CDH to work properly
sed "/eae-jupyter/d" /etc/hosts |  sed '/127.0.0.1/c  127.0.0.1 eae-jupyter' > /tmp/sed.txt
cat /tmp/sed.txt > /etc/hosts

cat /home/eae/.ssh/id_rsa.pub > /home/eae/.ssh/authorized_keys
chown -R eae:eae /home/eae/.ssh/
chmod 600 /home/eae/.ssh/id_rsa
chown openlava:openlava /opt/openlava-3.3/etc/*

# We restart the openlava service after we wait for the interface node to startup
service openlava restart

## We restart all the necessary Cloudera services
service cloudera-scm-server-db restart
sleep 60
service cloudera-scm-agent restart
sleep 120
service cloudera-scm-server restart
sleep 60

## We restart all the Hadoop services
python /root/Cloudera_Management.py

## Hook on the container
if [[ $1 == "-deamon" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
