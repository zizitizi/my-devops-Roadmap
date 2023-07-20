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


now in master node we create serveice with --mount  (note that service create have not --volume):

docker service create --name nginx-service -p 8080:80 --mount type=bind,source=/var/www,target=/var/www --replicas 5 nginx:latest











