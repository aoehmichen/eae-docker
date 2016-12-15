FROM aoehmich/cdh5.9:latest
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

RUN echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 \
    && apt-get update -q \
    && apt-get upgrade -y --install-recommends \
    && apt-get install -y git python-numpy python-scipy python-matplotlib ipython python-pip python-scikits-learn nodejs-legacy npm zip libcurl4-openssl-dev libxml2-dev screen\
    && apt-get -y install libcurl4-gnutls-dev sbt \
    && pip install scimath \
    && pip install pymongo \
    && pip install cm-api

WORKDIR /root

ADD Cloudera_Management.py /root
ADD irkernel_install.r /root
ADD jupyter_notebook_config.py /root
ADD pyspark_kernel.json /root
ADD spark_kernel.json /root
ADD install_notebook.sh /root
ADD start_eae.sh /root

RUN chmod 777 start_eae.sh && mkdir -p /root/jupyter

RUN bash install_notebook.sh

EXPOSE 7180 7777 8888 18088

VOLUME ["/root/jupyter/"]

CMD ["bash", "-c", "/home/eae/start_eae.sh"]