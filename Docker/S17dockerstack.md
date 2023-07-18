# some best practice senario

## docker swarm - cluster


in swarm when we use more than one replica network type change to overlay


sudo sed -i -e '1inameserver 10.202.10.102\' /etc/resolv.conf   - insert in first line of resolv.conf file :  (nameserver 10.202.10.102)

sudo sed -i -e '1inameserver 10.202.10.202\' /etc/resolv.conf   - insert in first line of resolv.conf file :  (nameserver 10.202.10.202)


docker service ps nginx-service  - this service info

docker service ls  - all service info



