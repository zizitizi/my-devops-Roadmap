
practice 1- how to stablish ssh connection between 2 container ?

to start ssh we need systemd in container - then we build this container image we should consider ssh in image to install it. by default container use host systemd.
install d
they should ping to gether -


practice 2- install docker in docker - dind

we need systemd in container - so we have specail image named dind or docker in docker image for solution. this is special container. we cant do this on every container.
dind have docker in it (nested) - it used in pipline ci/cd- for ex.: in our company we have one test server we have git with 50 project . then we clone every project (git repo) in one container (dind) and push and pull it . for every commit we make new docker (docker in docker) - and for cleaning at the end of mounth we just remove dind's . nowdays its very usefull solution.

practice 3 - in whitch directory of host we can change guest (container) configuration? 

/var/lib/docker - in container folder . here we can do ls -l or do cat or change it to specifed and new config. 
in image/overlay2/imagedb/sh256/ - our image last layer is heres as name of image
image/overlay2/layerdb/sh256/  - images below layers is here 

users that use docker should be member of docker: 
usermod -aG docker username

docker image prune - remove unknown image

docker container prune - remove exited unused container

docker run nginx - after run we can not curl localhost but we can curl 172.17.0.3   address directly

in docker hub for pull use official image or many download image. in image pull select best. or best is downad and install from that app software site directly.

for make change resolv.conf permanetly . delete it and make it manually again. so its softlink to netplan wil deleted and not to reset again. for another solution maske network manager with command: systemctl mask systemd-resolved.service 
nameserver 8.8.8.8

change /etc/netplan in static ip worked. when we have dhcp it didnt work correctly


# Docker back up

export and import : container>export>.tar>scp>import (with specified command) -image layer backup to commplete it run container layer by hand

docker export containername>/path/imagename.tar

docker import -m "commit message" imagename.tar image_name:v1.0

docker images image_name - to see result 


see that command in docker inspect | Cmd


save and load : image 




# docker image

image is excutable package that includes everything needed to run an application (code - runtime library - environmental variable - config files) 

image can be exist without container but whereas container need to run an image for exist - a container is a runtime instance of an image (can be multiple container form an image)- we can not delet image that have running container 


we can pull an image from repository or buld it from docker file.

we can tag image from git tag and also it relative to k8s-


docker info  - location and all information about images

### image layer

is a files that made from excutable command in docker file

bottom or first layer in image is base os layer - last layer or container layer is cmd layer

image layer - R/O layer - run
container layer - R/W layer - cmd line - save it - run and cmd



# docker file

is important task for devops- Dockerfile with this name made docker to build image



***** Instructions	Description

FROM	- Defines base image. It must be first instruction in Dockerfile. mandatory
LABEL	- It's a description about anything needs to define about the image.


ADD	- Copies a file into the image and supports tar & remote URL.*****
COPY	- Copy files into the image, preferred over ADD.*****


VOLUME	-Creates a mount point when the container will run.


ENTRYPOINT	The executable runs when container will run. run and install in container r/w layer********

EXPOSE	Documents the ports that should be published.

CMD	- Just one CMD in a Dockerfile. CMD ["param1","param2"]   or   CMD command param1 param2  -  run and install in container r/w layer********

ENV	- Define environmental variables in the container.
MAINTAINER	- It’s used to document the author of the Dockerfile (typically an email address)
ONBUILD	- Only used when the image is used to build other images. It will define commands to run "on build“.


RUN	- Runs a new command in a new layer. run and install in r/o layer image layer ********* 

WORKDIR -	Defines the working directory of the container. when -it /bin/bash to container first location would be here.









































