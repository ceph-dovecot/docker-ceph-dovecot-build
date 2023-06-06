# Dovecot ceph combined container

This container is for development only. it provides a easy to use dev envrionment for building
and testing the dovecot ceph plugin.


## Feature
- dovecot server
- ceph demo container
- all necessary packages for development
- testuser t1-t100
- imaptest
- smtp-source

## How To

docker build -t ceph-dovecot-combined:your-version-here .


## usage

- git clone the ceph-dovecot plugin locally.
- go to the cloned ceph-plugin directory and execute the docker run command.

docker run -d --name ceph_dovecot_combined --mount type=tmpfs,destination=/etc/ceph -v $(pwd):/repo -p 10143:10143 -e MON_IP=127.0.0.1 -e CEPH_PUBLIC_NETWORK=127.0.0.0/24 -e CEPH_DEMO_UID=test_uuid ceph-dovecot-combined:your-version-here demo


- exec into the container and go to the /repo directory
- build the plugin as described in the (ceph-plugin) .gitlab-ci.yaml file
    - ./autogen.sh
    - ./configure --with-dovecot=/usr/local/lib/dovecot --enable-maintainer-mode --enable-debug --with-integration-tests --enable-valgrind --enable-debug
    - make clean install        
    - chmod 777 /etc/ceph/*    
    - chmod -R 777 /usr/local/var/
    - ldconfig 
    - dovecot    
- you can run the imaptest and connect to the container by using imap localhost:1024