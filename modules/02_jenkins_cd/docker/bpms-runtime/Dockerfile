# docker build --rm -t bpmscd_bpms-qa .
# docker run -p 8080:8080 -d --name=bpmscd_bpms-qa_1 bpmscd_bpms-qa

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
