# docker build --rm -t bpmscd_bpms-design .
# docker run -p 28080:8080 -d --name=bpmscd_bpms-design_1 bpmscd_bpms-design
# docker run -p 28080:8080 -d --link bpmscd_mysql-bpms_1:mysql --link bpmscd_nexus_1:nexus --name=bpmscd_bpms-design_1 bpmscd_bpms-design

FROM centos7/java

MAINTAINER Bernard Tison <bernard.tison@gmail.com>

# Install unzip, mysql driver
RUN yum -y install unzip mysql-connector-java sudo && \
    yum clean all -y

# Copy files
ADD . /

# Create user jboss
RUN groupadd -r jboss -g 400 && useradd -u 400 -r -g jboss -d /opt/jboss -s /bin/bash -c "JBoss user" jboss

# Create installation directory and set permissions
# Sudo requires a tty
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers && \
    mkdir -p /opt/jboss && \
    chown -R jboss:jboss /opt/jboss && \
    chmod 755 /*.sh

# Run installation script
RUN /install-bpms.sh

CMD ["/bin/bash", "/start-container.sh"]
