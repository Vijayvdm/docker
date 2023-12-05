FROM jenkins/jenkins:2.154-alpine

USER root

# Update CA certificates
RUN apk --update add ca-certificates

# Install Docker
RUN apk -U add docker

# Setup Jenkins
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
    && addgroup -g 50 staff \
    && adduser jenkins -G staff

USER jenkins

# Your existing Dockerfile instructions...

# Change EXPORT to ENV
ENV CURL_OPTS="--insecure"
RUN /usr/local/bin/install-plugins.sh blueocean build-environment cloudbees-folder config-file-provider credentials-binding credentials docker-plugin docker-slaves envinject git greenballs groovy http_request job-dsl jobConfigHistory naginator pam-auth pipeline-utility-steps nexus-artifact-uploader slack workflow-aggregator sonar subversion

COPY resources/basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy
COPY resources/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
USER root

