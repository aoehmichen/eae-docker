#!/usr/bin/env bash

## We restart all the necessary services
service ssh restart
sed "/eae-jupyter/d" /etc/hosts |  sed '/127.0.0.1/c  127.0.0.1 eae-jupyter' > /tmp/sed.txt
cat /tmp/sed.txt > /etc/hosts
service cloudera-scm-server-db restart

sleep 60
service cloudera-scm-agent restart
sleep 120
service cloudera-scm-server restart

# We restart all the Hadoop services
python /home/eae/Cloudera_Management.py

## We start the notebook server in the jupyter folder
cd /root/jupyter
jupyter-notebook --allow-root --kernel=ir
