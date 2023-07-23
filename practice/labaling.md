# Placement constraints or Labeling container

A quick word about placement constraints: You may, as an example, have a cluster of 20 nodes and you would like to control where your HAProxy containers could be started when using --mode replicated. 
In this case, you should use placement constraints. They allow you to restrict which nodes Swarm can choose to run your containers. Let’s say you would like to run HAProxy only on nodes 2 and 3; 
Run these commands on any manager:

**********************
  
   
    sudo docker node update --label-add LB-NODE=yes dock2
    
    sudo docker node update --label-add LB-NODE=yes dock3

**********************
  

view raw
blog20191008-21.sh hosted with ❤ by GitHub

Then, specify the constraint at service creation:
$ sudo docker service create \
  --mode global \
  --name haproxy-service \
  --network apache-network \
  --publish published=80,target=80,protocol=tcp,mode=host \
  --publish published=443,target=443,protocol=tcp,mode=host \
  --mount type=bind,src=/etc/haproxy/,dst=/etc/haproxy/,ro=false \
  --dns=127.0.0.11 \
  --constraint node.labels.LB-NODE==yes \
  haproxytech/haproxy-debian:2.0 /usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg -L local_haproxy
view raw
blog20191008-22.sh hosted with ❤ by GitHub

Or on an existing service with the docker service update command:
$ docker service update --constraint-add node.labels.LB-NODE==yes haproxy-service
view raw
blog20191008-23.sh hosted with ❤ by GitHub

The container will only be started on nodes with a matching label.
