
# insecure registery

local registery - run container registery- simple with out ssl - port 5000 - cli - without gui - light wight - 


to run:

 docker run -dit --name registry -p 5000:5000 registry:latest

 docker ps -a

to see repo:

curl 127.0.0.1:5000/v2/_catalog




 to announce it to other server:


 


# nexus

local registery 

we can install ssl to secure pull and push to it.

ssl -https == secure registery


with out ssl == insecure registery



### ssl

80  - http

443  - https  -secure- add certificate (when buy domain. we can buy ssl - (ex.: cloudflare) when we buy international ssl from CA its signed and valid. when we use our self signed certificate and use onpromises ca server its invalid. CA server is certificate authority server. when we use ssl in connection between server and client . the transmitted data is encrypted. when we have mail server - web server - we use ssl with install it on client or join them to domain to use domain published cert. in networks linux we use to nfs to share bought ssl with all member (for ex.: web1 ssl - web2 ssl-..)



also we use ssl on orchestration to encrypte data between masters node and workers. generated token is kind of ssl. for ex.: github -gitlab - jenkins - puppet - ....

but ansible connection between contoller and rempte machins is secured with ssh. 



ssh  - ip port user


ssl  - token





# kubernetese - k8s

















