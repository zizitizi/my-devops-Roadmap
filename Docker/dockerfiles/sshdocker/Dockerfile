FROM alpine:3.14

MAINTAINER zein_tiz@yahoo.com

#FROM ubuntu:22.04 

RUN apk update
&& apk add openssh-server
&& apk add vim -y
&& rm -rf /var/lib/apt/lists/*

EXPOSE 22

CMD /bin/bash
