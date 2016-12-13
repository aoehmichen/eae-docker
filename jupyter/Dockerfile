FROM aoehmich/cdh5.9:latest
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

RUN apt-get update -q
    && sudo apt-get upgrade -y --install-recommends \
    && service ssh restart && service postgresql restart && service cloudera-scm-server-db restart \
    && apt-get install -y git python-numpy python-scipy python-matplotlib ipython python-pip python-scikits-learn \
    && pip install scimath \
    && pip install pymongo \
    && pip install cm-api \
    && service cloudera-scm-server restart \
    && sleep 30 \
    && service cloudera-scm-agent restart

RUN python Cloudera_Management.py


