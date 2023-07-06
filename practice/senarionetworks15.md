*Exercise-1* You can practice these tasks in a terminal or command prompt with Docker installed on your machine. Make sure you have Docker properly installed and configured before starting the practice scenario. 
 
Remember to refer to Docker's official documentation for detailed information on each command and its usage. 
 
Scenario 
Implement the diagram below in your Docker lab.


![photo_2023-07-03_10-09-42](https://github.com/zizitizi/my-devops-Roadmap/assets/123273835/2907f3ee-2647-4ef7-9121-6abf1ea819b9)



to solve this senario:

# 1- create appreciate network

     docker network create --driver=bridge --subnet=172.16.0.0/16 test

     docker network create --driver=bridge --subnet=10.10.0.0/16 prod
     












# 2- run docker for each container 


     docker run -dit --name ubdev2 --network=host --dns 4.2.2.4 ubuntu:22.04


     docker run -dit --name mysqltestip --net=test --ip 172.16.1.10 --expose 3306 -p 3306:3306 mysql

     
     docker run -dit --name nginx --net=prod --ip 10.10.10.10 --hostname nginx nginx

     
     docker run -dit --name busyboxprod --net=prod --ip 10.10.10.11 --hostname checker busybox


# 3- push to docker hub

  docker login

****************************ubuntu**************************************************************
####


        docker commit mysqltestip mysqltest:v1.0
        
        docker tag mysqltest:v1.0 zeintiz/mysql:v1.0
        
        docker push zeintiz/mysql:v1.0

links:

https://hub.docker.com/repository/docker/zeintiz/mysql/general


********************************nginx************************************************************


  docker commit nginx nginxprod
  
  docker tag nginxprod:latest zeintiz/nginxprod:v1.0
  
  docker push zeintiz/nginxprod:v1.0

links:

https://hub.docker.com/repository/docker/zeintiz/nginxprod/general

*************************************busybox*********************************************************


  docker commit busyboxprod busyboxprodip:v1.0
  
  docker tag busyboxprodip:v1.0 zeintiz/busyboxprod:v1.0
  
  docker push zeintiz/busyboxprod:v1.0


links: 


https://hub.docker.com/repository/docker/zeintiz/busyboxprod/general




