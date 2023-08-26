
## stateful app 

when we want keep alive session (java bean ,..) using sateful app. one of solution is websocket api that is stateful and conecctionbase. 


## run a databse in k8s

a deployment has a control-loop that manage to convert desired state to actual state. 

this is tutorial link:

https://chetak.hashnode.dev/database-on-kubernetes


when we use just one replica in db we can use deployment but not recommand. in multiple replica and more that 1 replica we should use statefulset to keep data continuous sync and persistent. 


in this site is yaml generator for k8s. its very usefull. for exam and other purpose in interview.

https://k8syaml.com/

but remember to delete label ads octupus 

octopusexport: OctopusExport





ai app to generate yaml file with cli and ai. you can install online version on master node k8s then use this to generate code and analyse. after insta;; we have command kubectl ai

https://github.com/sozercan/kubectl-ai


this is for scan all of k8s cluster analyse it for best practice and scurity problem and suggest best practice and bug.

https://k8sgpt.ai/


its a cli tools monitoring for k8s. like a btop. it can install on master or any place that have access to master. 


https://k9scli.io/


# networks or services in k8s

we call network in k8s, services. services = networks .

kubectl get svc 





generally api gateway types: rest - soap - gRPC - web socket ,... . but api in k8s is rest api. rest object send to kube api server to create new instance. 

to create service we write yaml file . that service rule as service reverse proxy. pod connect to kube proxy to connect master . we use service or svc or reverse proxy to acces external net. we have ip:port  host and ip:port  guest that use pat .

nat: network address translation

pat : port address translation

service is in 4 types:

1- load balancer : is used in cloud providers like: aws, azure , gcp,... to manage cloud load balance controller . 

2- external name: when we use cname record . k8s return us a comlex random name that with this tools we change it to map it to other name with cname. but best practice in real world we dont use this instead we use ip and reverse proxy like nginx.

in dns we have many record types: A record to name:ipv4  - AAAA record to name:ipv6 - CNAME record to name:name that used in dns servers  - MX record to domainmailserver:ip - ,.....

3- cluster ip : that is default in k8s pod. whne we can not see our pod from external then ot use cluster ip. 

4- node port: open port on every cluster node. should be over 30000. 

we have 3 layer in node port mode:

1- target port (pod)  - deployment is kind of load balancer

2- port (svc port) 

3- node port: ip master with port over 30000. 

nodeport is include cluster ip.

cluster ip include: svc (port) - pod (target port)

node port include above addition : master node (domain ip)


















