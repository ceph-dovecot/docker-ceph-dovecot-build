#-----------------------------------------------------------------------------
FROM travis-base AS travis-build
LABEL maintainer="p.mauritius@tallence.com"
ARG DOVECOT=master

RUN cd /usr/local/src/dovecot && git checkout $DOVECOT
RUN cd /usr/local/src/dovecot && ./autogen.sh && ./configure --enable-maintainer-mode --enable-devel-checks
RUN cd /usr/local/src/dovecot && make -j clean install
