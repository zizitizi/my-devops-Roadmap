
# insecure registery

local registery - run container registery- simple with out ssl - port 5000 - cli - without gui - light wight - 


to run:

 docker run -dit --name registry -p 5000:5000 registry:latest

 docker ps -a

to see repo:

curl 127.0.0.1:5000/v2/_catalog

to push an image to it first tag your image then push it to repo:

docker image tag nginx:latest 127.0.0.1:5000/nginx:latest

docker image ls

docker push 127.0.0.1:5000/nginx
 
curl 127.0.0.1:5000/v2/_catalog

 docker image tag redis:alpine 127.0.0.1:5000/redis:alpine


docker image ls

curl 127.0.0.1:5000/v2/_catalog
 

now just 127.0.0.1 ip can push to registry but for announce it to other server with default ip address we should change the default regidtry to it then :

for this purpose in every server do: (default  registry for docker host)

sudo vi /etc/docker/daemon.json


{
"insecure-registries" : ["192.1668.44.136:5000"]
}
 
note: if you use ssl or https just write: 

"secure-registries" : ["192.1668.44.136:5000"]


systemctl daemon-reload

systemctl restart docker



docker image tag nginx:latest 192.168.44.136:5000/nginx:latest

hint:
also for use docker.ir add this line to daemon.jason too.

{
        "insecure-registries" : ["192.168.44.136:5000"],
        
        "registry-mirrors": ["https://registry.docker.ir"]
}


### volume to persist image

 docker exec -it registry sh

  cd /var/lib/registry/docker/registry/v2/repositories/

  


bind mount this path to save image:

/home/zizi/repodocker/:/var/lib/registry/docker/registry/v2/

to remove one image do :

rm -rf nginx/

also garbage collect to remove all layer of that image . use it inside that container:

registry garbage-collect /etc/docker/registry/config.yml


### to see that image related  tag:

curl -sS 192.168.44.136:5000/v2/redis/tags/list


repo list:

 curl -sS 192.168.44.136:5000/v2/_catalog


#### practice:

docker run -dit --name registry -p 5000:5000 -v /home/zizi/repodocker/:/var/lib/registry/docker/registry/v2/  registry:latest

curl -sS 192.168.44.136:5000/v2/_catalog

docker push 192.168.44.136:5000/nginx

curl -sS 192.168.44.136:5000/v2/_catalog

cd ~/repodocker/repositories/nginx




### ssl

80  - http

443  - https  -secure- add certificate (when buy domain. we can buy ssl - (ex.: cloudflare) when we buy international ssl from CA its signed and valid. when we use our self signed certificate and use onpromises ca server its invalid. CA server is certificate authority server. when we use ssl in connection between server and client . the transmitted data is encrypted. when we have mail server - web server - we use ssl with install it on client or join them to domain to use domain published cert. in networks linux we use to nfs to share bought ssl with all member (for ex.: web1 ssl - web2 ssl-..)



also we use ssl on orchestration to encrypte data between masters node and workers. generated token is kind of ssl. for ex.: github -gitlab - jenkins - puppet - ....

but ansible connection between contoller and rempte machins is secured with ssh. 



ssh  - ip port user


ssl  - token




# nexus

local registery 

we can install ssl to secure pull and push to it.

ssl -https == secure registery


with out ssl == insecure registery



apt - yum - maven - dll - docker repo ,...

minimum need 2 -3 gig ram. secure- gui - to install nexus in docker :

first make directory

 mkdir ./host-nexus-data

give it permission 200 (nexus user) :

sudo chown 200:200 host-nexus-data/


vi docker-compose.yml

    
    version: "3.9"
    services:
      nexus:
        image: sonatype/nexus3
        ports:
          - 8081:8081
          - 8082:8082
        volumes:
          - ./host-nexus-data:/nexus-data
   
    



docker compose up

docker ps -a

docker logs -f zizi-nexus-1

wait till gor message 

-------------------------------------------------
zizi-nexus-1  |
zizi-nexus-1  | Started Sonatype Nexus OSS 3.58.1-02
zizi-nexus-1  |
zizi-nexus-1  | -------------------------------------------------


then go to browser:

192.168.44.136:8081




use 8081 port for apt and yum repo.
use 8082 port for pull and push to docker repo. if u have another repo then use added port again. every repo have one port with multiple image. but per repo per port - 



first of all you should login for first and one time:

go to sign in :

/nexus-data/admin.password on the server.

cd host-nexus-data/

 cat admin.password

admin
 
fae43943-0b4a-4197-838f-7a01e1d3c146

go to wizard give it new pass and conf. next enable ananymose access. complete setup.

Enable anonymous access means that by default, users can search, browse and download components from repositories without credentials. Please consider the security implications for your organization.

Disable anonymous access should be chosen with care, as it will require credentials for all users and/or build tools.


Enable anonymous access for download ans pull anonymosly by other server is recomand for now.


we have 2 place in nexus:


brows is for content and repo see and brows sections . 

setting is for config managment .  we can create new repo in repositories in this section. 


in create repo section we have 3 type:

*****hosted*****  - local private repo that we can pull and push to it. no need for internet. 

***proxy***  - nexus repo is proxy to other external repo for ex.: docker hub - or ubuntu.com - you can push and pull to it but it need to internet connection. its transparent. we can place it in private network that just nexus server access the internet to be proxy repo. 

***group***  - it can be proxy repo that proxied to multiple site or different external repo. for ex.: pypi. 

#### blob store

is storage for nexus that where to save its data. Blob storage is a type of cloud storage for unstructured data. A "blob," which is short for Binary Large Object, is a mass of data in binary form that does not necessarily conform to any file format. Blob storage keeps these masses of data in non-hierarchical storage areas called data lakes.

it used in cloud specially in azure cloud. 

#### Proprietary Repositories

is oposite of open source. its confidentional repo. just drag and drop repo to Proprietary Hosted Repositories. 

#### security 

privillage -- can make new acl and policy  - role: admin high privilaged and ananymose least privilage just can pull from repo . user and ananymose also for access management.

ldap is linux active directory - centralise user with ldap (lpic2) - configuring ldap server (active directory server in windows) - give the ldap or ad server address to make connection. then no need to user and role to be defined in nexus. 

realm - is scope that define user to athunticate for default nexus do realm for local authenticate and authorization we can add docker bearer realm and save it.

you can buy and put here ssl certificate to have https connection. then reset docker compose to be applied. 

#### email server

we can configure nexus user mail in our email serve here for alert. 


#### apt repo

practice - create new repo:

cat /etc/apt/sources.list


apt(proxy)--> myrepojammy (name)  --> distro: apt setting: jammy --> location- if we use proxy then give address ( http://archive.ubuntu.com/ubuntu) ----> create repo. 

then get url:

http://192.168.44.136:8081/repository/myrepojammy/

sed -i 's|firstword|secondword |g'  /etc/apt/source.list

  sed -i 's|http://ir.archive.ubuntu.com/ubuntu|http://192.168.44.136:8081/repository/myrepojammy|g' /etc/apt/sources.list

sed -i 's|http://ir.archive.ubuntu.com/ubuntu|http://192.168.44.136:8081/repository/myrepojammy|g' /etc/apt/sources.list    - all address in this file replaced with nexus address. just hit this command in all servers and finish. all serever connect to nexus to use apt repo. in common we use ansible to set this command in all servers and clients. 

#### docker repo

docker(proxy) --->repodocker--->tick http: write 8082 for port . next repo will be 8083. ---> Allow anonymous docker pull ( Docker Bearer Token Realm required ) ticked ----> Allow clients to use the V1 API to interact with this repository(allow older docker to connect) ticked---> remote storage: https://registry-1.docker.io (if it has ssl tick :Use certificates stored in the Nexus Repository truststore to connect to external systems) or other gitlab docker repository or github address. ---> here we use docker hub then select: Use Docker Hub -----> create repository. 


now get its url address:

http://192.168.44.136:8081/repository/repodocker/

now go to :

sudo vi /etc/docker/daemon.json


{
"insecure-registries" : ["192.168.44.136:8082"]
}

 
systemctl daemon-reload

systemctl restart docker


now for login in servers:

in place of docker login write:

docker login 192.168.44.136:8082

 admin
 
 zizi

it did not go to docker hub it login to nexus server. 


commonly used port is 5000 in repos. 

**for push you should make new hosted docker repo (repo1). in proxy mode it cant push couse it want pushed image to docker hub.**


docker image tag nginx:latest 192.168.44.136:8082/rep1/nginx:latest

docker image tag nginx:latest 192.168.44.136:8082/repo1:nginx


docker push 192.168.44.136:8082/nginx:latest


harbor repo is new repo manager and used for k8s
 practice - install harbor


 note - java repo is maven hosted - npm for java script repo.

 


# kubernetese - k8s

rank #1 in orchestrator for container runtime that is opensource with many derivatives. swarm is #2 and apache mesos is rank #3. 
container low level runtime is runc , containerd. container high level runtime is docker, RKT, CRIO, LXC , podman....

this platform used to maintaining and deploying group of containers.

cncf.io maintainer site for kuber. same as linux fundation. its for standards confirmation. kuber write in go/golang. 

microsoft costumize kubernetese for azure that give it name , AKS or azure kubernetese service.
amazon also publish EKS or elastic kubernetese service.
google also publish GKE or Google kubernetese engine.

ibm and redhat (openshift) also costumize kuber. 

kuber change in version is very much need to read anf reserach more. 
k8s - have 7 major feature: storage orchestration - secret and config managment - automatic bin packing - self healing- automatic roll out and rollback - service discovery and load balancing.

kubernetese master calls control plane or cp node. worker node called node that older called miniun. 

main module in cp node is:

kube api server: core of cp node that connect with scheduler and controller. cli tools that send commands to kube api server is kubectl. some version has gui added to cli. 

kube scheduler - main task is node selection. select worker that is less load . send to controller to run container on that node. 

kube controller-manager  - sends commands from api server to workers - just negotiate with worker. and monitoring kubelet.

kube etcd or cluster store   - save aapreciate config that recive from api server. config storage - kube config is for saving metadata and config for all of cluster. if we install kube ctl in our laptop and able to see master node . then with kube config file we can connect to all cluster and send commands to api serve and do every thing. then maintaining and backup and securing etcd is very important.


kube controller sends request to kublet in worker . kuelet is worker daemon in node that connect with container runtime like docker and gives command from kube controller and senf it to continer runtime and monitoring reporting to controller manager. 

kube proxy - is proxy server in every node in k8s. 

k8s make virtual ip in cluster like : 10.244.0.1/24 . 

note : kubelet and kubeproxy is on every node master and worker. all node negotiate with kubeproxy with each other. ssl connection and for keep security. port 6443. master node has ca serve that issued cert token for 24 hours.  proxy acts as proxy for source reverse proxy for destination kubelet and node. 

k8s 1.23 supports: docker - crio - lxc
k8s 1.24 and later: crio - mirantis (cri-dockerd) - containerd (without high level runtime). nowday every one recommand using containerd. ******


#### pod
beams pod. one pod may include more that one container . but its best practice is one main gontainer is in pod and related side care conntainer (nginx - prometeous-..)

worker  ----> container runtime(docker) (kubelet) (ip:port) 30080 (ports must be over 30000) ----> pod (kubectl) (ip:port) ----> ctr (container) (ip :port)  


container: smallest unit in docker 

pod: smallest unit in k8s


k8s is not container runtime and need minimum containerd to run container.















