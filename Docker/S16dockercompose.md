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

cd votingapp/ 

git clone https://github.com/dockersamples/example-voting-app.git


to specify that vote and result app image build corectly we build them separatly.


 cd result/

 docker build -t result-app:latest .

cd vote/

docker build -t voting-app:latest .

cd worker/

docker build -t worker:latest .


in this docker file we use best practice and minimum specified command .


vi docker-compose.yml:

   version: "3.8"
   
   services:
   vote:
     image: voting-app:latest
     container_name: voting-app-vote
     hostname: vote
     restart: always
     command: python app.py
     volumes:
      - ./vote:/app
     ports:
      - "5000:80"
     networks:
      - voting-app-network
   
   
   
   redis:
     image: redis:alpine
     container_name: voting-app-redis
     hostname: redis
     dns:
       - 8.8.8.8
       - 4.2.2.4
     ports: ["6379"]
     networks:
      - voting-app-network
   
   
   
   worker:
     image: worker:latest
     container_name: voting-app-worker
     hostname: worker
     networks:
      - voting-app-network
   
   
   db:
     image: postgres:latest
     container_name: voting-app-postgres
     hostname: postgres
     environment:
       POSTGRES_USER: "postgres"
       POSTGRES_PASSWORD: "postgres"
     volumes:
       - postgres_data:/var/lib/postgresql/data
     networks:
      - voting-app-network
   
   
   result:
     image: result-app:latest
     container_name: voting-app-result
     hostname: result
     command: nodemon server.js
     volumes:
       - ./result:/app
     ports:
       - "5001:80"
       - "5858:5858"
     networks:
       - voting-app-network
   
   networks:
   voting-app-network:
   voting-app-front:
     name: frontendnet
   volumes:
   postgres_data:


#### this version is my docker hub refer :


version: "3.8"

services:
  vote:
    image: zeintiz/voting-app:latest
    container_name: voting-app-vote
    hostname: vote
    restart: always
    command: python app.py
    volumes:
     - ./vote:/app
    ports:
     - "5000:80"
    networks:
     - voting-app-network



  redis:
    image: redis:alpine
    container_name: voting-app-redis
    hostname: redis
    dns:
      - 8.8.8.8
      - 4.2.2.4
    ports: ["6379"]
    networks:
     - voting-app-network



  worker:
    image: zeintiz/worker:latest
    container_name: voting-app-worker
    hostname: worker
    networks:
     - voting-app-network


  db:
    image: postgres:latest
    container_name: voting-app-postgres
    hostname: postgres
    environment:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "postgres"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
     - voting-app-network


  result:
    image: zeintiz/result-app:latest
    container_name: voting-app-result
    hostname: result
    command: nodemon server.js
    volumes:
      - ./result:/app
    ports:
      - "5001:80"
      - "5858:5858"
    networks:
      - voting-app-network

networks:
  voting-app-network:
  voting-app-front:
    name: frontendnet
volumes:
  postgres_data:





to see postgres data : 


cd /var/lib/docker/volumes/example_voting_app_postgres_data/_data  - then write script to backup data to .tr.gz 


we use depends on to condition to other container

 depends_on:
      redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 15s
      timeout: 5s
      retries: 3
      start_period: 10s    - wait for 10 second and test it again after 15 s.



we can use seed to generate dabase and use fake data to keep db up

 #this service runs once to seed the database with votes
  #it won't run unless you specify the "seed" profile
  #docker compose --profile seed up -d
  seed:
    build: ./seed-data
    profiles: ["seed"]
    depends_on:
      vote:
        condition: service_healthy
    networks:
      - front-tier
    restart: "no"




docker compose up -d   - detach containers


docker compose ps  - we can use this command only on specified previously docker compose folder.

docker ps  - show all container in system not for this docker compose related.

default container name for docker compose is folder name+ service name + 1 - to specified name manually use container_name command (that is projectname+containername).  use hostname to see that name in docker exec

best practice is use network name for spcify same network for container to call each other by name in each docker compose. in this senario its the best to use 2 network for frontend and backend. but redis and db is in 2 net. to create network right from docker compose we could be write networks section same identation as services at the ens of file . default driver is bridge then we can ignore to write it. but in other type we should specify for ex. with : (driver: host) 

  voting-app-front:
    driver: overlay

same as volume . for volume in docker area we should specify in end of docker compose.

volumes:
  pro_data_dev:
  postgres_data:
    driver: local

### docker compose command


docker compose down


if our docker compose file not in default name we should below commadn to build:

docker compose -f mydockercomposename.yml up -d

docker compose -f mydockercomposename.yml ps  - so its recommadn to use default name.


docker compose -f mydockercomposename.yml down


now we can brows for vote in : 13.41.227.209:5000

now we can brows for result in : 13.41.227.209:5001



docker compose file line have not priority . cause all of them is compile together with specified python version.







 

we need 2 dockerfile for vote and result app . but for redis and postgre and .net we use docker hub images.


microsoft .net use to dockerize in windows but for linux we use .net core image base

docker compose version is python version of it. docker compose write in python 

best practice is that version in docker compose file be older that installed docker compose.

docker compose version


we specified container in services section. 


ports:

  - "hostport:frontendport"






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


#### environmant variable in docker compose

in 2ways . in docker compose . or out of it with file with name it .env beside the main docker compose file:

for ex. in docker compose: 

environmet:
  POSTGRES_USER: ${POSTGRES_USER}

again :

vi .env

POSTGRES_USER="username"



#### working with docker compose container

we can use it with :

docker exec -it 

or

docker compose exec redis sh

same as other commands in docker dompose and docker. commonly use docker command



# docker swarm

its an orchestrator like kuber , mesos ,.... for scaling , load balancing, managing container ,..... its on nfv/sdn architecture.

replica in orchestration = same containers and sync together

docker swarm = simple and featureless les  == 30 to 40 

kuber = more complicated and many fature for more than 50 --60 use kuber


when we install docker-ce , swarm also be installed

























