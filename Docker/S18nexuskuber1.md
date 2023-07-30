
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



practice - create new repo:

cat /etc/apt/sources.list


apt(proxy)--> myrepojammy (name)  --> distro: apt setting: jammy --> location- if we use proxy then give address ( http://archive.ubuntu.com/ubuntu) ----> create repo. 

then get url:

http://192.168.44.136:8081/repository/myrepojammy/

sed -i 's|firstword|secondword |g'  /etc/apt/source.list

sed -i 's|http://ir.archive.ubuntu.com/ubuntu|http://192.168.44.136:8081/repository/myrepojammy|g' /etc/apt/sources.list    - all address in this file replaced with nexus address. just hit this command in all servers and finish. all serever connect to nexus to use apt repo. in common we use ansible to set this command in all servers and clients. 



# kubernetese - k8s

















