# intro

devops pipeline:
plan-code-build-test-integrate(release)-deploy-operate


we use git to clone code - and ask dev lead instuction of build and process and compile code . from build to deploy we integrate commonly with containerization today (older virtualization) that nowdays docker help to containarize.

## containerize
packages ( application + process) that encapsulate software code + dependencies to run consistently on every environment (anywhere). single package

sourcecode + build + process + instruction + dependencies = excuteable to run


container run software like: 

linux containers - LXC

docker -  golang in linux writed - then best integrated with linux

rkt

CRI-O

podman

containerd


## virtulize

need hypervisor and isolate vm and resource - have 2 type:
type 1 bare metal hypervisor is lighted os installed on hardware - for ex.:  ESXI - zen -citrix -  hyper-v
type 2 hosted - need os install on hypervisor have host os and gest os - for ex.: vmware - kvm- vbox


resource is:
cpu (compute)
memory ( compute)
storage (volume)
network 

####### in virtualization in infrastructure layer level - may be  4 -10 geust - complete os and resource - resource is dedicated.
####### in containerization in os layer level - and need container run-time(engine) to share host kernel and library with guest. ex.: docker - may be 100000 guest - have some binary and library and rest of resource from host os. we can you multiple container run-time(engine) with one containter( no difference couse all of them is same standard and protocol).  has no limit of used of resource. then may couse over load server. we should configure limit for resource and its not dedicated.

best practice is used od virtualize and containerize hybrid and combination.


docker with .net core can cantainer windows software.

windows server - microsoft azure
linux - gitlab server


container runtime have 2 type:

high level:
docker- CRI-O  - rkt - podman -lxc -

low level:
containerd - runc

we can build image with docker , run it on other server with other runtime . becouse OCI standard is the same.

nowdays: orchasterator is for containers ex.: kubernetiz - dockerswarm - apache mesos -



note:
kubernetiz is integrate with docker - CRI-O - LXC - containerd.  after that
this list change to :
kubernetiz - mirantis(cri-dockerd) - docker - containerd- after it
but now kubernetiz 1.24 no need to docker . kubernetiz is working for manage and runtime(inplace of docker) - containerd
we use nowdays kubernetiz and containerd and machin.


nfv/sdn architecture used in cloud / devops/ virtulization/container


in sdn we have control plane to manage infrastructure with app 
IAC( ansible , terraform ) 
k8s(control plane layer)-kubectl-->app , 
docker (runtime) container-->app, 
moitoring ( script - server ) , 
cloud (openstack - automation)


nfv - replacement of network machine with virtual (virtual convertion pool of resource) - lvm -ceph - openswitch

#### docker engine

major component is:
1- client docker cli
2- rest api to commniucate with daemon
3- a server (docker daemon ) 

2 type of commands have with (nfv/sdn arcitecture):
1- in application layer (container - image)
2- in infra layer ( network - volume)



a movable image that is like a snapshot of virtual machine server (for ex.: ubuntu image)
container is like vm machine.
in docker hub we can find many image for running container. image is readonly
when an image run it called container
build an image is containerize app by devops engineer
to save data in host form container we shulod use docker volume . kubernetize help this process

we push image to docker registery that include our custom repositories to save and publish them in it


note: gitlab is: source code, gitrepo ci/cd and local registery. github is too.
git lab:
src-->CI/CD-->clone-->docker build-->image-->push again in gitlab as container registery-->deploy and run container


when we didnt acces to net we can use below options:
1- our laptop to sftp to server. pull from docker hub .tar file. and sftp it to specified server
2- local registery: jfrog/nexus/gitlab as local registery/-- after gitlab nexus is most common becouse both apt repo and docker registery could be run on it.
3- if our register in none docker hub , we sholud go to docker config anf tell him  to pull and push image to specified registery

docker client: bulid - pull - run

note:
docker run = pull + run

local docker registery: nexus - jfrog - gitlab

### docker hub 

is a online and default docker registery. we could have many public repo and one private repo in free plan of it. 

### docker installation on ubuntu
docker-ee is enterprise edtion and it is not free
docker-ce - is a complete free version of docker
docker.io is default exit in ubunutu but its small version and not include some feature

we use docker-ce in devops field. so to install it follow instaruction:


first uninstall docker dist from:

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

Update the apt package index and install packages to allow apt to use a repository over HTTPS:

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg


Add Docker’s official GPG key:
gpg is for verify repository

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg



Use the following command to set up the repository:

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  
add docker.list to cd /etc/apt/sources.list.d/  


sudo apt update


sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


docker --version


sudo docker run hello-world



#### ssh tunnel

ssh-keygen
ssh-copy-id -p 2022 sshuser@ipvpsserver 

for use ssh port ip should not be 22: 0/0 means all ip and all subnet- no latancy for increase speed - and for background

sshuttle --dns -r sshuser@ipvpsserver:2022 0/0 -x ipvpsserver --no-latancy-control & 

to check connection 
curl ipinfo.oi




to practice docker go to site docker play ground
https://labs.play-with-docker.com/



#### docker command

docker + container (default- could be empty) or image or volume or network + related to parent command

docker run hello-world == docker container run hello-world


### image

image name:tagname - default is lastest


docker run gitlab-ce:latest==docker run gitlab-ce
docker run gitlab-ce:v15.0


note:
in docker hub with out account for every 1 hour we can pull just 6 image
with free account evey 6 hour we can pull 100 image
with enterprise account no limit


to login do :
docker login


to add docker user to docker group (that biult-in) do this:
id - if not member of docker group

sudo usermod -aG docker username

after do logout and login
logout
su - username


not we can run docker without sudo

docker run hello-world

docker search ubuntu

docker run = docker create + docker start

container is varying in 2 type: 
1- works like daemon works. for ex.: nginx
2- do task and exit. for ex: hello-world

docker ps  - list of up and running container -a see all container even exited
 container id is unique - name is randomly - exit (0) means finished sucesfully
 

docker rm -f - remove container

docker stop is not remove


to see all data of docker do:
sudo -i
 
cd /var/lib/docker

docker run centos

alpine is very light version ubuntu with out bash . just include sh

docker run enginx

docker run -d nginx

docker logs containername or id  - show container lof with -f follow it

docker stop containername

docker start containername

docker run -dit centos  - dit is important option - detach interactive tty

docker run -dit --name nginx1 nginx:latest  - - up and run the container with specified name 

docker run -dit --name ubuntu1 ubuntu:22.04
 
docker rm -f containername  - remove container without stop

docker exec -it containername <command>

docker exec -it ubuntu1 cat /etc/resolv.conf  - to run and execute container 

docker exec -it ubuntu1 cat /etc/hostname  - return hostname by default its container id

docker exec -it ubuntu1 /bin/bash  - attach to specified container to run command in it - to exit type exit or ctl+d

docker exec -it nginx1 bash - curl localhost to see default website

cd /usr/share/nginx/html  - this folder is default website of nginx copy your html code to replace it


 
 





##### note

nginx has base image in it like contos

even if we found container ip we cant ssh to it becouse bydefault all port of it closed. but service container like nginx default port 80 is opend.
 apt install iproute2 - install ip package
you can ping container ip


 










