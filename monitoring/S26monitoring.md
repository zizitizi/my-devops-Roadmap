


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

1- metrics:
































