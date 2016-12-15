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
cd /root
sudo Rscript irkernel_install.r

## Setting up the Spark Kernels (Toree)
sudo ipython profile create spark
git clone https://github.com/CGnal/incubator-toree/
cd incubator-toree
git checkout cdh5.7.x
sudo make dist
mkdir -p /root/.ipython/kernels/spark
mkdir -p /root/.ipython/kernels/pyspark
cp -r dist/toree /root/.ipython/kernels/spark/
jupyter notebook --generate-config
mv /root/jupyter_notebook_config.py /root/.jupyter/
mv /root/spark_kernel.json /root/.ipython/kernels/spark/kernel.json
mv /root/pyspark_kernel.json /root/.ipython/kernels/pyspark/kernel.json
cd /root/.ipython/kernels/spark/toree/bin
sed -i "/eval exec/d" run.sh
echo 'exec "$SPARK_HOME"/bin/spark-submit \
  ${SPARK_OPTS} \
  --driver-class-path $PROG_HOME/lib/${KERNEL_ASSEMBLY} \
  --class org.apache.toree.Main $PROG_HOME/lib/${KERNEL_ASSEMBLY} "$@"' >> run.sh

## We create the folder where the jupyter notebooks will run
mkdir /root/jupyter