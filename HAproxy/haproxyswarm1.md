# swarm HAProxy service with nginx


docker service create -d --name nginx1 --network nginx-network -p 8080:80 nginx:latest


haproxy is created in node that has below config file. 


docker service create -d --name ha --network nginx-network -p 80:80     -p 8404:8404   --mount type=bind,source=$(pwd),target=/usr/local/etc/haproxy haproxytech/haproxy-alpine:2.4




global
  stats socket /var/run/api.sock user haproxy group haproxy mode 660 level admin expose-fd listeners
  log stdout format raw local0 info

defaults
  mode http
  timeout client 10s
  timeout connect 5s
  timeout server 10s
  timeout http-request 10s
  log global

frontend stats
  bind *:8404
  stats enable
  stats uri /
  stats refresh 10s

# Configure HAProxy to listen on port 80
frontend http_front
   bind :80
   stats uri /haproxy?stats
   default_backend http_back

# Configure HAProxy to route requests to swarm nodes on port 8080
backend http_back
   balance roundrobin
   server node4 nginx1:8080 check
   server node3 nginx1:8080 check
   server node2 nginx1:8080 check



http://192.168.44.145/

http://192.168.44.145:8480

http://192.168.44.145:8080

also check for other ip









