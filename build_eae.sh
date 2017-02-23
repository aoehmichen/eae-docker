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

cp jupyter/irkernel_install.r workerExample
cp interfaceEAE/lsb.* workerExample
cp interfaceEAE/lsb.* workerSparkExample
cp interfaceEAE/lsf.cluster.* workerExample
cp interfaceEAE/lsf.cluster.* workerSparkExample
cp interfaceEAE/lsfshpc* workerExample
cp interfaceEAE/lsfshpc* workerSparkExample

docker build interfaceEAE
docker build workerExample
docker build workerSparkExample
