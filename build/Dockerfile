FROM ubuntu:16.04
LABEL maintainer="p.mauritius@tallence.com"
ARG CEPH=v12.2.0

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      build-essential apt-utils git gettext automake \
      autoconf autotools-dev libtool wget pkg-config pandoc \
      libssl-dev librados-dev

RUN mkdir -p /usr/local/src

RUN git clone https://github.com/dovecot/core.git /usr/local/src/dovecot
RUN cd /usr/local/src/dovecot && git checkout ${DOVECOT:-master}

RUN cd /usr/local/src/dovecot && ./autogen.sh && ./configure --enable-maintainer-mode --enable-devel-checks
RUN cd /usr/local/src/dovecot && make -j clean install

RUN git clone https://github.com/ceph/ceph.git /usr/local/src/ceph
RUN cd /usr/local/src/ceph && git pull && git checkout $CEPH
RUN cd /usr/local/src/ceph && git submodule update --init --recursive
RUN cd /usr/local/src/ceph && ./install-deps.sh
RUN cd /usr/local/src/ceph && ./do_cmake.sh
RUN cd /usr/local/src/ceph/build && make -j2 vstart
