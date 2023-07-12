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

in this senario we have 






in front end:

voting app (in python): people vote here

result app (in node js): query result from database

in backend:

in-memory db (redis): vote data with high speed is here but not persist.

worker ( microsoft .net) : read data from redis and write it on postgres to persist data. 

db (postgresql): save the vote data persistant to save the result

this 5 container together make our voting app.

first clone it from related github:

wget https://github.com/dockersamples/example-voting-app.git

we need 2 dockerfile for vote and result app . but for redis and postgre and .net we use docker hub images.


microsoft .net use to dockerize in windows but for linux we use .net core image base

docker compose version is python version of it. docker compose write in python 

best practice is that version in docker compose file be older that installed docker compose.

docker compose version


we specified container in services section. 


ports:

  - "hostport:frontendport"




version: "3.8"
 
services:
  vote:
    image: voting-app:latest
    command: python app.py
    volumes:
     - ./vote:/app
    ports:
     - "5000:80"

  redis:
    image: redis:alpine
    ports: ["6379"]

  worker:
    image: worker:latest
  db:
    image: postgres:9.4
    environment:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "postgres“

  result:
    image: result-app:latest
    command: nodemon server.js
    volumes:
      - ./result:/app
    ports:
      - "5001:80"
      - "5858:5858“




hint: when we use db as container we should specified env variable for user and password for db admin. also specified  volume.

for image we can biuld from dockerfile directly from dockercompose or use docker hub repo.

  vote:
    build: ./vote  --> here dockercompose search this directory for dockerfile and build with container name.




### aws create server

1- login to your aws account

EC2> instance(running)> lunch instance> ubuntu> 64bit > instance type: t2.medium 2cou 4 mem> key pair name: create new key pair> newkeypairname - rsa - create key pair (dowmload and save)> firewall: select create security group > edit> inbound security group role > type: all traffic > configure storage> 1*20gig - gp2 > lunch instance.


after success creation go to menu > instances > select instance that early created . 

in moba extreme > new ssh session > enter specified ip and user name > in advanced ssh setting > use private key > select downloaded .pem file in previouse section in aws > press ok


refresh aws instace page to wait for ssh session to initializa. it may take a while.




now we can install docker in this server to run voting app senario

























