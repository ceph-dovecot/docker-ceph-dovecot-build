FROM ubuntu:22.04
LABEL maintainer="p.mauritius@tallence.com"
ARG CEPH=v18.2.4
ARG DOVECOT_BASE=2.3
ARG DOVECOT=2.3.21
ARG PERL=5.40.0

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      build-essential apt-utils git gettext automake \
      autoconf autotools-dev libtool wget pkg-config pandoc liblua5.1-0-dev libjansson-dev valgrind software-properties-common apt-transport-https wget postfix libssl-dev libz-dev 

RUN wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add -
RUN echo deb https://download.ceph.com/debian-reef/ $(lsb_release -sc) main | tee /etc/apt/sources.list.d/ceph.list
RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
    librados-dev librados2 libradospp-dev

RUN mkdir -p /usr/local/src

RUN cd /usr/local/src && wget http://www.cpan.org/src/5.0/perl-$PERL.tar.gz
RUN cd /usr/local/src && tar -xzf perl-$PERL.tar.gz
RUN cd /usr/local/src/perl-$PERL && ./Configure -des -Dprefix=/usr/local &&make install
RUN rm /usr/local/src/perl-$PERL.tar.gz
RUN rm -r /usr/local/src/perl-$PERL
RUN cd /usr/local/src && wget https://dovecot.org/releases/$DOVECOT_BASE/dovecot-$DOVECOT.tar.gz
RUN cd /usr/local/src && tar -xzf dovecot-$DOVECOT.tar.gz 
RUN rm /usr/local/src/dovecot-$DOVECOT.tar.gz 
RUN mv /usr/local/src/dovecot-$DOVECOT /usr/local/src/dovecot

RUN cd /usr/local/src/dovecot && ./configure --enable-maintainer-mode --enable-devel-checks --with-zlib
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
