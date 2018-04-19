echo -en "****** BxMS CI / CD project ******** \n\n"

NEXUS_VERSION=2.11.4-01
BPMS_VERSION=6.2.0.CR-redhat-1
EAP_VERSION=6.4.4
JENKINS_VERSION=1.625.1

PROJECT_RESOURCE_DIR=$HOME/resources

substitute_env_var() {
    # Env variable substitions
    sed -i "s/@NEXUS_VERSION@/$NEXUS_VERSION/g" nexus/env.sh
    sed -i "s/@BPMS_VERSION@/$BPMS_VERSION/g" bpms-design/env.sh
    sed -i "s/@EAP_VERSION@/$EAP_VERSION/g" bpms-design/env.sh
    sed -i "s/@BPMS_VERSION@/$BPMS_VERSION/g" bpms-runtime/env.sh
    sed -i "s/@EAP_VERSION@/$EAP_VERSION/g" bpms-runtime/env.sh
    sed -i "s/@JENKINS_VERSION@/$JENKINS_VERSION/g" jenkins/Dockerfile
}

copy_and_download_artifacts() {
    # copy BPM install artifacts to bpms-design sub-project
    echo -en "\nCopying BPM and EAP artifacts\n"
    cp $PROJECT_RESOURCE_DIR/jboss-eap-* bpms-design/resources
    cp $PROJECT_RESOURCE_DIR/jboss-bpmsuite* bpms-design/resources
    
    # copy BPM install artifacts to bpms-runtime sub-project
    cp $PROJECT_RESOURCE_DIR/jboss-eap-* bpms-runtime/resources
    cp $PROJECT_RESOURCE_DIR/jboss-bpmsuite* bpms-runtime/resources
    
    # copy Nexus install zip to nexus sub-project
    cp $PROJECT_RESOURCE_DIR/nexus-* nexus/resources
    
    # Download Jenkins
    JENKINS_INSTALL_ZIP_PATH=jenkins/resources/jenkins-$JENKINS_VERSION.war
    if [ -f $JENKINS_INSTALL_ZIP_PATH ];
    then
        echo -en "$JENKINS_INSTALL_ZIP_PATH found. Will not download\n"
    else
    	wget http://mirrors.jenkins-ci.org/war/$JENKINS_VERSION/jenkins.war -O $JENKINS_INSTALL_ZIP_PATH
    fi

    # Ensure and copy this host user's private key such that (for demo simplification purposes) the key is shared with jenkins to authenticate into gitlab
    if [ -f $HOME/.ssh/id_jenkins ];
    then
        cp $HOME/.ssh/id_jenkins jenkins/config/ssh/id_rsa
    else
        echo -en "For purposes of auto-configuring jenkins in this demo, must have a private key at: $HOME/.ssh/id_jenkins.  Please review the documentation for this lab for more details\n";
        exit 1;
    fi
    
    
    # Download tini-static
    TINI_STATIC_PATH=jenkins/resources/tini-static
    if [ -f $TINI_STATIC_PATH ];
    then
        echo -en "$TINI_STATIC_PATH found. Will not download\n"
    else
    	wget https://github.com/krallin/tini/releases/download/v0.5.0/tini-static -O $TINI_STATIC_PATH
    fi

}

build_project() {
    # Build centos7-base
    echo -en "\n\n ***** Now building centos7-base *****\n"
    docker build --rm -t centos7/base centos7-base

    # Build centos7-java
    echo -en "\n\n ***** Now building centos7-java *****\n"
    docker build --rm -t centos7/java centos7-java

    # Build bxmscicd-storage
    echo -en "\n\n ***** Now building bxmscicd-storage *****\n"
    docker build --rm -t bxmscicd-storage storage
    

    # Build BxMS CI / CD images
    echo -en "\n\n ***** Now building bxms ci/cd images *****\n"
    docker-compose -p bpmscd build
}

clean() {
    echo -en "\nDelete any stopped containers\n"
    docker rm $(docker ps -a -q)
}

substitute_env_var
#copy_and_download_artifacts
#build_project
#clean
