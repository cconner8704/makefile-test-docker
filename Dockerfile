FROM cmconner156/docker-centos7-systemd
MAINTAINER Chris Conner <chrism.conner@gmail.com>

#https://hub.docker.com/_/centos/
#https://www.tecmint.com/install-pxe-network-boot-server-in-centos-7/
#https://www.linuxtechi.com/configure-pxe-installation-server-centos-7/
RUN set -ex                           \
    && yum install -y epel-release \
    && yum update -y \
    && yum install epel-release -y \
    && yum update -y \
    && yum install -y python-pip \
    && yum install -y net-tools \
    && yum install -y bind-utils \
    && yum install -y iproute \
    && yum install -y vim \
    && yum install -y syslinux \
    && yum install -y vim \
    && yum install -y less \
    && yum clean -y expire-cache

# volumes
VOLUME /vagrant               \      
       /systems               \
       /sys/fs/cgroup

# ports #tcp for all except 69 and 547 are UDP
EXPOSE 67/udp 67/tcp

#Add cobbler check systemd
RUN echo -e '[Unit]\n\
Description=Run cobbler check\n\
After=cobblergetloaders.service\n\
Requires=cobbler.service\n\
\n\
[Service]\n\
#WorkingDirectory=/etc/cobbler\n\
#Type=oneshot\n\
#RemainAfterExit=no\n\
ExecStart=/usr/bin/cobbler check\n\
#ExecReload=/usr/bin/cobbler check\n\
\n\
[Install]\n\
WantedBy=multi-user.target\n\
'\
>> /etc/systemd/system/cobblercheck.service


RUN systemctl daemon-reload
RUN systemctl enable cobblersync.service

# add run file
#ADD entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh

# entrypoint
CMD ["/usr/sbin/init"]
