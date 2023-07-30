
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



# kubernetese - k8s

















