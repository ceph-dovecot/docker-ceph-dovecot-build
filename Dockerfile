#-----------------------------------------------------------------------------
FROM ubuntu:16.04 AS base
LABEL maintainer="p.mauritius@tallence.com"

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      build-essential apt-utils git gettext automake \
      autoconf autotools-dev libtool wget pkg-config pandoc \
      libssl-dev librados-dev

RUN mkdir -p /usr/local/src

RUN git clone https://github.com/dovecot/core.git /usr/local/src/dovecot

RUN git clone https://github.com/ceph/ceph.git /usr/local/src/ceph && \
    cd /usr/local/src/ceph && \
    git checkout v12.2.0 && \
    git submodule update --init --recursive

RUN cd /usr/local/src/ceph && \
    ./install-deps.sh && \
    ./do_cmake.sh && \
    cd build && \
    make vstart

#-----------------------------------------------------------------------------
FROM base AS dovecot-master
LABEL maintainer="p.mauritius@tallence.com"

RUN cd /usr/local/src/dovecot && \
    git checkout ${DOVECOT:-master} && \
    ./autogen.sh && \
    ./configure --enable-maintainer-mode --enable-devel-checks && \
    make -j clean install && \
    make -j clean

#-----------------------------------------------------------------------------
FROM base AS dovecot-2-2-21
LABEL maintainer="p.mauritius@tallence.com"

RUN cd /usr/local/src/dovecot && \
    git checkout release_2.2.21 && \
    ./autogen.sh && \
    ./configure --enable-maintainer-mode --enable-devel-checks && \
    make -j clean install && \
    make -j clean

#-----------------------------------------------------------------------------
FROM base AS dovecot-2-2-32
LABEL maintainer="p.mauritius@tallence.com"

RUN cd /usr/local/src/dovecot && \
    git checkout release_2.2.32 && \
    ./autogen.sh && \
    ./configure --enable-maintainer-mode --enable-devel-checks && \
    make -j clean install && \
    make -j clean
