#FROM ceph/daemon:v4.0.22-stable-4.0-nautilus-centos-7-x86_64
FROM quay.io/ceph/demo
LABEL maintainer="jan.radon@jaraco.de"
ARG CEPH=v18.2.4
ARG DOVECOT=2.3.21

#RUN yum-config-manager --disable tcmu-runner
#RUN yum-config-manager --disable tcmu-runner-noarch
#RUN yum-config-manager --disable tcmu-runner-  

 RUN yum -y install git make autoconf perl automake vim \
    wget jansson bison flex telnet libtool gettext gettext-devel pkg-config m4 libcurl-devel \
    librados-devel valgrind gcc-c++ postfix
ADD librados-devel/* /usr/include/rados/
ADD shtool-2.0.8/ /root/shtool

RUN wget https://github.com/akheron/jansson/releases/download/v2.13.1/jansson-2.13.1.tar.gz && tar -xvzf jansson-2.13.1.tar.gz && cd jansson-2.13.1 && ./configure && make && make install && cd .. && rm -rf jansson-2.13.1.tar.gz && rm -rf jansson-2.13.1
# jansson-devel + shtool

# with already downloaded dovecot
# ADD dovecot /usr/local/src/dovecot
# with patched source

ADD 0001-centos-ignore-ssl-cert-errors.patch /root/
RUN git clone https://github.com/dovecot/core.git /usr/local/src/dovecot
RUN cd /usr/local/src/dovecot && git checkout ${DOVECOT}
RUN cd /usr/local/src/dovecot && git config --global user.email "jan.radon@jaraco.de"
RUN cd /usr/local/src/dovecot && git config --global user.name "jan radon"
RUN cd /usr/local/src/dovecot && git am < /root/0001-centos-ignore-ssl-cert-errors.patch 

RUN echo 'export ACLOCAL_PATH=$ACLOCAL_PATH:/usr/local/share/aclocal' >> ~/.bashrc
RUN mkdir -p /usr/local/src

RUN cd /usr/local/src/dovecot && ./autogen.sh 
RUN cd /usr/local/src/dovecot && PANDOC=false ./configure --enable-maintainer-mode
RUN cd /usr/local/src/dovecot && make clean install

RUN git clone https://github.com/jrse/imaptest.git /usr/local/src/imaptest
RUN cd /usr/local/src/imaptest && ./autogen.sh && ./configure --with-dovecot=/usr/local/lib/dovecot 
RUN cd /usr/local/src/imaptest && make install && cp /usr/local/src/imaptest/src/imaptest /usr/bin
ADD entrypoint.sh /opt/ceph-container/bin/entrypoint.sh

RUN ldconfig
ADD dovecot_config/ /usr/local/etc/
ADD lmtp_test_mail.tld /root/
ADD missing-trailer_sample1.txt /root/
ADD pop3-profile.conf /root/
 
#RUN mv /usr/local/etc/dovecot.service /etc/systemd/system/dovecot.service
RUN mv /usr/local/etc/exec.sh /usr/local/bin/exec.sh
RUN groupadd --system dovecot
RUN adduser --system --no-create-home dovecot -g dovecot
RUN mkdir /usr/local/var
RUN chown -R dovecot:dovecot /usr/local/var/
RUN chmod -R 777 /usr/local/var/
RUN chown -R dovecot:dovecot /var/log
RUN mkdir /root/mail 
RUN cd /root/mail && wget http://www.dovecot.org/tmp/dovecot-crlf --no-check-certificate
