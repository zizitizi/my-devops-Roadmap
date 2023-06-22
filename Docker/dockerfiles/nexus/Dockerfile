FROM openjdk:8-jdk

RUN apt-get update && apt-get install -y wget

RUN mkdir /app && cd /app

RUN wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz


RUN tar -xvf nexus.tar.gz

RUN mv nexus-3* nexus

# Set necessary environment variables

ENV NEXUS_HOME=/nexus


ENV NEXUS_DATA=/nexus-data

# Expose the necessary ports

EXPOSE 8081

# Set the working directory

WORKDIR $NEXUS_HOME

# Start the Nexus service

CMD ./bin/nexus run```

##Replace `3.x.x` in `NEXUS_HOME` with the correct Nexus version you downloaded.

##Once you have the Dockerfile ready, you can build the Docker image using the `docker build` command and then run it using `docker run` to start the Nexus container.
