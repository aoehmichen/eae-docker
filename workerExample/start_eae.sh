#!/usr/bin/env bash

# We get the environment set to get access to the openlava's bhosts, bqueues etc...
. /etc/profile.d/openlava.sh

# We restart the openlava services
service openlava restart
service ssh restart

cat /home/eae/.ssh/id_rsa.pub > /home/eae/.ssh/authorized_keys
chown -R eae:eae /home/eae/.ssh/
chmod 600 /home/eae/.ssh/id_rsa
chown openlava:openlava /opt/openlava-3.3/etc/*

## Hook on the container
if [[ $1 == "-deamon" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
