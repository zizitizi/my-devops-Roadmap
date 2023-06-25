FROM openjdk:19-jdk-alpine3.16

MAINTAINER zein_tiz@yahoo.com

RUN mkdir /app && cd /app \
    && wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz \
    && tar -xvf nexus.tar.gz \
    && mv nexus-3* nexus

# Set necessary environment variables

ENV NEXUS_HOME=/nexus


ENV NEXUS_DATA=/nexus-data

# Expose the necessary ports

EXPOSE 8081

# Set the working directory

WORKDIR $NEXUS_HOME

# Start the Nexus service

CMD ./bin/nexus run```


##Once you have the Dockerfile ready, you can build the Docker image using the `docker build` command and then run it using `docker run` to start the Nexus container.

