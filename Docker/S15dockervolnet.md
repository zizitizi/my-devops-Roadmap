
****practice****  :
container --> save -->.tar --> load --input --> image -->run

to print runiing container name:

docker ps --format {{.Names}}


docker ps -a | awk '(NR>1)'  - display container info without headline

docker ps -a --format "table  {{.ID}}\t{{.Names}}"  - retaurn container id and names culomns


crontab -e  - backup script could be here
0 0 * * * /root/script.sh >> /root/backup.log 2>&1    - if we didnot write output here - we should write >>output end of each line in above script


****** one trick if you dont know dockerfile well, you can run an ubuntu container and gitclone and insatll needed app after docker commit ready container and save it as image then push that image to repo and use it as a ready image - as reverse engineering but best practice write dockerfile

docker commit containerbackupname containername

docker image ls

docker save containerbackupname>>~/containerbackupname.tar



# docker volume and storage

to save container data - we can save data in 3 options:

1- volumes  - save data in docker area (/var/lib/docker/) in /volumes/ folder - recommand for persist data
2- bind mounts  - custom directory but limited functionality - 
3- tmpfs mounts  - stored  in hosts memory - least recommanded- for very high speed compute container (microsecend- dataanalyse-big data) - 


mostly use volumes and bind mounts -

docker file system - storage driver - change file system block in sectors - in ext4 512 B - 
in linux we have - ext4 (default in debian) - xfs (default in RHEL)  - zfs (default in mac)  - btrfs - ..... 
windows file system - fat32 - ntfs


to see filesystem in linux use df command
df -h   -  human readable df

df -Th   - human readable df with type of fs

docker file system is :

overlay2  - defaults for docker fs
btrfs & zfs
vfs
aufs
devicemapper  - for lvm
overlay  - old linux efor ,inux 3

docker file system defaults is overlay2

docker info - see docker fs


#### important note: if you have 1 t stroage for infra to devops, when install linux server give partion size 300 to / and 700 to /var/,  lack of enough space to / cause server crash. 
all apps like kuber and jenkins , ... uses /var/ to work and may be full and need to extend. If all the storage space is occupied by Docker the server would be crashes. if we use sparate partiotion to / and /var/ we can extend it in case of full memory in /var/ . OS file in / and its not extendable.
but we can extend  /var/ if it was separate partion with out / or os file.  


####  volume 


docker volume ls    - list of volumes used by docker and make manually with camand by us. note that df -Th display docker overlay that made by docker itself for commit command we can not see those in docker volume ls   - command

docker volume --help

docker volume rm   - remove volume

docker volume prune - remove unused local volumes 

docker volume inspect volumename  - inspect about that volume

docker volume create volumename -  create volume 

after create new volume we can mount or attach it to a container . it look like share directory . we can see its size in host directory. 


#### bind mounts

every path in host can be bind mount to container in this type. no need to docker create . docker volume ls not show this types vols. 

to assign vol to container:

-- mount source=sourceonhostpath,target=targetpathonguest 

docker run -d -it --name devtest --mount type=bind,source=/home/mydir,target=/app nginx:latest

*****recommand:

--volume or -v host:guestpath   - most used

docker run -d -it --name devtest --volume /home/mydir:/app nginx:latest

docker inspect devtest | less



to remove all container that running : 
docker ps -q  - show containers id
docker rm -f `docker ps -aq`


docker run -dit --name containername -v volumename:/app imagename:tagver
docker exec -it containername bash


or

 cd /app && echo "hello im containervol" >> containerdata.txt  - in container see in host myvol - if container remove volume data resist in myvol directory and we can bind it agin to another container with commadn: 
 docker run -dit --name containername -v volumename:/app imagename:tagver



in database we use this senario: 

/dbdata --> myvolume1 . write script to backup hourly this data .tar.gz and scp to other server. if container attacked or ransamware. we can delete container and restore data in myvlume1 folder mount it to new container.

or we can write myvol data with one container and read it with many container 

or its a load balancing solution . with one html source code we can create many (for ex>: 5 ) container to load balance. then we should use HAproxy to bind a vip (virtual or float ip to use final in dns  and proxy) ip to 5 internal ip to load balance. 



database engin mastly use out of orchestrator (k8s - swarm ,..) couse it may be buttle neck . bandwith in cloud is very high . use networksharing to sync database data volume folder.  


docker run -dit --name ubuntumyvol2 -v myvol:/app -v myvol2 ubuntu:22.04

docker run -dit --name ubuntumyvol3 -v myvol:/app -v myvol2:/app2 -v myvol4:/app4 ubuntu:22.04

docker exec -it ubuntumyvol3 bash

echo "heloo app4 from ubuntu myvol3" > app4.txt

cd /var/lib/docker/volumes/myvol4/_data

vi app4.txt

### create and manage bind mounts volume


bind custome directory in host to custom directory in guest with --volume or --mount:

docker run -d -it --name devtest --mount type=bind,source=/home/mydir,target=/app nginx:latest

or simply use

docker run -d -it --name devtest --volume /home/mydir:/app nginx:latest

docker inspect devtest | less


docker volume inspect myvol4

no need to create volumes before. dockers make volume is not exist automatically.

to finde wich container assign to witch volume use :
docker inspect ubuntumyvol3

best practice is use this:

 docker run -dit --name ubuntuvol -v /tmp/:/apptmp -v /home/zizi/:/homezizi -v myvol3:/app3 ubuntu:22.04

 docker exec -it ubuntuvol bash

 cd apptmp/



docker volume ls  - just demonstrate docker area volume not bind mounts.


 
### tmpfs mounts

memory space allocation to guest volume. its not safe on crash or reboot all data will be lost. use for compute data and data analyse in very high speed proccess. we dont have source here just specify destination.

docker run -d -it --name tmptest --mount type=tmpfs,destination=/app nginx:latest

or 

docker run -d -it --name tmptest --tmpfs /app nginx:latest


docker run -dit --name ubuntutmpfs --tmpfs /apptmpfs -v /home/zizi/:/appzizi -v myvol3:/appmyvol3 ubuntu:22.04

 docker exec -it ubuntutmpfs bash

 echo "tmpfs" >>/apptmpfs/ou.txt 


****hint:*****
in docker run: 
--restart always  - when container stop - it restart and try to keep up container  - best practice use this

--restart on_failure   - if container exit code is not 0 it restarted

--rm   - when we use it on exit container not stop it removes automatically on exit - it use in temmporary container in pipeline - 




 


# docker network

container network model or CNM - 

all container's made NAT connection from docker0 

server is infra - docker engine made 2 component (network driver(ip , mac ,dhcp to networks) - IPAM driver(ip , mac and dhcp server for endpionts)) that have two type module: network - endpoint

network module is docker0 that may be vary in different range. work like swith in network. container in same range can ping together. for ex.:

172.17.0.1/16
172.18.0.1/16
.
.
.
.


endpoint module is containers network card. fro ex.:
172.17.0.4 - or - 172.17.0.5 -or- 172.18.0.6 ,....



we have 5 type of network drivers:
1- bridge  - is default network driver - works same as nat in vm - we call nat in container . like: docker1 - docker 2 ,... ******
2- host   - is same as host in vm- containers have not nic and ip. it use laptop or host network card. if nginx in this type use 80 in host it binds to 80 hosts. we have always 1 host driver
3- none  - no network card
4- overlay -  we have multiple host and server - we have this model just in docker ee or in docker swarm - web server ,db server,app server ,...negotiate in this model
5- macvlan  - allows you to assign a mac address to container and making it appear as phisical device on network. use in different range ip like: 10.10.10.10 , 192.168.0.2,.... in host we have nic (wifi) - docker0 - macvlan  - ,.. - dockerd routs to container by mac - in place network driver


in vm we have 4 type of network driver:
1- nat  - with other range of ip - vnic that guests bind to it . vnic bind to nic server to connect to net.
2- bridge  - with vnic all guests connect directly to modem router like server nic. and get ip from router. their ip range is device ip range in home that connect to router.
3- host  - i this model we dont have vnic. no one of gust have vnic . all of them is connect to nic directly and ip is same as nic server. 
4- none  - no nic and no vnic





docker network ls  - show docker network drivers -

docker network connect  - we can make and connect new network to a running container without stop or rm it. same as disconnect

docker network create --driver bridge netbrid1  - we can not make host couse we have just one host in host

docker network ls


ip a 

 docker run -dit --name ubuntunetbr1 --network netbrid1 ubuntu:22.04  - network card default  is down when assign to a container it change to up

docker inspect ubuntunetbr1

note: when we run a container we can just assign a network . but after runnig we can coonect it with below command:

 docker network connect test ubuntunetbr1

docker inspect ubuntunetbr1



docker network disconnect netbrid1 ubuntunetbr1   - discon


note that we can not create and  assign network card on air on docker run command cause it need to  create before to specify  network card type. 


docker run -dit --name nginxhost1 --network host nginx

 docker ps -a


 docker inspect nginxhost1
 
 docker exec -it nginxhost1 bash

 ip a

apt update ; apt install iproute2

ip a --- its exactly same as ip a in host

exit

now curl localhost return same in container and host

elinks http://localhost

in this model no need to docker inspect to specify nginx container id to curl it. and we can see container fron external



docker network create --driver=bridge --subnet=192.168.0.0/16 br0

Additionally, you also specify the --gateway --ip-range and --aux-address options.


docker network create \
  --driver=bridge \
  --subnet=172.28.0.0/16 \
  --ip-range=172.28.5.0/24 \
  --gateway=172.28.5.254 \
  br0


If you omit the --gateway flag the Engine selects one for you from inside a preferred pool. For overlay networks and for network driver plugins that support it you can create multiple subnetworks. This example uses two /25 subnet mask to adhere to the current guidance of not having more than 256 IPs in a single overlay network. Each of the subnetworks has 126 usable addresses.


docker network create -d overlay \
  --subnet=192.168.10.0/25 \
  --subnet=192.168.20.0/25 \
  --gateway=192.168.10.100 \
  --gateway=192.168.20.100 \
  --aux-address="my-router=192.168.10.5" --aux-address="my-switch=192.168.10.6" \
  --aux-address="my-printer=192.168.20.5" --aux-address="my-nas=192.168.20.6" \
  my-multihost-network  



# docker embedded DNS server


docker had a embedded dns server in default . this dns works just with user defined bridge networks not default bridge. this feature is used to configure container to call each other and ping with name. cause container ip  may be vary on each running of image docker. caintainer can resolv each other with container name.

builtin dns server always run at addresss 127.0.0.11


container on default bridge can access or call and ping each other just on ip address.



docker rm -f `docker ps -aq`   - remove all container



 docker network inspect netbrid1  - show network info and assign container but docker volume not.

 
apt update ; apt  install iputils-ping  - install ping package 


ping nginxhost1

docker stop and start may be  get different ip address from docker 0


# ports

By default, when a container created, it doesn’t publish any of its ports to outside.

To make a port available to services outside of Docker, or to containers which are not connected to the container’s network, use the --publish or -p flag.

It’ll creates a firewall rule which maps a container port to a port on the host.

-p 8080:8   -   Map TCP port 80 in container to port 8080 on Docker host.


-p 192.168.1.100:8080:80  - Map TCP port 80 in container to port 8080 on Docker host for connections to host IP 192.168.1.100.


-p 8080:80/udp  -  Map UDP port 80 in container to port 8080 on Docker host. 

-p 8080:80/tcp -p 8080:80/udp  - Map TCP port 80 in th container to TCP port 8080 on Docker host, & map UDP port 80 in container to UDP port 8080 on Docker host.


*****-p host:guest****

 docker run -dit --name nginxpo2 -p 8080:80 -p 1444:443 nginx

 now:

 curl 172.17.0.9 == curl localhost:8080
 

 note that port assignation is possible just in docker run .


0.0.0.0  - means all ip- if not specify protocol its default is tcp


note: in host we have one port 80 but we can make alias in network card to many internal ip to have multiple 80 port with different alias ip. 
assign multipla ip address (aliases) to single nic:

ifconfig ens33:0 192.168.1.3 netmask 255.255.255.0 up 

ifconfig ens33:0 down


ip addr add 192.168.1.10/24 dev ens160 label ens160:0 


ip addr add 192.168.1.10/24 dev ens33 label ens33:0

ip addr add 192.168.1.11/24 dev ens33 label ens33:1

ip addr add 192.168.1.12/24 dev ens33 label ens33:2

ip a


 docker run -dit --name nginxalias1 -p 192.168.1.10:80:80 nginx

 docker run -dit --name nginxalias2 -p 192.168.1.11:80:80 nginx

 docker run -dit --name nginxalias3 -p 192.168.1.12:80:80 nginx


curl 192.168.1.10


curl 192.168.1.11


curl 192.168.1.12



docker exec -it nginxalias bash


 cd usr/share/nginx/html/

docker run -dit --name nginx1 -p 192.168.1.10:80:80 -v nginx1:/usr/share/nginx/html -v /var/log/nginx1:/var/log/nginx nginx


ls -l /var/log/nginx1/

cd /var/lib/docker/volumes/nginx1/_data/

ls -l

 vi index.html  - make chnage and save it


 curl 192.168.1.10


cd /var/log/nginx1/

tail -f access.log


 status 200 in website means it opens succesfully - every request is one person


 #### docker logs


 docker logs -f nginx1  - entrypoints or cmd logs


 docker events  - its about container up and downs in system- give this command to scrpit and monitoring app to monitor and email each event to admin

 docker top nginx1  - top in container

 docker stats  - demondtrate resource usage of containers

 to limit resource usage do:


 docker run -dit --cpus 1.0 ubuntu             -> Assign 1 CPU to container


 docker run -dit --cpu-shares 1024 ubuntu      -> Assign from 1~1024 Cycle- 512 assining 50% total cpus (4 cores) 
 
docker run -dit --memory 200m centos       -> Limit no assign memory usage to 200Mb 

docker run -dit --memory-reservation 150m --memory 200m centos -> assign for reserve memory .Set soft limit for memory usage to warn before exceeding limit


docker run -dit --name ubuntulimit --cpus 1.0 --memory-reservation 300m --memory 500m ubuntu:22.04


docker stats


practice: ssh container with 2022 port expose that we can ssh from mobaeterme into container:

apt update ; apt install stress


note: mail in server user internal in linux:

upt update; apt install mailutils


mail -s "hello" ubuntu@localhost

cat /var/spool/mail/ubuntu



to mail server we can install postfix and ,... but grafana has mail server built in we use this to alert and admin usage.





 









