#!/usr/bin/env bash

# We generate the same key for all containers
ssh-keygen -t rsa -N "" -f id_rsa

cp  id_rsa interfaceEAE
cp  id_rsa.pub interfaceEAE

cp id_rsa.pub jupyter

# We build the images
Docker build interfaceEAE/
Docker build jupyter/