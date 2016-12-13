FROM aoehmich/cdh5.9:latest
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

RUN apt-get update -q \
    && apt-get upgrade -y --install-recommends \
    && service ssh restart \
    && sed "/eae-jupyter/d" /etc/hosts |  sed '/127.0.0.1/c  127.0.0.1 eae-jupyter' > /tmp/sed.txt \
    && cat /tmp/sed.txt > /etc/hosts \
    && service cloudera-scm-server-db restart \
    && apt-get install -y git python-numpy python-scipy python-matplotlib ipython python-pip python-scikits-learn \
    && pip install scimath \
    && pip install pymongo \
    && pip install cm-api \
    && service cloudera-scm-agent restart \
    && sleep 20 \
    && service cloudera-scm-server restart

RUN python Cloudera_Management.py


