#!/usr/bin/env bash

# We get the environment set to get access to the openlava's bhosts, bqueues etc...
. /etc/profile.d/openlava.sh

# We restart the openlava services
service openlava restart

# We restart tomcat
killall java
mkdir /var/cache/tomcat7/Catalina/localhost
chown -R eae:eae /var/cache/tomcat7/Catalina
service tomcat7 restart

if [[ $1 == "-deamon" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
