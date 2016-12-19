FROM ubuntu:16.04
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

WORKDIR /root

## We install all the dependencies
RUN apt-get update -q && apt-get upgrade -y --no-install-recommends \
    && apt-get install -y wget curl git unzip zip tomcat7 libncurses-dev \
    && apt-get install -y tcl-dev \
    && mkdir -p /root/.grails/interfaceEAEConfig \
    && mkdir -p /root/data \
    && chmod 777 /root/data \
    && git clone https://github.com/aoehmichen/AnalyticsEAE.git /root/AnalyticsEAE \
    && curl -L "https://raw.githubusercontent.com/aoehmichen/interfaceEAE/master/web-app/Scripts/putToHDFS.sh" > /root/putToHDFS.sh \
    && chmod +x /root/putToHDFS.sh

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
    && chmod 755 /etc/profile.d/openlava.sh

ADD lsb.hosts /root
ADD lsb.queues /root
ADD lsf.cluster.openlava /root
ADD Config.groovy /root/.grails/interfaceEAEConfig/

RUN curl -L https://github.com/aoehmichen/eae-files/raw/master/interfaceEAE.war -o /var/lib/tomcat7/webapps/interfaceEAE.war \
    && mv lsb.hosts /opt/openlava-3.3/etc/ \
    && mv lsb.queues /opt/openlava-3.3/etc/ \
    && mv lsf.cluster.openlava /opt/openlava-3.3/etc/ \

EXPOSE 22 8081 16322 16323 16324 16325

ENTRYPOINT ["bash", "/root/start_eae.sh"]
