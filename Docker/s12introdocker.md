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



