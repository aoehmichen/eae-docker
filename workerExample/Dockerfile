FROM ubuntu:16.04
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

ADD id_rsa /home/eae/.ssh/
ADD id_rsa.pub /home/eae/.ssh/

## We install all the dependencies
RUN apt-get update -q && apt-get upgrade -y --no-install-recommends \
    && apt-get install -y git python-numpy python-scipy python-matplotlib python-pip python-scikits-learn \
    && pip install scimath \
    && pip install pymongo

## Setting up R and R Kernel
RUN wget https://mran.revolutionanalytics.com/install/mro/3.3.1/microsoft-r-open-3.3.1.tar.gz \
    && tar xzf microsoft-r-open-3.3.1.tar.gz \
    && cd microsoft-r-open \
    && ./install.sh \
    && cd /root \
    && Rscript irkernel_install.r

RUN cat .ssh/id_rsa.pub > .ssh/authorized_keys \
    && echo "Host * \
    StrictHostKeyChecking no" > /home/eae/.ssh/config \
    && chown -R eae:eae .ssh/ \
    && chmod 600 .ssh/id_rsa

EXPOSE 22 16322 16323 16324 16325

ENTRYPOINT ["bash", "/root/start_eae.sh"]

CMD ["-deamon"]
