FROM ubuntu:17.10
LABEL maintainer="p.mauritius@tallence.com"
ARG CEPH=v12.2.0
ARG DOVECOT
ARG IMAPTEST

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      build-essential apt-utils git gettext automake \
      autoconf autotools-dev libtool wget pkg-config pandoc \
      libssl-dev librados-dev liblua5.1-0-dev libjansson-dev \ 
      valgrind software-properties-common apt-transport-https \
      wget 

RUN mkdir -p /usr/local/src

RUN git clone https://github.com/dovecot/core.git /usr/local/src/dovecot
RUN cd /usr/local/src/dovecot && git checkout $DOVECOT

RUN cd /usr/local/src/dovecot && ./autogen.sh && ./configure --enable-maintainer-mode --enable-devel-checks
RUN cd /usr/local/src/dovecot && make clean install

RUN git clone https://github.com/dovecot/imaptest.git /usr/local/src/imaptest
RUN cd /usr/local/src/imaptest && git checkout $IMAPTEST
RUN cd /usr/local/src/imaptest && ./autogen.sh && ./configure --with-dovecot=/usr/local/src/dovecot && make all

ADD dovecot_config/ /usr/local/etc/
RUN mv /usr/local/etc/dovecot.service /etc/init.d/
RUN mv /usr/local/etc/exec.sh /usr/local/bin/exec.sh
RUN addgroup --system dovecot
RUN adduser --system --no-create-home dovecot
RUN mkdir /usr/local/var
RUN chown -R dovecot:dovecot /usr/local/var/
RUN chmod -R 777 /usr/local/var/
RUN chown -R dovecot:dovecot /var/log
RUN mkdir /root/mail 
RUN cd /root/mail && wget http://www.dovecot.org/tmp/dovecot-crlf 
