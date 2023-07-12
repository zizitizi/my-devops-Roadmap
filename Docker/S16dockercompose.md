# Docker Compose

used to run multiple container as a single service.

we write docker run commands in each container section.

its docker-compose.yaml or docker-compose.yml file to organize commands . use its synax. 2 space in below of service name. after that we can use - in place of 2 space or bracket to others.

## nginx

nginx can be play below role: web server - proxy server - reverse proxy server - mail server ,.... please read lpic2 webservice slides.



1- web server: 

2- proxy server or forward proxy: if nginx is place in front of clients. for ex.: to help employye security in safe site. to hide client ip behind nginx proxy ip.

3- reverse proxy server: if nginx is place in front of servers. to help HA, Load balancing , security ,or multiple wesite on a server with on port 80 and nameservers .... other reverse proxy server is HAproxy ,... . web site is in safe side. 


senario1:  we have 3 website up with their nginx with port 8080 - 8081- 8082 with 1 public ip. we have 3 domani name. d1.com d2.com d3.com. remember domain name that we buy from cloudflare for example just assign to port 80 or 443 not other one. another nginx that we run in server as reverse proxy nginx is change other port to 80. to forward specifoed domain name to specified port in local host. 
here we have multiple docker compose. for ex.:

web1: nginx - db -back - api - catchdb


web2: nginx - db -back - api - catchdb


web3: nginx - db -back - api - catchdb

nginx reverse proxy: in other contianer



caddy is other simple reverse proxy. with swarm.




docker version  - after version 20 docker compose commadn is be more simple

docker-compose up    -----is change to  ---> docker compose up    - if we need docker-compose we should apt install docker-compose




# example voting app

first clone it from related github:































