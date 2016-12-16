#!/usr/bin/env bash

args=("$@")
ADDRESS=${args[0]}
PORT=${args[1]}
PASSWORD="${args[2]}"

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

echo "## Address of the interfaceEAE.
#  The address should either be the IP of the machine or the FQDN.
c.NotebookApp.eAEAddress = $ADDRESS" | tee -a /root/.jupyter/jupyter_notebook_config.py

printf "## Port of the interfaceEAE.
c.NotebookApp.eAEPort = $PORT" | tee -a /root/.jupyter/jupyter_notebook_config.py

## We start the notebook server in the jupyter folder
cd /root/jupyter
jupyter-notebook --allow-root --kernel=ir
