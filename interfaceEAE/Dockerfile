FROM ubuntu:16.04
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

WORKDIR /root

ADD lsb.hosts /root
ADD lsb.queues /root
ADD lsf.cluster.openlava /root
ADD Config.groovy /root
ADD id_rsa /root
ADD id_rsa.pub /root
ADD start_eae.sh /root

## We install all the dependencies
RUN apt-get update -q && apt-get upgrade -y --no-install-recommends \
    && apt-get install -y wget curl git unzip zip tomcat7 libncurses-dev psmisc default-jdk vim htop \
    && apt-get install -y tcl-dev \
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


# We set the configuration files
RUN curl -L https://github.com/aoehmichen/eae-files/raw/master/interfaceEAE.war -o /var/lib/tomcat7/webapps/interfaceEAE.war \
    && mv lsb.hosts /opt/openlava-3.3/etc/ \
    && mv lsb.queues /opt/openlava-3.3/etc/ \
    && mv lsf.cluster.openlava /opt/openlava-3.3/etc/

# We create the eae user and set the tomcat to run as the newly created eae user
RUN useradd -ms /bin/bash eae \
    && mkdir -p /home/eae/.grails/interfaceEAEConfig \
    && mv /root/Config.groovy /home/eae/.grails/interfaceEAEConfig \
    && service tomcat7 stop \
    && sed -i "s/TOMCAT7_USER=tomcat7/TOMCAT7_USER=eae/g" /etc/default/tomcat7 \
    && sed -i "s/TOMCAT7_GROUP=tomcat7/TOMCAT7_GROUP=eae/g" /etc/default/tomcat7 \
    && chown -R eae:eae /var/log/tomcat7 \
    && chown eae:eae /var/lib/tomcat7/webapps \
    && chown eae:eae /var/cache/tomcat7 \
    && chown -R eae:eae /var/cache/tomcat7/Catalina \
    && chown -R root:eae /var/lib/tomcat7/conf/ \
    && usermod -a -G tomcat7 eae

# We set up the ssh keys for user eae
USER eae
WORKDIR /home/eae
RUN echo -e "\n\n\n" | ssh-keygen -t rsa
    && rm -rf .ssh/id_rsa*
ADD id_rsa /home/eae/.ssh/
ADD id_rsa.pub /home/eae/.ssh/
RUN cat .ssh/id_rsa.pub > .ssh/authorized_keys

EXPOSE 22 8443 16322 16323 16324 16325

ENTRYPOINT ["bash", "/root/start_eae.sh"]
