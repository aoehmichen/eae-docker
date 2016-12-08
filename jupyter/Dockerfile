FROM aoehmich/eae-cdh:latest
MAINTAINER Axel Oehmichen <axelfrancois.oehmichen11@imperial.ac.uk>

RUN apt-get update -q && sudo apt-get upgrade -y --install-recommends \
    && apt-get install -y git python-numpy python-scipy python-matplotlib ipython python-pip python-scikits-learn \
    && pip install scimath && pip install pymongo==3.2.2


