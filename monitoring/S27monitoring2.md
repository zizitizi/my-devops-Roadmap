
# prometheus & grafana


too run with docker compose run prom. with push gateway(port 9091). 

first run prom. and graana just for copy prometheus.yaml ang garafana.ini in docker volume folder too  mount it then run docker compose


docker logs -f prometheus  - to see logs




go to grafana node exporter dashboard. to build cpu usage do edit for a dashboard you can edit with code ( pmql language) or make it with builder. for cpu usage do 1-idle

100-((avg(irate(node-cpu-secpnd_total{instance=~"127.0.0.1:9100",mode="idle"}[1ms])))*100)

=~ means == but theres is string in it

in mem usage : 1- availabe/total

net send , recive unit si






# CAdvisor

cAdvisor is a daemon that runs into a container that exports statistics regarding containers resource usage from the host machine.We can use it as stand-alone or export its statistics to Prometheus.cAdvisor can be run on two way:
1- Docker
2- Docker-Compose (optional)


      - job_name: 'cadvisor'
          static_configs:
          - targets: ['cadvisor:8080']
            labels:
              alias: 'cadvisor'
      

to run it in docker:


https://prometheus.io/docs/instrumenting/exporters/


https://github.com/google/cadvisor


VERSION=v0.36.0 # use the latest release version from https://github.com/google/cadvisor/releases
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor


cadvisor per each server install and add its scrape config to prometheus.yml in docker swarm


http://192.168.44.136:8080/containers/

then add its scrape config to promethus.yml

  - job_name: "containerszizi"
    static_configs:
      - targets: ["172.18.0.1:8080"]



save and reset container . check it up:

http://192.168.44.136:9090/targets?search=


then go to grafana dashboard and import it. then go to grafana dashboard site:

https://grafana.com/grafana/dashboards


add id to your dashboard


to filter result in edit dashboard go to code write down:

{name!="containernotwanttoseeit" , name}



Node environment monitoring:
Recommended: https://grafana.com/grafana/dashboards/159 
https://grafana.com/dashboards/1860 
https://grafana.com/dashboards/3662 
https://grafana.com/dashboards/8919 
https://github.com/arashforoughi/grafana-dashboards



Docker and System Monitoring:
Recommended: https://grafana.com/grafana/dashboards/14282 
https://grafana.com/grafana/dashboards/179 
https://grafana.com/grafana/dashboards/11600 
https://grafana.com/grafana/dashboards/193 




Kubernetes Cluster Monitoring:
Recommended: https://grafana.com/grafana/dashboards/315 
https://grafana.com/grafana/dashboards/6336 
https://grafana.com/grafana/dashboards/395 
https://grafana.com/grafana/dashboards/7249 



in dashboard grafana for stop container use : allcontainernumber - (runningcontainer)

running container: count(container_last_seen{image!=""})


# helm

is package manager for k8s

helm.sh

https://artifacthub.io/

  
helm list

helm uninstall packagename


helm repo list

you can install kube-prometheus-stack from helm repo


Add repository

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

Install chart

helm install my-kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 51.7.0

or we can install kube state metrics manually with below stage 


# kube state metrics


to monitor pods

goto exportersite

https://prometheus.io/docs/instrumenting/exporters/

https://github.com/kubernetes/kube-state-metrics


one installation is enough for all your cluster becouse it run as daemon set

if yo install it as deploy then you should install it on each node


https://devopscube.com/setup-kube-state-metrics/

git clone https://github.com/devopscube/kube-state-metrics-configs.git


kubectl apply -f kube-state-metrics-configs/

kubectl get deployments kube-state-metrics -n kube-system


kubectl get all  -n kube-system


we need nodeport then expose this clusterip port with command:


kubectl expose deployment kube-state-metrics -n kube-system --name=kube-state-metrics2 --type=NodePort --target-port=8080 --port=8080


then run  


add its scrape config
              
then add its dashboard id (13332) . in aws server cpu-mem - networka is most important but in baremetall or phisical server storage and i/o also important.

for cpu memory commonly use guage 

for network commonly use stat

for storage disk space commonly use bar guage lcd


but if you have k8s running then run prometheus on it then dont run it on docker.




# alert

for alert use grafana dashboard menu . dont use prometheus.

alert rule

contact points: where we sent alert there.


we can edit grafana default email


slack is messaging app but dont work in banned country

if we have webhook we can get it and define it in here.

if you use email then you should add mail serevr to grafana.ini that mounted in docker run.


in that config file search /smtp

use host or smtp server or gmail smtp. if use gmail then you can use googel paswword app to generate password for specific app and use that password here.

if https then uncomment cert_file = 

if not use https then uncomment skip_verify = 

from_adress that email send from that address for ex.:admin@grafana.localhost if gmail then same as user_address

save and exit





in all chat message app we have webhook. for example watsapp webhook url copy here and use like an api telgeram ,...

in slack create channel in list of integration choose incomming webhooks> configuration.

for example for telegram search telegram webhook . then give url here and then chatbot telgeram id adress that you create in your telegeram paste here.


instead of alert rule we set it in grafana dashboard section and define rule. in alert rule from menu we define alerting group like cpu-alert-group ,...

and make folder for example: infra monitor alert

evaluation group name and interval.


nodata when prom. may down or...



***practice:*** run prometheus in k8s with helm


***practice:*** run mongodb in docker compose and statfulset in k8s with helm monitor it with mongodb exporter(query per second - and response time)


grafana can interact with zabbix . you need to add it plugin in grafana and add in datasource. Zabbix plugin for Grafana


https://grafana.com/grafana/plugins/alexanderzobnin-zabbix-app/


with docker exec go inside grafana and install:

grafana-cli plugins install alexanderzobnin-zabbix-app

in grafana go to folder /etc/grafana/plugins and untar  linux-amd64 or ...


then reset grafana then go to datasource and add zabix

or do all in docker compose











  












