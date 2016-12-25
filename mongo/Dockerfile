FROM ubuntu:16.04
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

WORKDIR /root

ADD insert_first_user.py /root

RUN apt-get install -y python-dev python-pip \
    && pip install pymongo \
    && pip install pycrypto

EXPOSE 27017

CMD["echo","Use the commands provided by python to initialize the database for the eae interface. E.g. run\ndocker-compose run --rm tmload python insert_first_user.py localhost:27017 eae""]
