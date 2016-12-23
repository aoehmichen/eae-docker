FROM mongo:3.4.0
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

ADD insert_first_user.py /root

RUN apt-get install -y python-dev python-pip \
    && pip install pymongo \
    && pip install pycrypto \
    && python /root/insert_first_user.py localhost:27017 eae

EXPOSE 27017
