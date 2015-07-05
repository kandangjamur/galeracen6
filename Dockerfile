# Percona XtraDB Cluster 5.6
#
# VERSION 1.0
# DOCKER-VERSION 1.7.0 build 0baf609
#
# tag: 6
FROM centos:6
MAINTAINER Obet <say@obet.us>

RUN yum -y update;

RUN echo 'root:1pWd0' | chpasswd
RUN yum -y install openssh-server openssh-clients which wget
# unsafe
#RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN mkdir -p /root/.ssh; chmod 700 /root/.ssh
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chown root.root /root/.ssh/*; chmod 600 /root/.ssh/*

# supervisord for sshd
RUN yum -y install python-setuptools
RUN yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/socat-1.7.2.3-1.el6.x86_64.rpm
RUN easy_install supervisor
ADD supervisord.conf /etc/
RUN chown root.root /etc/supervisord.conf

# epel
# Centos 6
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
# Centos 7
#RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
#RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
#RUN rpm -Uvh epel* remi-*

# Percona 5.6
RUN rpm -Uhv http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
RUN yum -y remove mysql-*
RUN yum -y install Percona-XtraDB-Cluster-56 qpress
RUN rm -rf /var/lib/mysql/* /var/run/mysqld/* /etc/my.cnf
ADD my.cnf /etc/my.cnf
RUN chown mysql:mysql /var/lib/mysql -R
RUN chown mysql:mysql /etc/my.cnf
RUN yum -y install nano
#ADD nodeip /usr/bin/nodeip
#RUN chmod +x /usr/bin/nodeip
RUN yum -y install libaio
RUN wget http://s.obet.us/files/sysbench-0.5-3.el6_.x86_64.rpm
RUN rpm -Uvh sysb*
RUN rm -f *.rpm

EXPOSE 22 3306 4444 4567 4568

ADD init.sh /opt/mysecure.sh
RUN chown root.root /opt/mysecure.sh
CMD ["/bin/bash", "/opt/mysecure.sh"]
#CMD ["/usr/sbin/init"]

