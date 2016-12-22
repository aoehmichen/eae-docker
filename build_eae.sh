#!/usr/bin/env bash

## Cleanup before build
rm -f id_rsa*
rm -f interfaceEAE/id_rsa*
rm -f jupyter/id_rsa.pub

## We generate the same key for all containers
ssh-keygen -t rsa -N "" -f id_rsa

## We copy to the directories
cp id_rsa interfaceEAE
cp id_rsa.pub interfaceEAE
cp id_rsa.pub jupyter
cp id_rsa workerExample
cp id_rsa.pub workerExample

## We build the images
docker build interfaceEAE/
docker build jupyter/