#!/usr/bin/env bash

## Setting up Jupyter notebook
pip install setuptools pip --upgrade --user
sudo pip install jupyter
git clone https://github.com/aoehmichen/notebook.git
cd notebook
pip install -e . --user
cd ..
sudo jupyter-nbextension enable --py widgetsnbextension

## Setting up R and R Kernel
wget https://mran.revolutionanalytics.com/install/mro/3.3.1/microsoft-r-open-3.3.1.tar.gz
tar xzf microsoft-r-open-3.3.1.tar.gz
cd microsoft-r-open
sudo ./install.sh
cd /root
sudo Rscript irkernel_install.r

## We create the folder where the jupyter notebooks will run
mkdir -p /root/jupyter
chmod 777 /root/jupyter