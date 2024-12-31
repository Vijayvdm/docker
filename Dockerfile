FROM tomcat:latest

LABEL maintainer="Nidhi Gupta"

COPY ./target/LoginWebApp-1.war /usr/local/tomcat/webapps/

EXPOSE 8081

CMD ["catalina.sh", "run"]
