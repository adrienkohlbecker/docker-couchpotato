FROM kohlby/base:latest

RUN sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --force-yes unrar unzip git python python-lxml libssl-dev python-pip python-dev libffi-dev && \
    pip install pyopenssl && \
    git clone https://github.com/RuudBurger/CouchPotatoServer.git /opt/couchpotato && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN groupadd --gid 2000 media && \
    useradd --uid 2004 --gid 2000 --create-home couchpotato && \
    chown -R couchpotato:media /opt/couchpotato && \
    mkdir /data && \
    chown -R couchpotato:media /data
USER couchpotato

ADD . /app/couchpotato
WORKDIR /app/couchpotato

VOLUME ["/data"]

EXPOSE 5050

ENV SHR_EXEC_USER couchpotato
CMD ["bin/boot", "python", "/opt/couchpotato/CouchPotato.py", "--data_dir=/data", "--config=/tmp/couchpotato.ini", "--console_log"]
