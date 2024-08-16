
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
                  




                  

 kubectl get deploy -o wide -n web-server

  kubectl get svc -o wide -n web-server

 kubectl get pods -o wide -n web-server    - we can connect to each pod and change html code to see load balancer change

 kubectl exec -it nginx-deploy-5b58668cfc-5vs25 -- bash   - run this command on related node

 curl 192.168.44.136:30008  - lb to 3 pod on masters or every  where 




remember that we may have many ports list that we can list all and - .

kubectl get pods -o wide -n web-server   - we can use kubens or kubectx tools to avoid default ns with kubens. we can assign default namespace manually to our main apps. also it use to move between virtual clusters with kubectx. 

to install it:

git clone https://github.com/ahmetb/kubectx /opt/kubectx

chmod +x /opt/kubectx /opt/kubens

 cd /opt/kubectx/

 ls -l

 cp kubens /usr/local/bin/kubens


  cd -        - from now on we can use kubens command


kubens   - show all namespaces

kubens web-server  - get you into namespace web-server and change default to web-server

 kubens default   -  get you and change into default 


deploy and service should be on same namespace.



### practice 1 

write  voting app in k8s - python and node in nodeport mode - no need to .net to be svc other should be deploy and svc. like above example. postgres and redis you can wite in statefulset. app in deployment kind. (service - statefulset - deploy) 



https://github.com/dockersamples/example-voting-app/tree/main/k8s-specifications


1.28 k8s:
change restart policy - sidecare containers - no need to disable swap - mix version proxy ,...


# volumes

2 type of volumes: by container run times - by k8s (pv) 


## by container run time:

volumes mounts below container is in guest. volumes in below spec section is in host.
name is same in 2 sections. hostpath or emty directory. k8s is not order sensitive becaouse all yaml is compile once to gether. this mode is use in one replica cluster . in more than 1 replica we recommand to use pv and pvc.

            spec:
              containers:
              - image: k8s.gcr.io/test-webserver
                name: test-container
                volumeMounts:
                - mountPath: /app
                  name: cache-volume
              volumes:
              - name: cache-volume
                emptyDir: /tmp



or exapmle:

            spec:
              containers:
              - name: nginx-ctr
                image: nginx:latest
                ports:
                   - containerPort: 80
                volumeMounts:
                  - mountPath: /usr/share/nginx/html/
                    name: html-directory
                  - mountPath: /var/log/nginx/
                    name: nginx-log
              volumes:
                - name: html-directory
                  emptyDir: /root/html/
                - name: nginx-log
                  emptyDir: /root/log/
            


or exapmle add this lines to nginx deployment sample file:

                  spec:
                    containers:
                    - name: nginx-ctr
                      image: nginx:latest
                      ports:
                         - containerPort: 80
                      volumeMounts:
                        - mountPath: /usr/share/nginx/html/
                          name: html-directory
                        - mountPath: /var/log/nginx/
                          name: nginx-log
                    volumes:
                      - name: html-directory
                        hostPath:
                           path: /root/html/
                      - name: nginx-log
                        hostPath:
                           path: /root/log/



then make dir /root/html/ , /root/log/ in host 


when you get 403 forbidden then you should give permission to yhat directory: and path is maked in all worker node . then we should give permission to in all worker. and all pods not create on masters all created in worker then we make and give this permissions in all workers and its highly recommand to use nfs in this mode . by the way that this mode is not recommanded. we recommand to use pv and pvc. 

chmod 777 html log

chmod -R 777 html log   - in worker node

kubectl rollout restart deployment/nginx-deployment 




hint: image pull policy in CI/CD set to always because new image publish with tag latest can be downloaded every time to make new replica set.



## by persistent volumes

we can limit storage resource by pv , pvc.

### pv or persistent volumes 

k8s make pc to manage volume group. have many type to manage pvc np need to make it on worker manually. pv type is:

local - nfs - host - S3 amazone - blob store azure - ,...

k8s has nfs provisioner . 


Types of Persistent Volumes 
PersistentVolume types are implemented as plugins. Kubernetes currently supports the following plugins:

csi - Container Storage Interface (CSI)
fc - Fibre Channel (FC) storage
hostPath - HostPath volume (for single node testing only; WILL NOT WORK in a multi-node cluster; consider using local volume instead)
iscsi - iSCSI (SCSI over IP) storage
local - local storage devices mounted on nodes. ********recommanded
nfs - Network File System (NFS) storage ********recommanded



Different Types of PV’s Access Modes

readwriteonce - RWO  - can be mounte by a single node as read write to that nfs folder. when we have more than 1 replica we can not use this

read only many - ROX  - the volume can be mounted readonly by many nodes . use when we have mpre than 1 replica

readwrite many - RWX  -  the volume can be mounted read and write by many nodes  .use when we have mpre than 1 replica

read write once pod - RWOP  - can be mounte by a single pod as read write to that nfs folder. example: 1 folder that assign db and app and we want just app pod had accesst o write and read it.











### pvc or persistent volume claim

claim or request for volume or pv. works same as lv.






in linux we have logical volume manager or lvm. 

block storage is hard slot and phisical storage

volume group or vg is virtual storage  can not directly mounted that is  (to use in partion or lv) called object storage. ceph , swift , gluster ,.... to manage object storage .

logical volume or lv is linux partition create on vg. vg neef to create lv to be mounted.

file storage is file that can store the file like: iso file or docker file 


### practice 2

write below example for pv and pvc with nfs type.





example:

we can define pv, pvc in seperate yaml file. but in deply or service we should define pvc to claim pvc.


first define pv:

vi pv.yml


                  
                  apiVersion: v1
                  kind: PersistentVolume
                  metadata:
                    name: task-pv-volume
                    labels:
                      type: local
                  spec:
                    storageClassName: manual
                    capacity:
                      storage: 10Gi
                    accessModes:
                      - ReadWriteOnce
                    hostPath:
                      path: "/mnt/data"
                  


mkdir /mnt/data   - on specified node that is pv in file system mode. in nfs no need to make manually and this stage


kubectl apply -f pv.yml

kubectl get pv -o wide





vi pvc.yml

                  
                  apiVersion: v1
                  kind: PersistentVolumeClaim
                  metadata:
                    name: task-pv-claim
                  spec:
                    storageClassName: manual
                    accessModes:
                      - ReadWriteOnce
                    resources:
                      requests:
                        storage: 3Gi
                        
      
kubectl apply -f pvc.yml

kubectl get pvc -o wide
      
pv status from available change to bound . 

capacity show amount of space . not claim amount is storage we can limit it with limitstorage command in pvc.




vi pod-pv.yml

                  
                  apiVersion: v1
                  kind: Pod
                  metadata:
                    name: task-pv-pod
                  spec:
                    volumes:
                      - name: task-pv-storage
                        persistentVolumeClaim:
                          claimName: task-pv-claim
                    containers:
                      - name: task-pv-container
                        image: nginx
                        ports:
                          - containerPort: 80
                            name: "http-server"
                        volumeMounts:
                          - mountPath: "/usr/share/nginx/html"
                            name: task-pv-storage



kubectl apply -f pod-pv.yml



this in filesystem mode if pod server crashed then /mnt/data/ not exist on it unless you write node affinity to specified server that have it. then its best practice to use nfs in pvc. 





reclaim policy:

default is retain . retain is manually reclaimation. retain keeps data even if pvc or deployment is deleted. if we want we should delete manually. after delete pvc if we write pvc in same path we see that data again.

delete used in cloud storage like aws , azure ,...

recycle used when pvc deleted its data will deleted with (rm -rf )


volume mode:

is in default filesystem(local) if you need change it for nfs,......



storage class:

every pv is can have class that specified with calss name. is a something like label that we call that ov with that name. we can call in pvc's storage class name or with name of that pv. is about make group with multiple pv to allocate one of that group of pv by k8s. 







PV amount is base on TiB , GiB ,MiB . *1024 count. gibibyte tibibyte mibibyte,..

TB ,GB is *1000 .

pv is on host and pvc on guest.



volume type best practice is : host path - config map - pvc






nfs config on master we should od it manually . 





 





















