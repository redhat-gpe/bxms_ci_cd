FROM centos:7

# Usage
# docker build --rm -t bxmscicd-storage .
# docker run -d --name=bxmscicd_storage bxmscicd-storage

# Perform updates
RUN yum -y update && yum clean all

# Create user jboss user for Nexus, Jenkins and BPMS containers
RUN groupadd -r jboss -g 400 && useradd -u 400 -r -g jboss -d /opt/jboss -s /bin/bash jboss

# Nexus
RUN mkdir -p /data
RUN chown -R jboss:jboss /data
VOLUME /data

# BxMS Mysql
RUN groupadd -r mysql -g 27 && useradd -u 27 -r -g mysql -d /var/lib/mysql -s /bin/bash mysql
RUN mkdir -p /var/lib/mysql/data
RUN chown -R mysql:mysql /var/lib/mysql
VOLUME /var/lib/mysql/data

# BPMS-*
RUN mkdir -p /opt/jboss/bpms-design-data
RUN mkdir -p /opt/jboss/bpms-qa-data
RUN mkdir -p /opt/jboss/bpms-prod-data
RUN chown -R jboss:jboss /opt/jboss
VOLUME /opt/jboss/bpms-design-data
VOLUME /opt/jboss/bpms-qa-data
VOLUME /opt/jboss/bpms-prod-data


# Gitlab Postgresql
RUN mkdir -p /var/lib/pgsql
RUN groupadd -r postgres -g 26 && useradd -u 26 -r -g postgres -d /var/lib/pgsql -s /bin/bash postgres
RUN chown -R postgres:postgres /var/lib/pgsql
VOLUME /var/lib/pgsql

# Gitlab
RUN groupadd -r git -g 1500 && useradd -u 1500 -g git -c "GitLab" git
RUN mkdir -p /home/git/data
RUN mkdir -p /var/log/gitlab
RUN chown -R git:git /home/git/data
RUN chown -R git:git /var/log/gitlab
VOLUME /home/git/data
VOLUME /var/log/gitlab

# Jenkins
RUN mkdir -p /opt/jenkins
RUN chown -R jboss:jboss /opt/jenkins
VOLUME /opt/jenkins

CMD true
