
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







# docker network













