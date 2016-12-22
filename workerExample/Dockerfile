FROM ubuntu:16.04
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

ADD id_rsa /home/eae/.ssh/
ADD id_rsa.pub /home/eae/.ssh/
ADD ../interfaceEAE/lsf.cluster.openlava /root

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

## We install openlava
RUN curl -L https://github.com/aoehmichen/eae-files/raw/master/op.tar.gz -o /root/op.tar.gz  \
    && tar zxvf /root/op.tar.gz openlava-3.3 \
    && cd openlava-3.* \
    && ./configure \
    && make \
    && make install \
    && cd config \
    && cp lsb.hosts lsb.params lsb.queues lsb.users lsf.cluster.openlava lsf.conf lsf.shared lsf.task openlava.* /opt/openlava-3.3/etc/ \
    && useradd -r openlava \
    && chown -R openlava:openlava /opt/openlava-3.*/ \
    && cp /opt/openlava-3.*/etc/openlava /etc/init.d \
    && update-rc.d openlava defaults \
    && cp /opt/openlava-3.3/etc/openlava.* /etc/profile.d \
    && chown openlava:openlava /etc/profile.d/openlava.* \
    && chmod 755 /etc/profile.d/openlava.sh \
    && mv lsf.cluster.openlava /opt/openlava-3.3/etc/

RUN cat .ssh/id_rsa.pub > .ssh/authorized_keys \
    && echo "Host * \
    StrictHostKeyChecking no" > /home/eae/.ssh/config \
    && chown -R eae:eae .ssh/ \
    && chmod 600 .ssh/id_rsa

EXPOSE 22 16322 16323 16324 16325

ENTRYPOINT ["bash", "/root/start_eae.sh"]

CMD ["-deamon"]
