FROM aoehmich/cdh5.9:latest
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

WORKDIR /root

ADD Cloudera_Management.py /root
ADD irkernel_install.r /root
ADD pyspark_kernel.json /root
ADD spark_kernel.json /root
ADD start_eae.sh /root

RUN echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 \
    && apt-get update -q \
    && apt-get upgrade -y --install-recommends \
    && apt-get install -y git python-numpy python-scipy python-matplotlib ipython python-pip python-scikits-learn nodejs-legacy npm zip libcurl4-openssl-dev libxml2-dev screen \
    && apt-get -y install libcurl4-gnutls-dev sbt \
    && pip install scimath \
    && pip install pymongo \
    && pip install cm-api \
    && chmod 777 start_eae.sh \
    && rm -f /home/eae/.ssh/*

## Setting up Jupyter notebook and we create the folder where the jupyter notebooks will run
RUN pip install setuptools pip --upgrade --user \
    && pip install jupyter \
    && git clone https://github.com/aoehmichen/notebook.git \
    && cd notebook \
    && pip install -e . --user \
    && cd /root \
    && jupyter-nbextension enable --py widgetsnbextension \
    && mkdir -p /root/jupyter \
    && chmod 777 /root/jupyter

## Setting up R and R Kernel
RUN wget https://mran.revolutionanalytics.com/install/mro/3.3.1/microsoft-r-open-3.3.1.tar.gz \
    && tar xzf microsoft-r-open-3.3.1.tar.gz \
    && cd microsoft-r-open \
    && ./install.sh \
    && cd /root \
    && Rscript irkernel_install.r

## Setting up the Spark Kernels (Toree)
RUN ipython profile create spark \
    && git clone https://github.com/CGnal/incubator-toree/ \
    && cd incubator-toree \
    && git checkout cdh5.7.x

RUN make dist \
    && mkdir -p /root/.ipython/kernels/spark \
    && mkdir -p /root/.ipython/kernels/pyspark \
    && cp -r dist/toree /root/.ipython/kernels/spark/ \
    && jupyter notebook --generate-config

RUN mv /root/spark_kernel.json /root/.ipython/kernels/spark/kernel.json \
    && mv /root/pyspark_kernel.json /root/.ipython/kernels/pyspark/kernel.json \
    && cd /root/.ipython/kernels/spark/toree/bin \
    && sed -i "/eval exec/d" run.sh \
    && echo 'exec "$SPARK_HOME"/bin/spark-submit \
        ${SPARK_OPTS} \
        --driver-class-path $PROG_HOME/lib/${KERNEL_ASSEMBLY} \
        --class org.apache.toree.Main $PROG_HOME/lib/${KERNEL_ASSEMBLY} "$@"' >> run.sh

EXPOSE 22 7180 7777 8433 8888 18088

VOLUME ["/root/jupyter/"]

ENTRYPOINT ["bash", "/root/start_eae.sh"]

## Default parameters in case the user does not provide them wih the RUN commande
CMD ["-deamon", interfaceeae, 8443, jupytereae, 22]