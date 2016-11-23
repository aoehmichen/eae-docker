FROM ubuntu:16.04
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

RUN apt-get update -q && sudo apt-get upgrade -y --no-install-recommends && \
    apt-get install -y curl git unzip zip tomcat7

RUN curl -L https://github.com/aoehmichen/eae-files/raw/master/interfaceEAE.war -o /var/lib/tomcat7/webapps/interfaceEAE.war
