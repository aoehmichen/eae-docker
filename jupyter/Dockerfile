FROM aoehmich/cdh5.9:latest
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

RUN apt-get update -q \
    && apt-get upgrade -y --install-recommends \
    && apt-get install -y git python-numpy python-scipy python-matplotlib ipython python-pip python-scikits-learn nodejs-legacy npm zip libcurl4-openssl-dev libxml2-dev screen\
    && apt-get -y install libcurl4-gnutls-dev \
    && pip install scimath \
    && pip install pymongo \
    && pip install cm-api

WORKDIR /home/eae

ADD Cloudera_Management.py
ADD irkernel-install.r
ADD install_notebook.sh
ADD start_eae.sh

RUN chmod 777 start_eae.sh

RUN bash install_notebook.sh

EXPOSE 7180 7777 8888 18088

VOLUME ["/home/eae/"]

CMD ["bash", "-c", "/home/eae/start_eae.sh"]