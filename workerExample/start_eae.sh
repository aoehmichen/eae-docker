#!/usr/bin/env bash

# We get the environment set to get access to the openlava's bhosts, bqueues etc...
. /etc/profile.d/openlava.sh

# We restart the openlava services
service openlava restart

## Hook on the container
if [[ $1 == "-deamon" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
