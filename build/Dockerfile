FROM base:latest
MAINTAINER Peter Mauritius <p.mauritius@tallence.com>

RUN cd /usr/local/src/dovecot && \
    git checkout ${DOVECOT:-master} && \
    ./autogen.sh && \
    ./configure --enable-maintainer-mode --enable-devel-checks && \
    make -j clean install && \
    make -j clean
