FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --force-yes unrar unzip git curl python python-lxml libssl-dev python-pip python-dev libffi-dev && \
    pip install pyopenssl && \
    git clone https://github.com/RuudBurger/CouchPotatoServer.git /opt/couchpotato && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

WORKDIR /opt/couchpotato

RUN useradd --uid 2004 --user-group --create-home couchpotato && \
    chown -R couchpotato /opt/couchpotato
USER couchpotato

ADD boot.sh /config/boot.sh
ADD couchpotato.ini /config/couchpotato.ini

VOLUME ["/data"]

EXPOSE 5050

CMD ["/config/boot.sh", "python", "CouchPotato.py", "--data_dir=/data", "--config=/tmp/couchpotato.ini", "--console_log"]
