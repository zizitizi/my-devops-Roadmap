#This Dockerfile installs GitLab CE on an Ubuntu 20.04 base image,

#FROM ubuntu:20.04
FROM alpine:3.14
MAINTAINER zein_tiz@yahoo.com

#Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
#Update the package list and install dependencies
RUN apk update \
&& apk add -y --no-install-recommends
        ca-certificates
        curl
        openssh-server
        tzdata
        perl
    && apk clean
    && rm -rf /var/lib/apt/lists/*

#Install GitLab CE
RUN curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | bash \
&& apk add -y --no-install-recommends gitlab-ce

#Configure GitLab
RUN echo "external_url 'http://localhost'" >> /etc/gitlab/gitlab.rb

#Expose the necessary ports
EXPOSE 22 80 443
#Start GitLab service
CMD (gitlab-ctl reconfigure && gitlab-ctl tail) & wait```
#Step 4: Save and close the Dockerfile.
#Step 5: Build the Docker image using the following command:
#docker build -t gitlab-ce .
#Step 6: Run the GitLab CE container using the following command:

#docker run -d -p 80:80 -p 443:443 -p 22:22 --name gitlab gitlab-ce```

