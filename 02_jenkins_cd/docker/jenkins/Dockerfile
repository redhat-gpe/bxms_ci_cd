FROM centos7/java

ENV JENKINS_HOME /opt/jenkins
ENV JENKINS_VERSION 1.625.1

# Install packages
RUN yum -y install wget git && \
    yum clean all

# Install maven
RUN wget -O /etc/yum.repos.d/epel-apache-maven.repo http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo && \
    yum -y install apache-maven-3.2.5 && \
    yum clean all

ADD resources/tini-static /bin/tini

ADD resources/jenkins-$JENKINS_VERSION.war /usr/share/jenkins/jenkins.war

COPY jenkins.sh /usr/local/bin/jenkins.sh

ADD config/maven-settings.xml /maven-settings.xml

# Create user jenkins
RUN groupadd -r jenkins -g 400 && useradd -u 400 -r -g jenkins -d "$JENKINS_HOME" -s /bin/bash -c "jenkins user" jenkins

# Set permissions
RUN mkdir "$JENKINS_HOME" && \
    mkdir -p /usr/share/jenkins/ref && \
    chown -R jenkins:jenkins "$JENKINS_HOME" /usr/share/jenkins/ref /maven-settings.xml && \
    chmod +x /bin/tini /usr/local/bin/jenkins.sh

USER jenkins

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
