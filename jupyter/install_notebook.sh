#!/usr/bin/env bash

## Setting up Jupyter notebook
pip install setuptools pip --upgrade --user
sudo pip install jupyter
git clone https://github.com/aoehmichen/notebook.git
cd notebook
pip install -e . --user
cd ..
sudo jupyter-nbextension enable --py widgetsnbextension
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout notebook.key -out notebook.pem

## Setting up R and R Kernel
wget https://mran.revolutionanalytics.com/install/mro/3.3.1/microsoft-r-open-3.3.1.tar.gz
tar xzf microsoft-r-open-3.3.1.tar.gz
cd microsoft-r-open
sudo ./install.sh
cd ../notebook-install
sudo Rscript irkernel-install.r

## Setting up the Spark Kernel (Toree)
sudo ipython profile create spark
git clone https://github.com/CGnal/incubator-toree/
cd incubator-toree
git checkout cdh5.7.x
sudo make dist
mkdir -p ~/.ipython/kernels/spark
cp -r dist/toree ~/.ipython/kernels/spark/
cd ~/.ipython/kernels/spark/
