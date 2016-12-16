#!/usr/bin/env bash

args=("$@")
ADDRESS=${args[0]}
PORT=${args[1]}
PASSWORD="${args[2]}"

## Safe guard against empty parameters
if [[ ! -z $PORT ]] || [[ ! -z $ADDRESS ]]; then
    echo "Interface eAE ADDRESS or PORT is not set!"
    echo "Interface eAE ADDRESS: $ADDRESS"
    echo "Interface eAE PORT: $PORT"
    exit 1
fi
echo "Interface eAE ADDRESS: $ADDRESS"
echo "Interface eAE PORT: $PORT"
echo "Notebook password HasH: $PASSWORD"

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

sed -i "s/.eae_ip = 'localhost'/.eae_ip = '$ADDRESS'/g" /root/.jupyter/jupyter_notebook_config.py

sed -i "s/.eae_port = 8081/.eae_port = $PORT/g" /root/.jupyter/jupyter_notebook_config.py

## We start the notebook server in the jupyter folder
cd /root/jupyter
jupyter-notebook --allow-root --kernel=ir