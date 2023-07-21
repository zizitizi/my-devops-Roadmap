# some best practice senario

## docker swarm - cluster


in swarm when we use more than one replica network type change to overlay



***dns issue*******


sudo sed -i -e '1inameserver 10.202.10.102\' /etc/resolv.conf   - insert in first line of resolv.conf file :  (nameserver 10.202.10.102)

sudo sed -i -e '1inameserver 10.202.10.202\' /etc/resolv.conf   - insert in first line of resolv.conf file :  (nameserver 10.202.10.202)

systemd-resolve --status

resolvectl status

pkill ssuttle
*****************




docker service ps nginx-service  - this service info

docker service ls  - all service info

docker service rm nginx-service

docker network create nginx-net

docker service create --name nginx-service --publish 8080:80 --network nginx-net nginx:latest

docker service create --name nginx-service --publish 8080:80 --max-replica-per-node 1 nginx:latest


docker service scale nginx-service=5



docker service rm nginx-service


docker service create --name nginx-service --publish 8080:80 --replicas 5 nginx:latest


the rule :
They don't touch what works. when a service is up and running dont add anythings. if you need do that , stop or restart service to add new node to cluster.
after specifeid number of restart , swarm change the node for that service.


swarm has auto simple auto load balance roundrobin seris .in kubernetese we can also bring auto load balancer with : traefik , metal lb, ....

in swarm with leader ip all other node is accessible but with one other node just that node is accessible.

in swarm we works with master. just its ip. but when we have multi master should use HAproxy to get float ip (ip1 - ip2,...)  then we should add new node to cluster as HAproxy and config it with ip float and put the domain on it. it give trafic to masters and in next step master gives trafic to workers.




## nfs

network file sharing (lpic2 -file sharing) . when we have for ex. 3 node with nginxi and want to run specifiec wesite (ex.: git.com) we should use same volume folder to mount between webserver on network (nfs).  same as in windows we have smb or server message protocol. samba server and samba client also in linux can interact with smb in windows. 

but nowdays after windows 2016 nfs is supprting in windows os too. 

install nfs:

apt install nfs-kernel-server -y


in nfs share means export. share dir1 == export dir1

first create global root directory to export

then creat to folder in it to bind mount them to our main direstory  . we use nfs commonly on master

/srv/nfs4/   - root directory   - couse we know everytime just everything that is here is shared with other.

mkdir -p /srv/nfs4/backups   - to bind mount /opt/backups/

mkdir -p /srv/nfs4/www   - to bind mount /var/www/


mount --bind /var/www/ /srv/nfs4/www/

mount --bind /opt/backups/ /srv/nfs4/backups/


in etc we have file system table or fstab. to make 2 mount temporary path persist (after restart or shutdown persist) we should write 2 path in fstab:

vi /etc/fstab


/opt/backups /srv/nfs4/backups  none bind 0 0

/var/www /srv/nfs4/www  none bind 0 0



now add shared file list to export

vi /etc/exports

/srv/nfs4  192.168.10.0/24(rw,sync,no_subtree_ckeck,crossmnt,fsid=0)

/srv/nfs4/backups  192.168.10.0/24(ro,sync,no_subtree_ckeck)

/srv/nfs4/www  192.168.10.0/24(rw,sync,no_subtree_ckeck)


first line is our global root directory . everything is in it is shared. IP ranged that can see shared folder and connect with specified specification to it is determine here.(maybe single ip) or maybe multiple ip range with determine difference specification.
rw  -  read and write

ro - readonly

sync  - immediatly sync if anyone in other server write to nfs is recommanded

no_subtree_check   -  if there is subdirectory in this folder parent folder permission is inherited or not seperated from parent. bestpractice is to be.

crossmnt   - for directory's that have subdirectory to share - root directory must have it

fsid=0   - just to detemine this is global root directory .





then export all -a and read config to execute them -r and -v to verbose to ckech it again

exportfs -ar

exportfs -v

then open nfs port in your firewall - nfs port is 2049

ufw allow from 192.168.33.0/24 to any port nfs

ufw status


now we should install nfs in client servers

apt install nfs-common   - in centos use yum install nfs-utils - its default installed in many linux distro.


and make mount point in all client servers.

mkdir /var/www   -  make dir if not exist

mkdir /opt/backups   

mount that:

mount -t nfs -o vers=4 192.168.10.10:/backups  /opt/backups/    - servers know global root directory . 

mount -t nfs -o vers=4 192.168.10.10:/www  /var/www/


to ckeck it use:

df -Th   - df list file system , T reveal type of file systems and h is human readable

hint: in master nfs servre in 

cd /srv/nfs4/

chmod 777 www

chmod 777 backups

chmod 777 /var/www


now we can write in server-2:

cd /var/www   - everything write here i ll see in server

touch test1.txt 


also mount point should be added to workers fstab to be permanent.

in worker:

vi /etc/fstab

192.168.33.10:/backups /backups nfs defaults,timeo=900,retrans=5,_netdev 0 0


192.168.33.10:/www /srv/www nfs defaults,timeo=900,retrans=5,_netdev 0 0



now in master node we create serveice with --mount  (note that service create have not --volume):

docker service create --name nginx-service -p 8080:80 --mount type=bind,source=/var/www,target=/var/www --replicas 5 nginx:latest



couse in nfs used storage is server1 or master server then we should give it large storage and resource as well. in swarm and kuber masters node should have resource mount bigger that other node. worker is half than master

docker service ps nginx-service


curl 192.168.10.10:8080

in nginx html code is in:
/usr/share/nginx/html

in apache html code is in:
/var/www/html



to see this nfs network and out ip from outside net

in virtual box go to network port forward 127.0.0.1 8080 add role. in vmware dont need do this. it forward automatically.


we use always masters ip.


## bestpractice senario:

1- nfs server just for storage no added program (1core- 1gig- more than 1TB) . unvisible to others in network. just for storage for masters(swarm or k8s or other orchestrator)

2- a node for HAproxy to lb to masters - hubswitch role

3- 3 master that is worker too. there is nfs client (nfs-common installed) 

4- other node unlimited is worker



practice1 - config haproxy with 3  float IP (masters) ? (send config in approx. 10 line) 

practice2 - create 5 vm - one for nfs (1core-1g) - one for haproxy(1core - 1gig) - 3 node for masters and worker (1core 2 gig or 2core 2 gig) 

practice3 - what goes on leader when it is down in cluster in The following states , is it return automatically or join again manually?:

1- leave manually ?

2- crash that node or turn off and turn on that node?

practice4 - what and how is labeling? how can we label workers and masters in docker swarm? wich command is for label node? wich command is for assign service for specific node?



## swarm labeling

in real we dont have virtual clustering in swarm. but with labeling we can do it manually.  in practice when we have 5 server or node one solution is make 2 swarm cluster with  2 for staging and 3 for production. but its not best practice. we do 5 node in one swarm cluster and label with 2 stg and 3 with prd . 

docker service create --label stg

docker service create --label prd

then make all 5 node masters and workers. its persist to fault of 2 node. 



# docker stack

compose in swarm. instead of docker service create for docker compose use docker stack:

docker stack deploy --compose-file docker-compose.yml voting-app


in voting app ex. we do:

git clone https://github.com/dockersamples/example-voting-app.git


docker stack deploy --compose-file docker-stack.yml voting-app


docker service ls


docker stack can work with docker swarm and k8s<=v1.23 . depends on in docker stack may not work. 


nfs in k8s in complicated. if data is so critical and sensitive then Ask the organization's network administrator or db engineers to cluster that data and place the data in the relevant servers and give its address .

#### this file is meant for Docker Swarm stacks only
#### trying it in compose will fail because of multiple replicas trying to bind to the same port
#### Swarm currently does not support Compose Spec, so we'll pin to the older version 3.9

version: "3.9"

services:

  redis:
    image: redis:alpine
    networks:
      - frontend

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "postgres"
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend

  vote:
    image: dockersamples/examplevotingapp_vote
    ports:
      - 5000:80
    networks:
      - frontend
    deploy:
      replicas: 2

  result:
    image: dockersamples/examplevotingapp_result
    ports:
      - 5001:80
    networks:
      - backend

  worker:
    image: dockersamples/examplevotingapp_worker
    networks:
      - frontend
      - backend
    deploy:
      replicas: 2

networks:
  frontend:
  backend:

volumes:
  db-data:




docker stack ls

docker stack ps voting-app


docker stack services voting-app  == docker service ls


senario:  4 server parspack - 1 server and main is for hosting (nfs - gitlab for push and commit . developers write compose file - graffana and prometeus - monitoring - backup for db and everything - HAproxy - static and valid ip for domain that is for production - ,....). this server have periodical snapshot for backup maybe weekly or 2 or 3 time in week. keep 5 last snapshot. 

3 node for swarm all is master and worker - 1 labeled for stg ( test domain : domainexample-stg.com) and 2 labeled for prd (production domain : example.com that configured in haproxy)  - we write ci/cd pipelind and play button to run stg and another for production.  



#### local registery:

2 type local registery:

1- nexus is open source and free. The most comprehensive repo software in the world.repo managment: apt - yum - docker - maven - dll - helm repo's. jfrog is other that nowdays not free and open source. nexus has gui - web account managment and user pass - ssl - https -  recommanded****


2- insecure registary - small and simple for small company that is not sensitiev data and security - or data centers not connected to net. https - have not account and user pass managment - have not gui - just cli - based on container as registery - not recommanded



use notion to keep your note.


