FROM cephdovecot/travis-base AS travis-ceph
LABEL maintainer="p.mauritius@tallence.com"
ARG CEPH=v12.2.0

RUN git clone https://github.com/ceph/ceph.git /usr/local/src/ceph
RUN cd /usr/local/src/ceph && git pull && git checkout $CEPH
RUN cd /usr/local/src/ceph && git submodule update --init --recursive
RUN cd /usr/local/src/ceph && ./install-deps.sh
RUN cd /usr/local/src/ceph && ./do_cmake.sh
RUN cd /usr/local/src/ceph/build && make -j2 vstart
