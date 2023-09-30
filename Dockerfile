FROM centos:7.2.1511
RUN \
  yum -y install openssh-clients openssh-server yum-plugin-ovl && \
  yum -y clean all && \
  touch /run/utmp && \
  chmod u+s /usr/bin/ping && \
  echo "root:boncia5106" | chpasswd
COPY identity.pub /root/.ssh/authorized_keys
ARG AMBARI_REPO_URL
ARG HDP_REPO_URL
RUN yum install -y sudo wget openssl-devel postgresql-jdbc mysql-connector-java unzip ntp
RUN systemctl enable ntpd
#RUN systemctl start ntpd
RUN wget -nv ${AMBARI_REPO_URL} -O /etc/yum.repos.d/ambari.repo
RUN wget -nv ${HDP_REPO_URL} -O /etc/yum.repos.d/hdp.repo
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
## Uncomment if you want to run kerberos in container
## RUN yum install -y krb5-server krb5-libs krb5-workstation
RUN yum install -y ambari-agent
#RUN yum install -y ambari-metrics-*
#RUN yum install -y ambari-logsearch-*
#RUN yum install -y hadoop*
#RUN yum install -y zookeeper*
#RUN yum install -y hive*
#RUN yum install -y phoenix_*
#RUN yum install -y ranger*
#RUN yum install -y storm_*
#RUN yum install -y kafka_*
#RUN yum install -y pig_*
#RUN yum install -y datafu_*
#RUN yum install -y spark* livy*
#RUN yum install -y zeppelin*
#RUN yum install -y falcon_*
#RUN yum install -y oozie_*
##RUN yum install -y lucidworks-hdpsearch
#RUN yum install -y smartsense*
#RUN yum install -y druid*
#RUN yum install -y superset*
#RUN yum install -y lzo snappy-devel rpcbind
RUN rm /etc/yum.repos.d/hdp*.repo
ADD scripts/start.sh /start.sh
CMD /start.sh
