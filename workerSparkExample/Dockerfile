FROM aoehmich/cdh5.9:release-candidate
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

ADD Cloudera_Management.py /root
ADD start_eae.sh /root

## We install all the dependencies
RUN apt-get update -q \
    && apt-get install -y vim git wget curl zip python-numpy python-scipy python-matplotlib python-pip python-scikits-learn libcurl4-openssl-dev libncurses-dev libxml2-dev \
    && apt-get install -y libcurl4-gnutls-dev tcl-dev psmisc openssh-server \
    && pip install scimath \
    && pip install cm-api \
    && pip install pymongo

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
    && chown openlava:openlava /opt/openlava-3.3/etc/*

# We set up the ssh keys for user eae
RUN mkdir -p /home/eae/.ssh && chmod 700 /home/eae/.ssh \
    && echo "Host *" > /home/eae/.ssh/config \
    && echo "       StrictHostKeyChecking no" >> /home/eae/.ssh/config \
    && chown -R eae:eae /home/eae/.ssh/

WORKDIR /usr/lib/jvm

# We need to locate the proper java for Hadoop
RUN ln -s java-7-oracle-cloudera/ default-java

EXPOSE 22 16322 16323 16324 16325
EXPOSE 16322/udp

ENTRYPOINT ["bash", "/root/start_eae.sh"]

CMD ["-bash"]
