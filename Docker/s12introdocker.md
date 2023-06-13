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

### docker installation
docker-ee is enterprise edtion and it is not free
docker-ce - is a complete free version of docker
docker.io is default exit in ubunutu but its small version and not include some feature

we use docker-ce in devops field. so to install it follow instaruction:









