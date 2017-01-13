#!/usr/bin/env bash

## Cleanup before build
rm -f id_rsa*
rm -f interfaceEAE/id_rsa*
rm -f jupyter/id_rsa.pub

## We generate the same key for all containers
ssh-keygen -t rsa -N "" -f id_rsa

## We copy to the directories
if [ ! -d ssh ]; then
    mkdir ssh
fi

rm -rf ssh/*
mv id_rsa* ssh/
cp interfaceEAE/lsf.cluster.* workerExample
cp jupyter/irkernel_install.r workerExample

docker-compose build

echo -e "Please start a screen with 'screen -S eae' \nThen run the command: 'docker-compose up' \nTo leave the screen please type Ctrl + a + d"


## We build the images
#docker build interfaceEAE/
#docker build jupyter/
#docker build workerExample/
#
## NB -it to be replaced by -d
### InterfaceEAE start
#docker run -it \
#            -h interfaceEAE \
#            --link mongo_mongo_1 \
#            --net mongo_default \
#            -v ~/.id_rsa.pub:/root/.ssh/.id_rsa.pub
#            -p 22222:22 \
#            -p 8443:8443 \
#            -p 16322:16322 \
#            -p 16323:16323 \
#            -p 16324:16324 \
#            -p 16325:16325 \
#            --add-host worker1:$WorkerIP \
#            aoehmichen/interfaceEAE:latest -bash None
#
#docker run -it \
#            -h worker1 \
#            -p 22222:22 \
#            -p 16322:16322 \
#            -p 16323:16323 \
#            -p 16324:16324 \
#            -p 16325:16325 \
#            --add-host interfaceEAE:146.169.33.20 \
#            xxxxxxxx -bash
#
#docker run -it \
#            -h interfaceEAE \
#            -v ./id_rsa.pub:/home/eae/.ssh/id_rsa.pub \
#            -v ./interfaceEAE/Config.groovy:/home/eae/.grails/transmartConfig/Config.groovy \
#            -v ./id_rsa:/home/eae/.ssh/id_rsa \
#            -v ./interfaceEAE/lsb.hosts :/opt/openlava-3.3/etc/lsb.hosts \
#            aoehmichen/interfaceEAE:latest