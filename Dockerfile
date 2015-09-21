FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list && \
    apt-get update && \
    # couchpotato deps
    apt-get install -y --force-yes unrar unzip git curl python python-lxml libssl-dev python-pip python-dev libffi-dev && \
    # shr deps
    apt-get install -y --force-yes git mercurial && \
    pip install pyopenssl && \
    git clone https://github.com/RuudBurger/CouchPotatoServer.git /opt/couchpotato && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN curl http://homebrew.staging.cfn.aws.shr.st/shr/shr-20150920234558-linux.deb -o shr.deb && \
    dpkg -i shr.deb && \
    rm shr.deb

RUN useradd --uid 2004 --user-group --create-home couchpotato && \
    chown -R couchpotato /opt/couchpotato && \
    mkdir /data && \
    chown -R couchpotato /data
USER couchpotato

ADD . /app/couchpotato
WORKDIR /app/couchpotato

VOLUME ["/data"]

EXPOSE 5050

ENV SHR_EXEC_MODE development
ENV SHR_EXEC_USER couchpotato

ENTRYPOINT ["shr", "exec", "--"]
CMD ["bin/boot", "python", "/opt/couchpotato/CouchPotato.py", "--data_dir=/data", "--config=/tmp/couchpotato.ini", "--console_log"]
