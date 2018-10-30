FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
 && apt-get update \
 && apt-get install -y git python python-pip python-lxml \
 && pip install pyopenssl \
 && git clone https://github.com/CouchPotato/CouchPotatoServer.git /opt/couchpotato \
 && rm -rf /var/lib/apt/lists/*

VOLUME ["/data"]
EXPOSE 5050

CMD ["python", "/opt/couchpotato/CouchPotato.py", "--data_dir=/data", "--console_log"]
