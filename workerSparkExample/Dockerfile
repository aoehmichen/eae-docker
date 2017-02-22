FROM aoehmich/cdh5.9:release-candidate
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

ADD Cloudera_Management.py /root
ADD start_eae.sh /root
ADD lsfshpc10.1-x86_64.tar.gz /root
ADD install.config /root
ADD lsb.hosts /root
ADD lsb.queues /root
ADD lsf.cluster.clusterLSF /root

## We install all the dependencies
RUN apt-get update -q \
    && apt-get install -y vim git wget curl zip python-numpy python-scipy python-matplotlib python-pip python-scikits-learn libcurl4-openssl-dev libncurses-dev libxml2-dev \
    && apt-get install -y libcurl4-gnutls-dev tcl-dev psmisc openssh-server \
    && pip install scimath \
    && pip install cm-api \
    && pip install pymongo

## We install LSF
RUN mkdir -p /usr/share/lsf/lsf_distrib/ \
    && gunzip lsfshpc10.1-x86_64.tar.gz \
    && tar -xvf lsfshpc10.1-x86_64.tar \
    && cd lsfshpc10.1-x86_64/lsf/ \
    && mv lsf10.1_linux2.6-glibc2.3-x86_64.tar.Z  /usr/share/lsf/lsf_distrib/ \
    && gunzip lsf10.1_lsfinstall_linux_x86_64.tar.Z \
    && tar -xvf lsf10.1_lsfinstall_linux_x86_64.tar --directory /usr/share/lsf/lsf_distrib/ \
    && cd /usr/share/lsf/lsf_distrib/lsf10.1_lsfinstall \
    && cp /root/install.config . \
    && lsfinstall -f install.config \
    && cd /root \
    && cp lsf.cluster.clusterLSF /usr/share/lsf/conf/ \
    && cp lsb.hosts lsb.queues /usr/share/lsf/conf/lsbatch/clusterLSF/configdir/ \
    && cd /usr/share/lsf/10.1/install \
    && ./hostsetup

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
