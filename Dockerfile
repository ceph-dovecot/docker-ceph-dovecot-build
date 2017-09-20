FROM ubuntu:16.04
MAINTAINER Peter Mauritius <p.mauritius@tallence.com>

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      build-essential apt-utils git gettext automake \
      autoconf autotools-dev libtool wget pkg-config pandoc \
      libssl-dev librados-dev

RUN mkdir -p /usr/local/src && \
    git clone https://github.com/dovecot/core.git /usr/local/src/dovecot

RUN cd /usr/local/src/dovecot && \
    git checkout release-2.2.32 && \
    ./autogen.sh && \
    ./configure --enable-maintainer-mode --enable-devel-checks && \
    make clean install
