#!/usr/bin/env bash

args=("$@")
START_MODE=${args[0]}
ADDRESS=${args[1]}
PORT=${args[2]}
HOST_IP=${args[3]}
SSH_HOST_PORT=${args[4]}
PASSWORD="${args[5]}"

## Safe guard against empty parameters
if [[ ! -z $PORT ]] || [[ ! -z $ADDRESS ]] || [[ ! -z $HOST_IP ]] || [[ ! -z $SSH_HOST_PORT ]]; then
    echo "Interface eAE ADDRESS or PORT or HOST_IP or SSH_HOST_PORT is not set!"
    echo "Interface eAE ADDRESS: $ADDRESS"
    echo "Interface eAE PORT: $PORT"
    echo "IP of the host machine: $HOST_IP"
    echo "Host machine port where ssh is mapped: $SSH_HOST_PORT"
    exit 1
fi
echo "Interface eAE ADDRESS: $ADDRESS"
echo "Interface eAE PORT: $PORT"
echo "Notebook password Hash: $PASSWORD"
echo "IP of the host machine: $HOST_IP"
echo "Host machine port where ssh is mapped: $SSH_HOST_PORT"

## We restart all the necessary services
service ssh restart
sed "/eae-jupyter/d" /etc/hosts |  sed '/127.0.0.1/c  127.0.0.1 eae-jupyter' > /tmp/sed.txt
cat /tmp/sed.txt > /etc/hosts
service cloudera-scm-server-db restart

sleep 60
service cloudera-scm-agent restart
sleep 120
service cloudera-scm-server restart
sleep 60

## We restart all the Hadoop services
python /root/Cloudera_Management.py

## We configure the ssl certificate
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -subj "/C=UK/ST=Denial/L=London/O=DSI/CN=$ADDRESS" -keyout notebook.key -out notebook.pem

## We set the eae configurations (IP + port) and password for Jupyter
## You can prepare a hashed password using the function notebook.auth.security.passwd('password')
if [[ ! -z $PASSWORD ]]; then
    sed -i "s/sha1:854cd6632c4a:532c127d43cb1ff05745850979f4c863e3351da8/$PASSWORD/g" /root/.jupyter/jupyter_notebook_config.py
fi

# We edit the default configurations
sed -i "s/.eae_ip = 'localhost'/.eae_ip = '$ADDRESS'/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/.eae_port = 8433/.eae_port = $PORT/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/.eae_host_ip = '127.0.0.1'/.eae_host_ip = '$HOST_IP'/g" /root/.jupyter/jupyter_notebook_config.py
sed -i "s/.eae_host_ssh_port = 22222/.eae_host_ssh_port = $SSH_HOST_PORT/g" /root/.jupyter/jupyter_notebook_config.py

## We start the notebook server in the jupyter folder
cd /root/jupyter
screen -d -m -S jupyter "jupyter-notebook --allow-root --kernel=ir"

if [[ $START_MODE == "-deamon" ]]; then
  while true; do sleep 1000; done
fi

if [[ $START_MODE == "-bash" ]]; then
  /bin/bash
fi