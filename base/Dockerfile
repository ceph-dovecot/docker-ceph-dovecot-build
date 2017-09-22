FROM ubuntu:16.04
MAINTAINER Peter Mauritius <p.mauritius@tallence.com>

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      build-essential apt-utils git gettext automake \
      autoconf autotools-dev libtool wget pkg-config pandoc \
      libssl-dev librados-dev

RUN mkdir -p /usr/local/src

RUN git clone https://github.com/dovecot/core.git /usr/local/src/dovecot

RUN git clone https://github.com/ceph/ceph.git /usr/local/src/ceph && \
    cd /usr/local/src/ceph && \
    git submodule update --init --recursive

RUN cd /usr/local/src/ceph && \
    ./install-deps.sh && \
    ./do_cmake.sh && \
    cd build && \
    make -j vstart

