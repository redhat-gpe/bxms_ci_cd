# docker build --rm -t bpmscd_jenkins .
# docker run -p 8080:8080 -d --name=bpmscd_jenkins_1 bpmscd_jenkins
# sudo nsenter -m -u -n -i -p -t `docker inspect --format '{{ .State.Pid }}' bpmscd_jenkins_1` /bin/bash

FROM centos7/java

ENV JENKINS_HOME /opt/jenkins
ENV JENKINS_REF /usr/share/jenkins/ref/
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

RUN mkdir -p $JENKINS_REF/plugins

# git plugin
RUN curl -L -o $JENKINS_REF/plugins/git.hpi http://updates.jenkins-ci.org/latest/git.hpi
RUN curl -L -o $JENKINS_REF/plugins/git-client.hpi http://updates.jenkins-ci.org/latest/git-client.hpi
RUN curl -L -o $JENKINS_REF/plugins/scm-api.hpi http://updates.jenkins-ci.org/latest/scm-api.hpi
RUN curl -L -o $JENKINS_REF/plugins/ssh-credentials.hpi http://updates.jenkins-ci.org/latest/ssh-credentials.hpi
RUN curl -L -o $JENKINS_REF/plugins/credentials.hpi http://updates.jenkins-ci.org/latest/credentials.hpi
RUN curl -L -o $JENKINS_REF/plugins/mailer.hpi http://updates.jenkins-ci.org/latest/mailer.hpi

# workflow plugin
RUN curl -L -o $JENKINS_REF/plugins/workflow-job.hpi http://updates.jenkins-ci.org/latest/workflow-job.hpi
RUN curl -L -o $JENKINS_REF/plugins/workflow-api.hpi http://updates.jenkins-ci.org/latest/workflow-api.hpi
RUN curl -L -o $JENKINS_REF/plugins/workflow-cps.hpi http://updates.jenkins-ci.org/latest/workflow-cps.hpi
RUN curl -L -o $JENKINS_REF/plugins/workflow-durable-task-step.hpi http://updates.jenkins-ci.org/latest/workflow-durable-task-step.hpi
RUN curl -L -o $JENKINS_REF/plugins/workflow-basic-steps.hpi http://updates.jenkins-ci.org/latest/workflow-basic-steps.hpi
RUN curl -L -o $JENKINS_REF/plugins/workflow-cps-global-lib.hpi http://updates.jenkins-ci.org/latest/workflow-cps-global-lib.hpi
RUN curl -L -o $JENKINS_REF/plugins/workflow-scm-step.hpi http://updates.jenkins-ci.org/latest/workflow-scm-step.hpi
RUN curl -L -o $JENKINS_REF/plugins/workflow-support.hpi http://updates.jenkins-ci.org/latest/workflow-support.hpi
RUN curl -L -o $JENKINS_REF/plugins/workflow-step-api.hpi http://updates.jenkins-ci.org/latest/workflow-step-api.hpi
RUN curl -L -o $JENKINS_REF/plugins/workflow-aggregator.hpi http://updates.jenkins-ci.org/latest/workflow-aggregator.hpi


# Set permissions
RUN mkdir "$JENKINS_HOME" && \
    chown -R jenkins:jenkins "$JENKINS_HOME" /usr/share/jenkins/ref /maven-settings.xml && \
    chmod +x /bin/tini /usr/local/bin/jenkins.sh

USER jenkins

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
