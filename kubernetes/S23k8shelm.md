
### pv pvc common model:

- nfs : no need to do it on each worker manually. nfs provisioner make all provisioned on each worker
- file system  - need to make file system manually on each worker
- ceph





#### nfs sample step by step and yaml code:


***1- make install nfs server on master:***

apt update

apt install nfs-kernel-server  - and make config it based on best practice


***2- make install nfs common on each worker:***

apt update

apt install nfs-common


***3- create yaml file for pv:***

vi pv-nfs.yml

        
        apiVersion: v1
        kind: PersistentVolume
        metadata:
          name: nfs-pv-ali
        spec:
          capacity:
             storage: 200Mi
          volumeMode: Filesystem
          accessModes:
             - ReadWriteMany
          persistentVolumeReclaimPolicy: Recycle
          storageClassName: nfs
          mountOptions:
            - hard
            - nfsvers=4.1
          nfs:
            path: /data
            server: 192.168.44.136
        
        


 kubectl apply -f pv-nfs.yml

 

make sample pod (nginx) to claim pvc:

vi nginxnfs.yml


                        apiVersion: v1
                        kind: Deployment
                        namespace: default
                        metadata:
                          name: nginx-deploy
                          namespace: default
                          labels:
                            app: nginx
                        spec:
                          replicas: 2
                          selector:
                             matchLabels:
                                app: nginx
                          template:
                             metadata:
                                 labels:
                                    app: nginx
                             spec:
                                containers:
                                     - name: nginx-ctr
                                       image: nginx:latest
                                       ports:
                                          - containerPort: 80
                                       volumeMounts:
                                          - mountsPath: "/usr/share/nginx/html"
                                            name: nginx-pv-storage
                          volumes:
                            - name: nginx-pv-stroage
                              persistentVolumeClaim:
                                  claimName: nfs-pvc
                        






in cloud network that include pool storage you can use ceph instead of nfs. its provisioner too.

to do senario in production first test it in your test environment. that how your config works.


cloud native computing foundation site:


cncf.io


refrence for uptodate devops tool is:


landscape.cncf.io


for example in container registery: nowday harbor is famous than nexus.


cncf graduated means that have cncf license and supervision it.


also site:

roadmap.sh/devops




to apply multiple resource we have 2 options:

1- write all resource in 1 yaml file and seperate them with 3dash role (---) 

2- write each resource separate yaml file store in one directory and apply -f thatdirectory:

kubectl apply -f relatedyamlresourcedirectory/  - apply all in once



#### create ns

1- kubectl create namespace test

2- in yaml file with kind Namespace and name and label in metadata

3- in apply command: kubectl apply -f tets.yaml -n test   - make ns test if not available

4- in kubens   - same as above



kubectl get all  - show all resource

kubectl delete all --all   - delete everything make your k8s clear. its for your test environments


# resource request and limit

request= reserve. in principle is pod base but bestpractice is that we can define resource limit for namespace to aviod forgetiing do it for each container . for  memory and cpu . in spec section of container definitions. its apply by containerruntime. 

note that cpu unit in k8s is milicore. 500m=0.5core. 1000m = 1 core

                        resources:
                           limits:
                               memory: "200Mi"
                               cpu: "200m"
                           requests:
                               memory: "100Mi"
                               cpu: "1000m"






before make desicion to choose write plan or senario for cluster you should do t on test environmet and load test software and send virtual terafic on them then if one resource use 75% you should expand that resource. this test reaulary design and do by QA or test team. never leave your resource (docker- copose swarm - k8s,..) without limit its necessary to assign limit to all your resource to prevent lack of your resource in abnormal posiotion. for ex.: ddos attack , abnrnaml function of app, or bad developed software ,..... .  to prevent affect server resource. our server should not affect never. load testing tools are like: k6s (ex.:define time increase load in 30 interval)


resources return multiple actions again suddenly increase load or step by step increasing load. may crash on suddenly increase (for ex.: webinar in specifed time all user login)








# resource quota:

define resource quota like below (for ex. for harware) and then called in pod or deployment or namespace. 



apiVersion: v1
kind: ResourceQuota
metadata:
  name: demo
spec:
  hard:
    requests.cpu: 500m
    requests.memory: 100Mib
    limits.cpu: 700m
    limits.memory: 500Mib




quota description:

https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/quota-pod-namespace/


kubectl create namespace quota-pod-example


apiVersion: v1
kind: ResourceQuota
metadata:
  name: pod-demo
spec:
  hard:
    pods: "2"




kubectl apply -f https://k8s.io/examples/admin/resource/quota-pod.yaml --namespace=quota-pod-example



apiVersion: apps/v1
kind: Deployment
metadata:
  name: pod-quota-demo
spec:
  selector:
    matchLabels:
      purpose: quota-demo
  replicas: 3
  template:
    metadata:
      labels:
        purpose: quota-demo
    spec:
      containers:
      - name: pod-quota-demo
        image: nginx
    

kubectl apply -f https://k8s.io/examples/admin/resource/quota-pod-deployment.yaml --namespace=quota-pod-example

kubectl get deployment pod-quota-demo --namespace=quota-pod-example --output=yaml



The output shows that even though the Deployment specifies three replicas, only two Pods were created because of the quota you defined earlier:

spec:
  ...
  replicas: 3
...
status:
  availableReplicas: 2
...
lastUpdateTime: 2021-04-02T20:57:05Z
    message: 'unable to create pods: pods "pod-quota-demo-1650323038-" is forbidden:
      exceeded quota: pod-demo, requested: pods=1, used: pods=2, limited: pods=2'




you can assign namespace for resource quota in apply commadn or  in resource quota definition yaml file. after that all resource that bond to that namespace have resource quota.




kubectl delete namespace quota-pod-example





# limitRange

its another limit resource in k8s that defined with in kind: LimitRange

By default, containers run with unbounded compute resources on a Kubernetes cluster. Using Kubernetes resource quotas, administrators (also termed cluster operators) can restrict consumption and creation of cluster resources (such as CPU time, memory, and persistent storage) within a specified namespace. Within a namespace, a Pod can consume as much CPU and memory as is allowed by the ResourceQuotas that apply to that namespace.

A LimitRange is a policy to constrain the resource allocations (limits and requests) that you can specify for each applicable object kind (such as Pod or PersistentVolumeClaim) in a namespace.

A LimitRange provides constraints that can:

 - Enforce minimum and maximum compute resources usage per Pod or Container in a namespace.
 - Enforce minimum and maximum storage request per PersistentVolumeClaim in a namespace.
 - Enforce a ratio between request and limit for a resource in a namespace.
 - Set default request/limit for compute resources in a namespace and automatically inject them to Containers at runtime.


A LimitRange is enforced in a particular namespace when there is a LimitRange object in that namespace.

The name of a LimitRange object must be a valid DNS subdomain name.



                        apiVersion: v1
                        kind: LimitRange
                        metadata:
                          name: mem-limit-range
                        spec:
                          limits:
                          - default:
                              memory: 512Mi
                            defaultRequest:
                              memory: 256Mi
                            type: Container
                        




# cron job

similar to linux. schedule a job as a container. dont write restart policy : always becouse it restarted every interval 1sec or 2sec even after exit(0). let it be restartPolicy: onFailure . A CronJob creates Jobs on a repeating schedule.

CronJob is meant for performing regular scheduled actions such as backups, report generation, and so on. also you be able to set timezone for your cron job other than aerver or laptop time zone.

cron job api version is batch/v1 to see k8s resources api versions run:

kubectl get apiservices.apiregistration.k8s.io


 vi cronjob.yaml



                        apiVersion: batch/v1
                        kind: CronJob
                        metadata:
                          name: hello
                        spec:
                          schedule: "*/1 * * * *"
                          jobTemplate:
                            spec:
                              template:
                                spec:
                                  containers:
                                  - name: hello
                                    image: busybox
                                    args:
                                    - /bin/sh
                                    - -c
                                    - date; echo Hello from the Kubernetes cluster
                                  restartPolicy: OnFailure
                                  
          
          
kubectl apply -f cronjob.yaml


kubectl get jobs.batch hello-28223640


 kubectl get jobs.batch




 # config map

 is a type of volume. 




 To store a configuration file made of key value pairs, or simply to store a generic file you can use a so-called config map and mount it inside a Pod:


kubectl create configmap velocity --from-file=index.html



The mount looks like this:
...
spec:
  containers:
  - image: busybox
...
    volumeMounts:
    - mountPath: /velocity
      name: test
    name: busybox
  volumes:
  - name: test
    configMap:
      name: velocity




volume type:

1- mounthpath - host path - empty directory   - dorectory sharing

2- pv (local -nfs - ceph) - pvc   - directory sharing

3- config map: just for file (config file) not sharing  dorectory


for ex. : we wnat to run gitlab as pod then we prepare config file for gitlab called gitlab.rb then after gitlab pod running copy this file to pod.


we can specified config ap with command or in yaml file. even we can tell to config map to write content in that file write from pod yaml file in with | command like below:

                        ---
                        # https://kubernetes.io/docs/concepts/storage/volumes/#configmap
                        apiVersion: v1
                        kind: Pod
                        metadata:
                          name: volumes-configmap-pod
                        spec:
                          containers:
                            - command:
                                - sleep
                                - "3600"
                              image: busybox
                              name: volumes-configmap-pod-container
                              volumeMounts:
                                - name: volumes-configmap-volume
                                  mountPath: /etc/config
                          volumes:
                            - name: volumes-configmap-volume
                              configMap:
                                name: volumes-configmap-configmap
                                items:
                                  - key: game.properties
                                    path: configmap-volume-path
                        ---
                        apiVersion: v1
                        kind: ConfigMap
                        metadata:
                          name: volumes-configmap-configmap
                        data:
                          game.properties: |
                            enemies=aliens
                            lives=3
                            enemies.cheat=true
                            enemies.cheat.level=noGoodRotten
                          ui.properties: |
                            color.good=purple
                            color.bad=yellow
                        
                            



kubectl apply -f configmap.yml

kubectl get configmaps


to see config map:

 kubectl exec -it volumes-configmap-pod -- sh

 cd /etc/config

 ls -l

                        lrwxrwxrwx    1 root     root            28 Aug 30 18:15 configmap-volume-path -> ..data/configmap-volume-path


 cat configmap-volume-path

                        
                        enemies=aliens
                        lives=3
                        enemies.cheat=true
                        enemies.cheat.level=noGoodRotten
                        


***hint: one another way ot get yaml file of one resource is below command:


kubectl edit pods nginxpod


# init-containers

one of senario that include multiple container in a pod. 

- main container and sidecar containers. nginx + nginx logger
- shared volume - proxy - bridge -adapters ,...
- shred folder for 2 container one of them read dir another write to it.
- init container is for preconfiguration and prepration for main container. for ex.: flannel daemon set .  we have 3 container in its yaml file . 2 of them is init containers that all prepration containers do their job after completed be deleted. then main container running.


 in version 1.28 k8s we can plan restart policy seprate from main container. also we can leave swap enable in k8s installations.



                        apiVersion: v1
                        kind: Pod
                        metadata:
                          name: git-repo-demo
                        spec:
                          initContainers:
                          - name: git-clone
                            image: alpine/git # Any image with git will do
                            args:
                              - clone
                              - --single-branch
                              - --
                              - https://github.com/kubernetes/kubernetes # Your repo
                              - /repo
                            volumeMounts:
                            - name: git-repo
                              mountPath: /repo
                          containers:
                            - name: busybox
                              image: busybox
                              args: ['sleep', '100000'] # Do nothing
                              volumeMounts:
                                - name: git-repo
                                  mountPath: /repo
                          volumes:
                            - name: git-repo
                              emptyDir: {}
                        





 ***UPGRADE HINT*** 
 
 solution 1 - to upgrade k8s one of senario is push your worker one by one in drain mode then upgrade it then undrain it. after finish all workers one of masters take in drain mode upgrade it and do same for next masters till all nodes upgrade. 


solutioln 2- create cluster similar to main cluster with upgraded k8s and move resource to new cluster then down older one. 


# probes

3 type of probe we have in pods containers:

1- readiness: k8s just run pods but maybe its containers like: mysql db not running yet its depends to container runtime with this command we tell to k8s to wait to caontainer to be ready. and to know when to send traffic to it. wait 30 sec. after running pod with one command tell to check if ctr is ready. for example in mysql send a connection or a query to it to get response. best practice and commonly used to db pods check.

2- startup :Startup probes are useful for delaying liveness probes until the container has successfully started. delay for example for 20 sec if ok go to check liveness probe. its initialDelaySeconds . not use in best practice.


3- liveness: check pod heatliness . in some case we had pod running but its service failed. ex.: curl nginxip  --> refused but its pod running, then touch a file or curl localhost to check its healthyness. if not ok liveness reset the container. best practice: tell the developer to create directory like: http://localhost:8080/health-check that if not accessible then reset container . period second: wait for it. in 35 sec reset the pod if not ok.

                        spec:
                          containers:
                          - name: liveness
                            image: k8s.gcr.io/busybox
                            args:
                            - /bin/sh
                            - -c
                            - touch /tmp/healthy; sleep 30; rm -rf /tmp/healthy; sleep 600
                            livenessProbe:
                              exec:
                                command:
                                - cat
                                - /tmp/healthy
                              initialDelaySeconds: 5
                              periodSeconds: 5






# SecurityContext for a Pod/Container

if you are not attend of use ad user root in pod use user id and group id ( make that users and group before hand in linux and image): runAsUser , runAsGroup




                apiVersion: v1
                kind: Pod
                metadata:
                  name: security-context-demo
                spec:
                  securityContext:
                    runAsUser: 1000
                    runAsGroup: 3000
                  volumes:
                  - name: sec-ctx-vol
                    emptyDir: {}
                  containers:
                  - name: sec-ctx-demo
                    image: busybox:1.28
                    command: [ "sh", "-c", "sleep 1h" ]
                    volumeMounts:
                    - name: sec-ctx-vol
                      mountPath: /data/demo
                    securityContext:
                      allowPrivilegeEscalation: true






# Helm

In simple terms, Helm is a package manager for Kubernetes. every package have helm chart we should write it for our package. just like dockerhub or other repo we have artifacthub include k8s helm package. helm repo include bitnami package that is very secure and best practice for example to install mysql in k8s we install it by helm and its bitnami package.



1- helm repo add : http ,..

2- helm repo update

3- helm install gitlab   - install gitlab on k8s - in this package is a helm chart include pv , pvc , daemon set , svc , db ,.. all this that gitlab require . 

for another example prometeus has many svc requirement( like: prom ,pv, pvc, svc - alert manager svc - grafana svc - push gateway svc - node exporter svc ,...) that require thier pod to be up. now just with helm packag manager we install and uninstall it easily. just with rum:

helm install prometeus-stack

helm uninstall prometeus-stack



yaml file in k8s call manifest file. to change clusterip in svc of installed package just edit its yaml file to node porter. or to change pv from local to nfs. helm chart is not yaml file alittle different. use below site:


helm.sh 


install helm from script:

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 get_helm.sh

./get_helm.sh


helm version




for exaple for write rating app we need many manifest(70 no. yaml) file: mysql - app-rating - app-charging - api-server - redis - worker. but for this purpose we write helm chart (600 line) just like dockerhub account, we make artifacthub account (or nexus or harbor for private) and push our helm chart to helm repo. and pull it whenever we need it. 


also for exampe for voting app example we can download postgres and redis from helm and for vote and result write helm chart. or wite stack for it. its best practice.


to search for package use helm repo:

https://artifacthub.io/



search for package or its stack. pay attention to rate of app and owner of it. to install it use instruction.


for example to install prometeus use kube-prometheus-stack search : use image from prometheus.

hit install . then:



docker login

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo list

helm repo update


helm install my-kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 49.2.0

 helm uninstall my-kube-prometheus-stack



or for kubernetes-dashboard use helm like above to install it on specified name space use -n options or kubens tools:

helm repo add k8s-dashboard https://kubernetes.github.io/dashboard

helm install my-kubernetes-dashboard k8s-dashboard/kubernetes-dashboard --version 7.0.0-alpha0


kubectl get all

to change clusterip to nodeport to see main dashboard expose nginx controller port and deployment of it with leave empty nodeport-port to assign automatically( we dont modify or delete or change svc nginx just add our svc with command):

kubectl expose deploy/nginxpodname --name kubect-expose --type NodePort --port 80 --target-port 80 

kubectl get all   - to see port

curl localhost:31665




helm svc commonly use clusterip. couse your external port should be specified. then no need to delete helm svc. just make our new svc and point that pod selector to our svc (nodeport). to acces that helm svc yaml file use kubctl edit commmand or -o yaml  option or best practice that if we want just nodeport svc use:

kubectl expose --type NodePort specifiedpodname --target-port=8080  ,........


you can use k8s playground to test helm ,... k8s apps.


foloow instauction


yum install openssl





to active completion same as kubectl, kubelet do:

helm completion bash > /etc/bash_completion.d/helm

bash -l




note: to active status bar in mobaexterm in tab (ssh session browser) scp or ftp click on remote monitoring. 



note: kubespary is only way to install offline k8s in datacenters.



note:to free hard disk:

free -h   - view chached size

df -Th   - stage 


 ls -l /proc/sys/vm/drop_caches

if we echo 1 to above (drop_caches) file : deletes inodes

echo 1 > /proc/sys/vm/drop_caches

if we echo 2 to above (drop_caches) file : deletes dirty file and entereis of ram

echo 2 > /proc/sys/vm/drop_caches

if we echo 3 to above (drop_caches) file : deletes everything in ram dirty file page file entry ,cach ,.... if we have open app that use ram it will be drop and crash. never use it in production server. sometime use 1 or 2 in crontab 12 pm to free mem. use 3 just in test or your vm. 


echo 3 > /proc/sys/vm/drop_caches


to free hard read log file for unused services

use also in crontab to 12pm every night :

docker system prune


#### practice :

change k8s image registery. that is dockerhub change it to other. use image pull secret to where to authenticate and download image.





  
  
