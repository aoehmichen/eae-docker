#!/usr/bin/env bash

# We get the environment set to get access to the openlava's bhosts, bqueues etc...
. /etc/profile.d/openlava.sh

# We restart the openlava services
service openlava restart

# We set up the ssl certificate and https for tomcat
/usr/lib/jvm/default-java/bin/keytool -genkey -alias tomcat -keyalg RSA -storepass changeit -keypass changeit -validity 365 -dname "cn=AOehmichen, ou=eAE, o=DSI, c=UK"
sed -i -e '89d;93d' /var/lib/tomcat7/conf/server.xml
sed -i "s/sslProtocol=\"TLS\"/sslProtocol=\"TLS\"  keystorePass=\"changeit\"/g" /var/lib/tomcat7/conf/server.xml

echo "Host *
    StrictHostKeyChecking no" > /home/eae/.ssh/config

# We restart tomcat
service tomcat7 restart

if [[ $1 == "-deamon" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi