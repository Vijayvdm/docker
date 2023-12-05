FROM jenkins/jenkins:2.154-alpine

USER root

# Install necessary packagestt2
RUN apk --update add ca-certificates curl sudo docker openrc \
    && rm -rf /var/cache/apk/*

# Remove the existing 'jenkins' user and group if they exist
RUN if getent passwd jenkins > /dev/null ; then deluser jenkins; fi \
    && if getent group jenkins > /dev/null ; then delgroup jenkins; fi

# Setup Jenkins with a passwordt1245
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
    && addgroup -g 50 staff \
    && adduser -D -u 1000 -G staff -s /bin/sh -h /var/jenkins_home jenkins \
    && echo "jenkins:jenkins" | chpasswd
    
USER jenkins

# Environment variable to disable SSL verification
ENV CURL_OPTS="-k/--insecure"

# Run Jenkins plugin installation script with updated CA certificates
USER root
RUN apk --update add --no-cache openssl \
    && update-ca-certificates \
    && /usr/local/bin/install-plugins.sh blueocean build-environment cloudbees-folder config-file-provider credentials-binding credentials docker-plugin docker-slaves envinject git greenballs groovy http_request job-dsl jobConfigHistory naginator pam-auth pipeline-utility-steps nexus-artifact-uploader slack workflow-aggregator sonar subversion \
    && apk del openssl

USER jenkins

COPY resources/basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy
COPY resources/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml

# Disable Jenkins setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
