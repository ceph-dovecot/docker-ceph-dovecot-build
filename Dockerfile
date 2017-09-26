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

RUN git clone https://github.com/ceph/ceph.git /usr/local/src/ceph
RUN cd /usr/local/src/ceph && git pull && git checkout v12.2.0
RUN cd /usr/local/src/ceph && git submodule update --init --recursive
RUN cd /usr/local/src/ceph && ./install-deps.sh && \
RUN cd /usr/local/src/ceph && ./do_cmake.sh && \
RUN cd /usr/local/src/ceph/build && make vstart

#-----------------------------------------------------------------------------
FROM base AS dovecot
LABEL maintainer="p.mauritius@tallence.com"

RUN cd /usr/local/src/dovecot && git checkout ${DOVECOT:-master}
RUN cd /usr/local/src/dovecot && ./autogen.sh && ./configure --enable-maintainer-mode --enable-devel-checks && \
RUN cd /usr/local/src/dovecot && make -j clean install

#-----------------------------------------------------------------------------
FROM base AS dovecot-master-2-2
LABEL maintainer="p.mauritius@tallence.com"

RUN cd /usr/local/src/dovecot && git checkout ${DOVECOT:-master-2.2}
RUN cd /usr/local/src/dovecot && ./autogen.sh && ./configure --enable-maintainer-mode --enable-devel-checks && \
RUN cd /usr/local/src/dovecot && make -j clean install

#-----------------------------------------------------------------------------
FROM base AS dovecot-2-2-21
LABEL maintainer="p.mauritius@tallence.com"

RUN cd /usr/local/src/dovecot && git checkout release-2.2.21
RUN cd /usr/local/src/dovecot && ./autogen.sh && ./configure --enable-maintainer-mode --enable-devel-checks && \
RUN cd /usr/local/src/dovecot && make -j clean install

#-----------------------------------------------------------------------------
FROM base AS dovecot-2-2-32
LABEL maintainer="p.mauritius@tallence.com"

RUN cd /usr/local/src/dovecot && git checkout release-2.2.32
RUN cd /usr/local/src/dovecot && ./autogen.sh && ./configure --enable-maintainer-mode --enable-devel-checks && \
RUN cd /usr/local/src/dovecot && make -j clean install
