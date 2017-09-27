FROM cephdovecot/travis-base AS travis-ceph
LABEL maintainer="p.mauritius@tallence.com"

RUN cd /usr/local/src/ceph && ./do_cmake.sh
RUN cd /usr/local/src/ceph/build && make -j2 vstart
