FROM jenkins/jenkins:2.154-alpine

USER root

RUN apk -U add docker

# Add the "jenkins" user to the "staff" group
RUN addgroup -g 50 staff \
    && adduser -D -u 1002 -G staff jenkins1

# Allow "jenkins" to run sudo without a password
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

# Your existing Dockerfile instructions...

# Change EXPORT to ENV
ENV CURL_OPTS="--insecure"
RUN /usr/local/bin/install-plugins.sh blueocean build-environment cloudbees-folder config-file-provider credentials-binding credentials docker-plugin docker-slaves envinject git greenballs groovy http_request job-dsl jobConfigHistory naginator pam-auth pipeline-utility-steps nexus-artifact-uploader slack workflow-aggregator sonar subversion

COPY resources/basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy
COPY resources/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
USER root
