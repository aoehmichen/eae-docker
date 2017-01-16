FROM tomcat:7-jre8
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

# Mongo secure version of eAE for tranSMART
#RUN curl -L 'https://api.onedrive.com/v1.0/shares/s!AmuQT6XMtdBag7RZXm_o2BtaX9oxyA/root/content' -o /usr/local/tomcat/webapps/transmart.war

# Mongo unsercure version of eAE for tranSMART
RUN curl -L 'https://api.onedrive.com/v1.0/shares/s!AmuQT6XMtdBag7Y98AWWGJgbZTgvIg/root/content' -o /usr/local/tomcat/webapps/transmart.war

# change the random number generator to /dev/urandom, since inside a container there is not a lot of
# entropy to feed /dev/random and it will block for a long time when starting the application
RUN sed -i 's#securerandom.source=file:/dev/random#securerandom.source=file:/dev/urandom#' /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security

# make these directories volumes so the rserve container can use them
VOLUME ["/tmp"]
VOLUME ["/usr/local/tomcat/webapps"]
