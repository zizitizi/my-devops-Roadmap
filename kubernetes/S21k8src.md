### important note to initialize

if k8s initiate succefully but can not create pods it means in sufficent resource (commonly ram)- cpu or disk.

after initiate k8s to prevent refused connection (kubectl can not find kubeconfig file) we should write export config command to bash.bashrc file in last line to make it persist. same as alias (ex. :alias ll="ls -l") to be persist we should write alias in that file. 

every user in linux have hidden file like : .bashrc ,.. that runs in startup and login time. for that related user. but if one config set in /etc/bash.bashrc
it will be permanet for all user and runs on system strtup for all. 

you can do this: 

vi /etc/bash.bashrc   - add below line at the ends.

export KUBECONFIG=/etc/kubernetes/admin.conf


or 

echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/bash.bashrc

but k8s tells:

in user root:

vi ~/.bashrc  - add below line at the ends.

      export KUBECONFIG=/etc/kubernetes/admin.conf


or

      echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bashrc


for other user than root add below line to that file:

      mkdir -p $HOME/.kube
      sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      sudo chown $(id -u):$(id -g) $HOME/.kube/config



or another way:

in root: cd ~/.kube

cp /etc/kubernetes/admin.conf ./conf

if we have this file in our laptop and can ping master then you can use kubectl from your laptop no need to login to master.


if kubectl did not work correctly it means cluster is not ruuning and api server is down. if it works we can get system pods and its describes.

also we can check kubelet daemon for errors in all nodes:

systemctl status kubelet.service  - becarefull about restart this service then cluster will be reset .


you can practice in site . play with k8s:

https://labs.play-with-k8s.com

but becarefull about:
                          WARNING!!!!

 This is a sandbox environment. Using personal credentials
 is HIGHLY! discouraged. Any consequences of doing so, are
 completely the user's responsibilites.

 You can bootstrap a cluster as follows:

 1. Initializes cluster master node:

 kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16


 2. Initialize cluster networking:

 kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml


 3. (Optional) Create an nginx deployment:

 kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/nginx-app.yaml

it uses kuberouter not flannel.

alt+enter  ---> make window max and min.



other example site:


https://k8s-examples.container-solutions.com/examples/Pod/Pod.html



dns for master and worker should be same and no more than 2 for ex.:

8.8.8.8

9.9.9.9




kubectl get pods -A -o name


kubectl get pods -A -o wide| (sed -u 1q; sort -k2)   - you can get ip



kubectl get pods -o yaml

***kubectl get pods nginx-pod -o yaml -n staging***  --- its very important . you can see yaml file of running file we you have not source yaml file . copy that yaml to vscode and cutout optional parameter to make it simple. for ex.:

apiversions - items - first can be deleted

annotation - can be deleted 

resoure version - uuid -- timestamp -- can be deleted

image pull policy : always   - its default is ifnotpresent . we can delet it

protocol - witch node - we can delete it


preemption policy  - its for priority- by default is up to down . used in give priority to database and app. to use we sould define priority class.





 kubectl apply -f podnginx2.yml --v 2   - its for before that running pod. its for creating stage for debug



# # replication controller (rc)

replication controller is one of objects (resource) in k8s. it called rc. but its deprecated now. we wite kind: ReplicationController

we it when we want replica in k8s.  1 pod == 1 container and we can not scale it. when we want loadbalance =5 then we use rc.

we can use multiple replica set in one rc but its not recomanded. we one rc for one app. one rc is better than a pod. couse its scalable but pod not. 

be carefull in real world after version 1.21 and production environmet in practice not use pod nor rc we just use deployment . in place of pod we use 1 pod deployment. but some organization still use old version of k8s 1.20 and older. then they use rc instead of deployment.
in yml file we use kind rc and replicas number in spec also selector , and template. we define pods in template section that include spec and metadata. in spec of template label is mandatory to specify that app. note that we dont have name in template. selector section is exactly same as lable section. 



example for our pod in rc:

vi rc.yml

apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx-rc
spec:
  replicas: 5
  selector:
    app: nginx
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



kubectl delete pods nginx-pod -n staging


kubectl apply -f rc.yml


kubectl get rc -o wide

kubectl get pods -o wide



we can ping all pod and curl all that pod ip.

curl 10.244.3.5

ping 10.244.3.5


till now we dont have load balancer. we define it in networking section. you can check it with:

kubectl get svc -o wide


 kubectl describe rc nginx-rc

kubectl logs -f nginx-rc-rvfnr   - log of one of rc's

to exec to rc we use:

kubectl exec -it rc/nginx-rc -- bash      - that take in one of rc pods first pod of list (naming).

to exec to specified pod of rc :

kubectl exec -it nginx-rc-jxf26 -- bash

to increase or decrease replicas. we have 2 option : by kubectl commnad by editing source yaml file.

 kubectl scale --replicas 8 rc/nginx-rc

kubectl get rc -o wide


or by edit above file replicas section.

kubectl get rc -o wide

kubectl cp test.txt nginx-rc-4tnr2:/tmp/test.txt


# # deployment

we called deploy. 


interview: what is difference between rc and deply:

replica set in deployment means a specified version of application. when we chande image version of app in template in yaml file , k8s shoutdown older deploy replica set and runs deploy with new replicaset (version of app (image)) . if new app have a bug then we manually shoutdown new replicaset and runs old shutdowned replica set. deploy rollback feature is very usefull. we dont hane rollout undo or replicaset in this means in rc.


in rc we have just rollout update . but in deploy we have rollback(rollout undo).
 
in rc we do with kubectl command rollout update that delete old version (not shutdown it) and replace it. it make app from scratch again. it means it works rolling-update == apply command.

kubectl rolling-update -f rc.yaml



in deployment we can revision in replicaset.


versioning system in this replicaset is same as docker and git.


in deployment apiversion change to : apps/v1  - kind is Deployment  - in selector we have matchLabels:.



vi deploy.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  labels:
    app: nginx
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx
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



 kubectl apply -f deploy.yaml


  kubectl delete rc nginx-rc


kubectl get deploy -o wide


kubectl get pods -o wide


we can ping curl all pod with its ip.


kubectl get deploy -o wide


 kubectl get rs -o wide   - replicaset

 kubectl get pods -o wide

kubectl describe deployments.apps nginx-deploy


#### updating a deployment

1- via edit yml source file. vi deploy.yml and apply . then we should set some parameters:

vi deploy.yml

minReadySeconds :10s   - if our pod takes loger time to be ready we should increase it. its time to k8s wait to run one pod to ready then go to another pod

   strategy :

      type: rollingUpdate

      rollingUpdate:

         maxUnavailable: 1   - let k8s to be decrease 1 replica from desired state ( here 3/4 allowed but 2/4 not allowed)

         maxSurge: 1   - let k8s to be increase 1 replica from desired state( for ex.: 5/4 allowed - but 6/4 not allowed when its 1)


image: nginx:1.16.1 to wich version



then for ex:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  labels:
    app: nginx
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx

  minReadySeconds: 10
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1

  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx-container
        image: nginx:1.16.1
        ports:
        - containerPort: 80





kubectl apply -f deploy.yml



kubectl rollout status deployment/nginx-deploy

kubectl rollout history deployment/nginx-deploy


kubectl annotate deployments.apps/nginx-deploy kubernetes.io/change-cause='image update to version 1.16.1'


kubectl get rs -o wide


to increase replica again:

kubectl scale deployment/nginx-deploy --replicas 5   - or in yaml file and apply

kubectl get rs -o wide



when our pods nomber is high (for ex. 100) than we can set max surge and max unavailable to 5 than k8s update replica to new one 5 by 5 and wait for all 5 , 10s then down old version and go to next 5 no. to update (it works like: 45/50  - 55/50 ) . 



2- via kubectl set image command . this commadn make rollout . 

kubectl set image deploy/nginx-deploy nginx-container=nginx:1.14   - k8s change version one by one. after first running with  new version  then shutdown older one then waits for 10 s then runs second after run shotdown old one then wait 10s  ,.....  ( it make 4/4 --> 5/4 --->4/4 ---->5/4 ,....)


kubectl rollout status deployment/nginx-deploy  -  we see this report just one time when its updated.  to see history use history command
                  
                  Waiting for deployment "nginx-deploy" rollout to finish: 2 out of 4 new replicas have been updated...
                  Waiting for deployment "nginx-deploy" rollout to finish: 2 out of 4 new replicas have been updated...
                  Waiting for deployment "nginx-deploy" rollout to finish: 2 out of 4 new replicas have been updated...
                  Waiting for deployment "nginx-deploy" rollout to finish: 3 out of 4 new replicas have been updated...
                  Waiting for deployment "nginx-deploy" rollout to finish: 3 out of 4 new replicas have been updated...
                  Waiting for deployment "nginx-deploy" rollout to finish: 3 out of 4 new replicas have been updated...
                  Waiting for deployment "nginx-deploy" rollout to finish: 3 out of 4 new replicas have been updated...
                  Waiting for deployment "nginx-deploy" rollout to finish: 1 old replicas are pending termination...
                  Waiting for deployment "nginx-deploy" rollout to finish: 3 out of 4 new replicas have been updated...
                  Waiting for deployment "nginx-deploy" rollout to finish: 1 old replicas are pending termination...
                  Waiting for deployment "nginx-deploy" rollout to finish: 1 old replicas are pending termination...
                  Waiting for deployment "nginx-deploy" rollout to finish: 1 old replicas are pending termination...
                  Waiting for deployment "nginx-deploy" rollout to finish: 1 old replicas are pending termination...
                  Waiting for deployment "nginx-deploy" rollout to finish: 3 of 4 updated replicas are available...
                  deployment "nginx-deploy" successfully rolled out







kubectl get rs -o wide



#### for rollout undo:


kubectl rollout history deployment/nginx-deploy   - to write CHANGE-CAUSE , write annotations. use it as below in current version:

kubectl annotate deployment/nginx-deploy kubernetes.io/change-cause='image update to version 1.14'

kubectl rollout history deployment/nginx-deploy


roolback == rollout undo:


if we have revisions:
1-2-3-4-5-6   - then we want go fron 6 to 3. then k8s make new vaersion 7(=3) then delete revision 3 from list: 1-2-4-5-6-7

 kubectl get deployments.apps nginx-deploy -o wide

 kubectl get rs -o wide

 kubectl rollout undo deployment/nginx-deploy   - rollback to before version


 kubectl annotate deployments/nginx-deploy kubernetes.io/change-cause='rollout undo to latest'


 kubectl rollout history deployment/nginx-deploy



kubectl rollout undo deployment/nginx-deploy --to-revision=2      - to rollout undo or rollback to specified version

kubectl rollout pause deployment/nginx-deploy   - pause the rollout 

kubectl rollout resume deployment/nginx-deploy
 


if rollout version rs is exist then switch between that version is quickly and on the fly but if that revision is not available it takes some times to be updated.



## hoizontal pos auto scaler (hpa)

total usage of cpu in all worker if reached to specified amount then decrease replica amount.

 kubectl autoscale deployment/nginx-deploy --min 8 --max 12 --cpu-percent 60


kubectl get deploy -o wide

kubectl get rs -o wide

kubectl get hpa -o wide



### cordon - drain

when we have maintenance mode in one node that may be affect pods. than we use cordon mode that means unschedulable mode. then kube scheduler do not schedule that node . its stands for new pods did not assign to cordon node but its pod still keep in ruuning mode. we use it when maintenace dont need reboot.

 kubectl cordon zizi-pc3  - unsceduled and cordoned  


 kubectl get nodes

kubectl uncordon zizi-pc3

  kubectl get nodes



drain mode is same as cordon but make all pod on that node down and move its pod to other pods. it use in maintenace mode that node needs reboot

kubectl drain zizi-pc3  --ignore-daemonsets   

kubectl uncordon zizi-pc3   - for undrain we should uncordon we have not undrain commnand - but if new command or pod goes here not ruuning pods.



kubectl get all   - check everything and get everything


to restart pod or k8s we just have rollout . its one of reasons we use 1deployment with 1replica instead of 1pod or rc.


 kubectl rollout restart deployment/nginx-deploy


kubectl get all -o wide


kubectl delete rs/nginx-deploy-5b846f99f4


kubectl cluster-info   - read kube config

 kubectl cluster-info dump


kubectl cluster-info dump --output-directory /tmp   - backup to /tmp. its from every log every info in cluster make it interval backup please 



use backup solution to keep cluster safety. kasten (veeam) is free for 5 node. 1 master 4 worker. velero is free and open source but more complicated that kastern. velero can run in vm or in a container. 


****deployment prones:**** rollout update- roolout undo  - rollout restart (prevent downtime) - hpa - replica ,....

***deploymnet generation:*** all below have same yaml find but differ in kind options.

***1- deploymnet***  - we have replica option as we want any nomber of replica

***2- DaemonSet or ds***   - k8s make relica per node automatically on each node. 1 pod = 1 node(in). used when we want an app to be run in each agent like daemon for ex.: monitoring app agnet that need to be run on each node silently. when we install monitoring app -nms- ( prometeus , zabix ,...) ,k8s runs a gagent on each node automaticall no need to run it manually. also kubeproxy - kube flanell is a daemonset. ds just runs on worker node , to run on masters use taint options. to see daemonset run: 

kubectl get ds -A -o wide


example:

kubectl delete deploy/nginx-deploy

vi ds.yml

                  
                  apiVersion: apps/v1
                  kind: DaemonSet
                  metadata:
                    name: nginx-ds
                    labels:
                      app: nginx
                  spec:
                    #replicas: 4
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
                          image: nginx:1.16.1
                          ports:
                          - containerPort: 80
                  

kubectl apply -f deploy.yaml

kubectl get ds -o wide

kubectl get pods -o wide

***3- StatefulSet***  - that run app in stateful mode like: db ,... 


 
app is in 2 type : 

1- statful  - that is connection less - send request to app and get response. no need permanet connection - http - https - api gateways ,....
when we open http google webpage we send request to google weserver it reurn us a response and we opens http web page if connection lost till we send new request like reftresh page ,... page is ready for us.


2- stateless  - that is connection based - app is run till connection is stablished. when connection lost app is closed - ssh - db ,....
when we lost connection we cant ssh. or when we lost connection we can not query or.. to db. 


daemonset and deployment is stateless . statefulSet is ftateful and use to run db (ex.: mongo , mysql ,...)

note that we can run db in deploy but may encountered a problem in future. 



****note:****
K8s have many resouce api, but you should know below resource thats more important. other resource is not main and you can wite cron jos set password ,... for them:

pods - replication controller - deployments - deamonsets - statefulset - services - pv - pvc








 























