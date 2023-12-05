FROM jenkins/jenkins:2.154-alpine

USER root

# Install necessary packages
RUN apk --update add ca-certificates curl sudo docker openrc \
    && rm -rf /var/cache/apk/*

# Remove the existing 'jenkins' user and group if they exist
RUN if getent passwd jenkins > /dev/null ; then userdel jenkins; fi \
    && if getent group jenkins > /dev/null ; then delgroup jenkins; fi

# Setup Jenkins
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
    && addgroup -g 50 staff \
    && adduser jenkins

USER jenkins

# Environment variable to disable SSL verification
ENV CURL_OPTS="--insecure"

# Run Jenkins plugin installation script with --insecure option
RUN /usr/local/bin/install-plugins.sh --insecure \
    blueocean build-environment cloudbees-folder config-file-provider \
    credentials-binding credentials docker-plugin docker-slaves envinject \
    git greenballs groovy http_request job-dsl jobConfigHistory naginator \
    pam-auth pipeline-utility-steps nexus-artifact-uploader slack \
    workflow-aggregator sonar subversion

COPY resources/basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy
COPY resources/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml

# Disable Jenkins setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
