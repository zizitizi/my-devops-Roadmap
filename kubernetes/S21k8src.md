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

minReadySeconds :10s 

   strategy :

      type: rollingUpdate

      rollingUpdate:

         maxUnavailable: 1

         maxSurge: 1


image: to wich version


kubectl apply -f deploy.yml



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



                       - to rollout undo or rollback to specified version


 










 









 























