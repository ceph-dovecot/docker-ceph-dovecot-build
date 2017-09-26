#-----------------------------------------------------------------------------
FROM base AS build
LABEL maintainer="p.mauritius@tallence.com"

RUN cd /usr/local/src/dovecot && git checkout ${DOVECOT:-master}
RUN cd /usr/local/src/dovecot && ./autogen.sh && ./configure --enable-maintainer-mode --enable-devel-checks && \
RUN cd /usr/local/src/dovecot && make -j clean install
