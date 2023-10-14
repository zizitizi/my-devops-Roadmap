


# chef

automation tools in ruby and erlang. Chef is best suited for organizations that have a heterogenous infrastructure. 

agaent based and service based. ohai is chef agent. just speed of config is best than ansible  couse chef ssl but ansible ssh base.

knife tools in chef that used to connect is ssl base. chef playbook is reciepe. cookbook is multiple reciepe. in ansible multiple play is playbook.

# puppet

is ssl base that means good speed. agent based and servce base. puppet server is heavy and used alot of resource in machines. ruby language. DSL used.

multiple catalouge make manifest. used in cloud and heavy virtualization (up 250 server) in many servers used for deep freeze for config on client.


puppet masters check config every 5  minute to check if it change then restore to your admin config.

most important prons from ansible is config freeze in puppet.


# saltstack

Saltstack is Python based while the instructions are written in YAML or it’s DSL. CDK (cloud development kit) is used here to translate yml or other language to DSL.

multiple state make pillars. ssl baesd and saltstack agent is grains.


# terraform 

is the same to ansible . teraform has provides that act same as ansible modules. you can add providers to your teraform from teraform registery from address :

https://registry.terraform.io/


we can USE TERAFFORM WITHOUT INSTALL from its cloud . or install it on linux from cli. write your config in terraform cloud and say it to read form gitlab and bring it ,....


terraform is ssh based but it can login with ssl too( in aws has token base). teraform is used in cloud providers. its config language is HCL (hashicorp config language) and its simple and human readable. 

also here terraform has CDK and then can translate your yml file to HCL. 

terraform do versioning in deployment. and track resource change. rollback easily. apply .tf . if dont deesires then rollback with destroy .tf

infrastructure provisioning. that can do config managmnet (same as ansible ) too. 

can login with ipmi port to  server on cloud (or ilo) and run os and vm.. we can work with hcl or yml or json. 


	Chef	Puppet	Ansible	Saltstack	Terraform
Architecture	Server/Client	Server/Client	Server Only	Server/Client	Server/Client
Ease of Setup	Moderate	Moderate	Very Easy	Moderate	Very Easy
Language	Specify how to do a task	Specify only what to do	Specify how to do a task	Specify only what to do	Specify how to do a task
Scalability	Scalable	Scalable	Scalable	Scalable	Scalable
Management	Tough as it requires to learn Ruby DSL	Tough as it requires to learn Puppet DSL	Very Easy by YAML	Agnostic & Simple	JSON (YAML)
Interoperability	High	High	High	High	High
Cloud Availability	Amazon	Amazon, Azure	Amazon	None	Amazon
Communication	Knife Tool	SSL	SSH	SSH	SSH


# monitoring (Prometheus)

monitoring is a process to gather metrics about the operations of an IT environment's hardware & software to ensure all functions as expected to support apps & services.
Basic monitoring is performed through device operation checks, while advanced monitoring gives granular views on operational states, including average response times, number of application instances, error/request rates, CPU usage & application availability.

monitoring can rely on agents or be agentless.
Agents are independent programs that install on the monitored device to collect data on hardware or software performance data and report it to a management server. (SNMP)
Agentless monitoring uses existing communication protocols to emulate an agent, with many of the same functionalities. (SSH, SSL)





core of monitoring software is NMS ( network monitoring system) . nms gather data that called metric base on time and classify them then visualize it in visualizer in graph or..

zabix,opmanager,solarwinds= nms+visualizer


prometheus=nms

grafana=visualizer


grafana has not nms or data gathering system then it should have one nms system in behind like: prometheus,zabix,....


zabix is agentbase then works on snmp protocol. snmp v3 (encrypt+user pass)is secure then you always use snmp v3. in v2 just encrypt in v1 nothing belong to secureity.

nms speak with snmp with its agent in client then we can use one monitoring in that protocol. in agent base but in agent less in base on ssh or ssl.


prometheus is agentless and egent base too. its agent name is exporter that works with http on any port you want. with differnet port for ex.: one for dbexporter - node exporter- container exporter - ,.... in go lang opensource and high speed. 

prometheus is agnet base with http (not snmp) . to use snmp install snmp exporter. to use agentless then install ssh exporter.




What is the difference between Monitoring Tools and Log Analyzers?!

monitoring is not log analyser. log analyser is directory path to app logs and sys logs ,.. then visualize on that logs. fro ex.: user report on logs. like:
for backden ELK or elastik stack include: (elastik search (nms) - logstash (gather agent) - kibana (gui - we can use grafana))  - use to log application in backend.

kibana is log analyser but grafana is log analyser+monitoring.

for frontend Sentry - web performance monitoring click states,... like google analytics that is on net and ip,....

log analyser security like: splunk - log security analyser.

in monitoring we dont use log instead use for: app service or infra ,hardware,.. 



## key elements in monitoring:

1- metrics: gather

2- monitoring: nms

3- alerting : notify .


type of monitoring:


- pull based: prom. send pull http get request to read data.

  
- push based: need push gateway . data from exporter push to gateway then prometheus pull from push gateway. then we need to install converter that ll be push gateway.


 prometheus is pull based but it can be push based. its default is pull then its simple and easy. we use push method when we dont have exporter on that app and need write script to send data. 

 

hint: in host use exporter. then install prom. in your laptop. then use grafana cloud.


zabix is heavy than prometheus.


prometheus is white box. then when treshold is reached ( cpu 80% - high ping time - ...) .  we have metric - log - trace. but in black ox we just notify to treshold reached and not show amounts. also we can install black box exporter



data=index=metrics

exporter=agent


prometheus nms pull data from exporter agent with http get request. service discovery detet pacet in network and type of them but we do not use from this. we use other service.

push gateway if you want you can install it for app that we want to push from that app


alert manager if you want you can install it but we dont use it we use grafana alert manager instead.


garafana can has difference dta source: prometheus- aws cloud watch-zabix-elastik,....

install this modules:

prometheus-grafana-push gateway-exporters




list of exporter:
https://prometheus.io/docs/instrumenting/exporters/



to monitoring containers install exporter: cAdvisor(container advisor from google)

to monitor hardware resource like: cpu , mem,.. install node exporter

to monitor pods in k8s install: kube-state-metrics  - install pods in form daemonset


you should keep  in your mind above name.



prometheus scrape data from related exporter. then we should add this config for each exporter in ymlconfig  file .like:
192.168.44.12:9091

setup prometheus procedure:

Install Prometheus and Grafana
Install Prometheus Node Exporter on Linux servers to be monitored
Configure Node Exporter
Configure Prometheus server with Scrap jobs
Add Dashboards to Grafana
Start visualizing system metrics on Grafana


we always install prom. in docker or k8s;


in docker:

docker run -d -p 9090:9090 --name prom --volume /etc/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

docker run -d -p 3000:3000 --name grafana grafana/grafana


in k8s:

kubectl create namespace prometheus


helm repo add stable https://charts.helm.sh/stable

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace prometheus



prometheus stack means: prometheus-grafana-push gateway-alert-node exporter


install on docker:

docker run \
    -p 9090:9090 \
    -v /path/to/prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus


docker run -d -p 3000:3000 --name=grafana \
  --volume grafana-storage:/var/lib/grafana \
  grafana/grafana-enterprise




    

docker run     -p 9090:9090   -dit     prom/prometheus

docker ps

docker cp gifted_raman:/etc/prometheus/prometheus.yml .


ls

docker ps -a

docker rm -f gifted_raman hopeful_herschel


docker run \
    -p 9090:9090 -dit \
    -v /home/zizi/prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus


****but best practice is that first make network to call each other with name:****


docker network create prom-net


docker run     -p 9090:9090 -dit --name prometheus --network prom-net    -v /home/zizi/prometheus.yml:/etc/prometheus/prometheus.yml     prom/prometheus


 docker run -d -p 3000:3000 --network prom-net --name=grafana \                     --volume grafana-storage:/var/lib/grafana \
  grafana/grafana-enterprise


  docker ps -a

  
if you are on virtual box dont forget to forward port 9090

http://192.168.44.136:9090/   - try not to publish 9090 to external - most important section in this page is just - status>targets - target is where that we monitor it.
when we install specified exporter then add its scrape config to yml file then reset prom. them check if its add to targets.

metrics available in /metrics url

http://192.168.44.136:9090/metrics

http://192.168.44.136:3000/  - default user pass is admin admin - 


we can add new address to scrape here in yaml:

			  static_configs:
			  - targets:
			    - localhost:9090



in grfana first login do:

1- change password

2- add new data source in:

Home>Connections>Data sources>prometheus

give a name: Prometheus-1  . becouse in docker network its in same network with prom we can call with name--> Prometheus server URL: http://prometheus:9090

scrape interval is 15s in default but if you change it you should change it in prometheus config too. there should be same. then press save and test

we can add multiple prom. or ather connections.

3- in dashboard section we should build our dashboard


in explore section we can test our connection and targets


process_cpu_seconds_total{instance="localhost:9090"}   - then run query too see graph.


add to dashborads


#### install exporters

first search prometheus exporters.
for example we want to add complete node exporters:

Node/system metrics exporter (official)

go to link: https://github.com/prometheus/node_exporter

in port 9100. we can install it by ansible. 

we want to add it by docker run then . run below command in host:

docker run -d \
  --net="host" \
  --pid="host" \
  -v "/:/host:ro,rslave" \
  quay.io/prometheus/node-exporter:latest \
  --path.rootfs=/host



  to monitor node hardware we should give it host network and give full permission to read / .



  then run :

   netstat -pentual | grep 9100


   then press url:

   http://192.168.44.136:9100/metrics  - refresh it to update


 #### change yml config prometheus

  vi prometheus.yml


 
add scrape config here (docker ip:docker inspect prometheus> here added) below scrape_configs:


  - job_name: "zizi"
    static_configs:
      - targets: ["172.20.0.1:9100"]


save it and reset   

docker restart prometheus


in prometheus check targets:

http://192.168.44.136:9090/targets?search=



in grafana:

in explore test it 


then when you want to add monitoring node. first install with node exporter with its link in prom. site add with docker image to specified dockernetwork. then add its scrape confog rest prom. tne refresh grafa then explore to test it . then to add grafana dashboard go to dashbord menu in grafana . then add new dashboard. you can upload json or add dashboard id from Import via grafana.com:

https://grafana.com/grafana/dashboards/

search your node name then select with most download tag. then copy id then add id to your grafana - add name - can change folder name- load it.

for ex.:

https://grafana.com/grafana/dashboards/1860-node-exporter-full/


also you can build your dashboard.


in node exporter most monitor resource is:

cpu usage - mem - disk space - disk I/O - net send/recive - 


use builder or code to biuld dashboard . or make test dashbpard first.or use copy ready grafana template dashboard code in your dashboard. or use grafana explorer to search your metric and filter it. then duplicate section A to add new metric to current diagram. then you can add it to a new dashboard or existing dashboard.


when add in new dashborad you can hit 3 dot and edit dashboard. other option is available to edit here: legend value - display - timezone(ifbrowser then its same as client time zone) - grid -color- graph style - unit (data- byte ,..) - treshold - alret ,....


sample:

too manitor postgres - run container exporter postgres on postgres node or where that can see the postgres instance then give it name and address and user pass to exporter container by docker run or compose:

https://prometheus.io/docs/instrumenting/exporters/ ----> postgres_exporter

https://github.com/prometheus-community/postgres_exporter  -----> run in docker network that is same with postgres node. or in other server publish postgres port to extenal to see that from prometheus (ip :port add in prometheus) :

			# Start an example database
			docker run --net=host -it --rm -e POSTGRES_PASSWORD=password postgres
			# Connect to it
			docker run \
			  --net=host \
			  -e DATA_SOURCE_NAME="postgresql://postgres:password@localhost:5432/postgres?sslmode=disable" \
			  quay.io/prometheuscommunity/postgres-exporter



call it port :9116 in prometheus.yml then addd grafana ready dashboard. 

gitlab and github exporter is suitable for monitor amount of commit ,...

to monitor container use CAdvisor exporter

to monitor pods use kube-state-metrics exporter



if we have many exporter scrape config more that 500 ,.. the best practice is use sprate prometheus with grafana:

prom-db (postgres-exporter -  mysql-exporter  - ,..)

prom-node (infra -  node1-exporter  - node2-exporter  -,...)

prom-web (nginx-exporter -  apache-exporter  - rev-proxy-exporter  - ,...)














