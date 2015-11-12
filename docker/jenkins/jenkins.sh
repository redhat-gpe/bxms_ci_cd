#! /bin/bash

set -e

COPY_REFERENCE_FILE_LOG=$JENKINS_HOME/copy_reference_file.log

# Copy files from /usr/share/jenkins/ref into /var/jenkins_home
# So the initial JENKINS-HOME is set with expected content. 
# Don't override, as this is just a reference setup, and use from UI 
# can then change this, upgrade plugins, etc.
copy_reference_file() {
	f=${1%/} 
	echo "$f" >> $COPY_REFERENCE_FILE_LOG
    rel=${f:23}
    dir=$(dirname ${f})
    echo " $f -> $rel" >> $COPY_REFERENCE_FILE_LOG
	if [[ ! -e /opt/jenkins/${rel} ]] 
	then
		echo "copy $rel to JENKINS_HOME" >> $COPY_REFERENCE_FILE_LOG
		mkdir -p /opt/jenkins/${dir:23}
		cp -r /usr/share/jenkins/ref/${rel} /opt/jenkins/${rel};
		# pin plugins on initial copy
		[[ ${rel} == plugins/*.jpi ]] && touch /opt/jenkins/${rel}.pinned
	fi; 
}
export -f copy_reference_file
echo "--- Copying files at $(date)" >> $COPY_REFERENCE_FILE_LOG
find /usr/share/jenkins/ref/ -type f -exec bash -c "copy_reference_file '{}'" \;

# setup nexus
NEXUS_IP=${NEXUS_PORT_8080_TCP_ADDR}
NEXUS_URL=$NEXUS_IP:8080
# configuration
if [ ! -d "$JENKINS_HOME/.m2" ]; then
  mkdir -p $JENKINS_HOME/.m2
  cp -a /maven-settings.xml $JENKINS_HOME/.m2/settings.xml
fi
sed -r -i "s'[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:[0-9]{1,5}'$NEXUS_URL'g" $JENKINS_HOME/.m2/settings.xml

# if `docker run` first argument start with `--` the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
   exec java $JAVA_OPTS -jar /usr/share/jenkins/jenkins.war $JENKINS_OPTS "$@"
fi

# As argument is not jenkins, assume user want to run his own process, for sample a `bash` shell to explore this image
exec "$@"

