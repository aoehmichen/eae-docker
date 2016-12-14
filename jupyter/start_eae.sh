#!/usr/bin/env bash

service ssh restart
sed "/eae-jupyter/d" /etc/hosts |  sed '/127.0.0.1/c  127.0.0.1 eae-jupyter' > /tmp/sed.txt
cat /tmp/sed.txt > /etc/hosts
service cloudera-scm-server-db restart

sleep 60
service cloudera-scm-agent restart
sleep 20
service cloudera-scm-server restart

python /home/eae/Cloudera_Management.py

screen -d -m -S jupyter "jupyter-notebook --allow-root --kernel=ir"
