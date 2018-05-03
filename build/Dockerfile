FROM ubuntu:17.10
LABEL maintainer="p.mauritius@tallence.com"
ARG CEPH=v12.2.0
ARG DOVECOT

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      build-essential apt-utils git gettext automake \
      autoconf autotools-dev libtool wget pkg-config pandoc \
      libssl-dev librados-dev liblua5.1-0-dev libjansson-dev \ 
      valgrind software-properties-common apt-transport-https \
      wget postfix 

RUN mkdir -p /usr/local/src

RUN cd /usr/local/src && wget http://www.cpan.org/src/5.0/perl-5.22.1.tar.gz
RUN cd /usr/local/src && tar -xzf perl-5.22.1.tar.gz
RUN cd /usr/local/src/perl-5.22.1 && ./Configure -des -Dprefix=/usr/local &&make install
RUN rm /usr/local/src/perl-5.22.1.tar.gz
RUN rm -r /usr/local/src/perl-5.22.1
RUN git clone https://github.com/dovecot/core.git /usr/local/src/dovecot
RUN cd /usr/local/src/dovecot && git checkout $DOVECOT

RUN cd /usr/local/src/dovecot && ./autogen.sh && ./configure --enable-maintainer-mode --enable-devel-checks
RUN cd /usr/local/src/dovecot && make clean install

ADD dovecot_config/ /usr/local/etc/
ADD imaptest /usr/local/bin/
ADD lmtp_test_mail.tld /root/
ADD pop3-profile.conf /root/
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
