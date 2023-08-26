
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



2 way is exeist to define service:

1- in command mode:

use expose to assign a service to a deployment  or ... . if we dont mention port it cosider equal to target port.
also if we dont mention node port it assign a port abave 46000 to it.

kubectl expose rc nginx-rc --name=nginx-svc --target-port=8080 --type=NodePort




2- with yaml file: we recommand it to define it once and store it in git repo after than u can call it when ever you need it. 

to assign a service to a pod

first apply a pod

kubectl apply -f pod1.yml


kubectl get pods -A -o wide 


open that pods yaml file use 3dash role --- to seperate service and merge it to that pod file with alittle change


      
      apiVersion: v1
      kind: Pod
      metadata:
        name: nginx-pod
        namespace: default
        labels:
          app: myapp
      spec:
          containers:
            - name: nginx-ctr
              image: nginx:latest
              ports:
                - containerPort: 80
      
      ---
      
      apiVersion: v1
      kind: Service
      metadata:
        name: myapp-services
      spec:
        type: NodePort
        ports:
           - targetPort: 80   # exactly equal to container port
             port: 80    3 not important
             nodePort: 30008   # external port
        selector:   # very important section
           app: myapp     #-same as pod label
      


kubectl get pods -o wide


kubectl get svc -o wide


pod: 10.244.2.23:80 

svc: 10.97.130.45:80 

curl 10.244.2.23   - should work -it used for trouble shooting

curl 10.97.130.45  - should work -it used for trouble shooting  - refer to selector. check the selector with source yaml or with:

curl 192.168.44.136:30008   - should work  get it with: ip a

kubectl get pods -o yaml


then use lable copy it ot our service separate yaml file. or use command service create :

kubectl expose ....



(external - net) <---node(ip and domain) <---- svc ----> deployment(loadbalance - or may hpa) ----> many pods

in multi master senario(for ex. with 3 masters) we can use all amsters ip. but if we had domain name we should use solution snario like one of below options (solution clustering or HA clustering systems or HACS) :

- use fourth (4) node to install haproxy on it. give its ip to domain assignment ip . (single point of failure) - ip floate on 4 is manually . and we have ip node 1 , 2 ,3. 

- other solution is nginx reverse proxy solution on fourth node. (single point of failure) 

- keepalived install on masters no need to fourth other server . we install keepalived on all masters assign 1 virtual ip (vip). vip is in ip range of masters ip. we can configure it manually as desired ip or use automatically generated vip by keeplaived.



best senario is use 2 haproxy server (1core 1gig just for trafic handle) that install again keepalived on it then haproxy handle trafic to masters. 



best practice in service is: first namespace yaml --- deployment section --- service define section.


for ex.:

vi deplynginx.yml


                  
                  ---
                  apiVersion: v1
                  kind: Namespace
                  metadata:
                    name: web-server
                  
                  ---
                  apiVersion: apps/v1
                  kind: Deployment
                  metadata:
                    name: nginx-deploy
                    namespace: web-server
                    labels:
                      app: nginx
                  spec:
                    replicas: 3
                    selector:
                      matchLabels:
                        app: nginx
                  
                          # minReadySeconds: 10
                          # strategy:
                          # type: RollingUpdate
                          # rollingUpdate:
                          # maxUnavailable: 1
                          # maxSurge: 1
                  
                    template:
                      metadata:
                        labels:
                          app: nginx
                      spec:
                        containers:
                        - name: nginx-container
                          image: nginx:latest
                          ports:
                          - containerPort: 80
                  ---
                  apiVersion: v1
                  kind: Service
                  metadata:
                    name: nginx-svc
                    namespace: web-server
                    labels:
                      app: nginx
                  spec:
                    type: NodePort
                    ports:
                      - targetPort: 80
                        port: 8080
                        nodePort: 30008
                    selector:
                      app: nginx
                  
                  ---
                  
                  



remember that we may have many ports list that we can list all and - .

kubectl get pods -o wide -n web-server
















