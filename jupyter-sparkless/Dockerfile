FROM aoehmich/cdh5.9:release-candidate
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

WORKDIR /root

ADD irkernel_install.r /root
ADD start_eae.sh /root

RUN apt-get update -q \
    && apt-get upgrade -y --install-recommends \
    && apt-get install -y git python-numpy python-scipy python-matplotlib ipython python-pip python-scikits-learn nodejs-legacy npm zip libcurl4-openssl-dev libxml2-dev screen \
    && pip install scimath \
    && pip install pymongo \
    && pip install tensorflow \
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
    && mkdir -p /home/eae/jupyter \
    && chown eae:eae /home/eae/jupyter \
    && chmod 777 /home/eae/jupyter \
    && cd /home/eae/jupyter

## Setting up R and R Kernel
RUN wget https://mran.revolutionanalytics.com/install/mro/3.3.1/microsoft-r-open-3.3.1.tar.gz \
    && tar xzf microsoft-r-open-3.3.1.tar.gz \
    && cd microsoft-r-open \
    && ./install.sh \
    && cd /root \
    && Rscript irkernel_install.r

EXPOSE 22 7180 7777 8433 8888 18088

VOLUME ["/root/jupyter/"]

ENTRYPOINT ["bash", "/root/start_eae.sh"]

## Default parameters in case the user does not provide them wih the RUN commande
CMD ["-deamon", interfaceeae, 8443, jupytereae, 22]