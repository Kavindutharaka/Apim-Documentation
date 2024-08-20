# Use a Maven image to build the WAR file
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project files to the container
COPY pom.xml .

COPY io.asgardeo.tomcat.oidc.agent ./io.asgardeo.tomcat.oidc.agent
COPY io.asgardeo.tomcat.oidc.sample ./io.asgardeo.tomcat.oidc.sample

# Build the WAR file
RUN mvn clean install -DskipTests

FROM tomcat:9.0.91-jdk17


RUN groupadd --gid 10015 choreo || true && \
    useradd --uid 10015 --gid choreo --no-create-home --shell /bin/sh choreouser || true

USER root

RUN apt-get update
RUN apt-get install -y unzip

RUN chown -R 10015:choreo /usr/local/tomcat

USER 10015

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# COPY io.asgardeo.tomcat.oidc.sample/target/migration.war $CATALINA_HOME/webapps/migration.war
COPY --from=build /app/io.asgardeo.tomcat.oidc.sample/target/migration.war $CATALINA_HOME/webapps/migration.war

RUN ls -al $CATALINA_HOME/webapps/
# RUN file oidc-sample-app.war
RUN unzip $CATALINA_HOME/webapps/migration.war -d $CATALINA_HOME/webapps/migration && rm $CATALINA_HOME/webapps/migration.war

RUN ls -al $CATALINA_HOME/webapps/migration

COPY oidc-sample-app.properties $CATALINA_HOME/webapps/migration/WEB-INF/classes/

COPY logging.properties $CATALINA_HOME/conf/logging.properties

EXPOSE 8080

CMD ["catalina.sh", "run"]