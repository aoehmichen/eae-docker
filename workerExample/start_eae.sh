#!/usr/bin/env bash

# We get the environment set to get access to the LSF's bhosts, bqueues etc...
. /usr/share/lsf/conf/profile.lsf

cd /usr/share/lsf/10.1/install
./hostsetup --top="/usr/share/lsf" --quiet

# We restart the ssh services
service ssh restart

cat /home/eae/.ssh/id_rsa.pub > /home/eae/.ssh/authorized_keys
chown -R eae:eae /home/eae/.ssh/
chmod 600 /home/eae/.ssh/id_rsa

# We restart the LSF service after we wait for the interface node to startup
sleep 20
badmin hstartup
lsadmin resstartup
lsadmin limstartup


## Hook on the container
if [[ $1 == "-deamon" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
