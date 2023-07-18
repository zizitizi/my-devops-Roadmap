# some best practice senario

## docker swarm - cluster


in swarm when we use more than one replica network type change to overlay



***dns issue*******


sudo sed -i -e '1inameserver 10.202.10.102\' /etc/resolv.conf   - insert in first line of resolv.conf file :  (nameserver 10.202.10.102)

sudo sed -i -e '1inameserver 10.202.10.202\' /etc/resolv.conf   - insert in first line of resolv.conf file :  (nameserver 10.202.10.202)

systemd-resolve --status

resolvectl status
*****************




docker service ps nginx-service  - this service info

docker service ls  - all service info

docker service rm nginx-service

docker network create nginx-net

docker service create --name nginx-service --publish 8080:80 --network nginx-net nginx:latest

docker service create --name nginx-service --publish 8080:80 --max-replica-per-node 1 nginx:latest





















