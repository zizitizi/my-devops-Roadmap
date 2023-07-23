# following tutprial make HAproxy on 3 node docker swarm with ingress mesh traffic with nginx service


first make docker swarm with 3 node make all manager

docker node ls -- to ckeck it

make nginx-network to communicate 3 node safly together:

docker network create --attachable --driver overlay nginx-network

### do this step in 3 nodes:

now make haproxy configuration file in any path u like. i make it in (/opt/haproxyzizi/) so do:

vi haproxy.cfg
*******************************
global
    log          fd@2 local2
    chroot       /var/lib/haproxy
    pidfile      /var/run/haproxy.pid
    maxconn      4000
    user         haproxy
    group        haproxy
    stats socket /var/lib/haproxy/stats expose-fd listeners
    master-worker

resolvers docker
    nameserver dns1 127.0.0.11:53
    resolve_retries 3
    timeout resolve 1s
    timeout retry   1s
    hold other      10s
    hold refused    10s
    hold nx         10s
    hold timeout    10s
    hold valid      10s
    hold obsolete   10s

defaults
    timeout connect 10s
    timeout client 30s
    timeout server 30s
    log global
    mode http
    option httplog

frontend  fe_web
    bind *:80
    use_backend stat if { path -i /my-stats }
    default_backend be_nginx_service

backend be_nginx_service
    balance roundrobin
    server-template nginx- 6 nginx-service:80 check resolvers docker init-addr libc,none

backend be_nginx_service_wrong_case
    balance roundrobin
    server-template nginx- 6 nginx-service:80 check resolvers docker init-addr libc,none

backend stat
    stats enable
    stats uri /my-stats
    stats refresh 15s
    stats show-legends
    stats show-node




now make nginx servive on one of nodes:


sudo docker service create   --mode replicated   --replicas 3   --name nginx-service   --network nginx-network   --endpoint-mode dnsrr   nginx:latest

docker service ls


now make HAproxy service on one of nodes:


docker service create   --mode replicated   --replicas 1   --name haproxy-service   --network nginx-network   --publish published=80,target=80,protocol=tcp,mode=ingress   --publish published=443,target=443,protocol=tcp,mode=ingress   --mount type=bind,src=/opt/haproxyzizi/,dst=/etc/haproxy/,ro=true   --dns=127.0.0.11   haproxytech/haproxy-debian:2.0


docker service ls

docker service ps haproxy-service



wait a moments to HAproxy service be available. than run to see service state on any node ip for ex.:

http://192.168.44.145/my-stats

or


http://192.168.44.143/my-stats

or


http://192.168.44.142/my-stats

to see nginx on any ip node:

http://192.168.44.142

or

http://192.168.44.143

or

http://192.168.44.145




