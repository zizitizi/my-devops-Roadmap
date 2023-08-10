
kaddi is simple reverse proxy

# k8s provisioner - kubeadm installing


kind and k3s is dual node - minikube is single node for labs. kubeadm in powerfull and generall version.



***practice interview for SRE job position:***

for storage as service IaaS (infra as a service) that is k8s HA cluster (it means master is more than 3 node with rule (2n+1) and worker is 3 -4 ,....) . redis install on cluster with replication.

- backup from cluster intervally

- log for cluster and service keep on elastic search ( that is log analyser)

- docker registery private - registery or nexus

- clister monitoring with grafana - prometeus

- installation process automate (ansible)

write documantation in word and code this prepare demo in github. arcitecture in drow.io 


# kubeadm v1.27.4

4 is minor version and 27 is major version. in major version change many feature change its important. keep yourself uptodate in k8s documentation.

it has 4 section to install it.

## 1-Disable swap on all the nodes:

swap memory is virtual memory that make memory file in hard ssd or ... when ram will be full os use that partition from HDD as memory.

swap prevent server from reboot to free memroy and crash serve after 30 min.

k8s to prevent lake of performance force to disable swap to installing its module.

swapon -a    - make all swap on all parition on all harddisk on

swapoff -a    - make all swap off all parition on all harddisk off

swapon -s    - status of swap.

above command make change temporary to make it persist we should write it in fstab file. fiel system table file.

for automate this write action to fstab we use sed command.

cat /etc/fstab


#/etc/fstab: static file system information.
#Use 'blkid' to print the universally unique identifier for a
#device; this may be used with UUID= as a more robust way to name devices
#that works even if disks are added and removed. See fstab(5).
#<file system> <mount point>   <type>  <options>       <dump>  <pass>
#/ was on /dev/sda3 during installation
UUID=195b38d8-a72d-441e-9e90-11725d5446b5 /               ext4    errors=remount-ro 0       1
#/boot/efi was on /dev/sda2 during installation
UUID=9DD4-5FBA  /boot/efi       vfat    umask=0077      0       1
/swapfile                                 none            swap    sw              0       0
/dev/fd0        /media/floppy0  auto    rw,user,noauto,exec,utf8 0       0

first line is uuid hardisk 1 that is mount to partition / in format ext4 

in configuration file we never delet line just comment it.


sed 's/firstword/secondword/g' /etc/fstab  - in that file find firstword then replace with secondword

sed '2,6s/firstword/secondword/g' /etc/fstab   -  in line 2 to 6 of that file find firstword then replace with secondword

sed 'rain/s/firstword/secondword/g' /etc/fstab   -  in line that include rain in that file find firstword then replace with secondword


use \ to scape charachter. use -i for make it replace file make it persist


sudo sed -i '/swap/s/^\//\#\//g' /etc/fstab

then press :

sudo swapoff -a

to disable it.

do all above procedure in all node master and worker.


## 2- install container runtime in all node:

k8s supports CRIO - containerd - cri-dockerd mirantis.

every experts just use containerd.io that is best practice. io is complete pakage with all tools . then we install containerd.io on all node mastera and worker. nowdays we dont use containerd instead we use containerd.io v1.6 and higher for k8s 1.27 . we install it from docker-ce repository.


sudo apt-get update; sudo apt-get install ca-certificates curl gnupg -y

sudo apt install containerd.io

 containerd --version

su -

containerd config default > /etc/containerd/config.toml

containerd config include all config and write them in that file



## 3- change config in containerd on all node:

To use the systemd cgroup driver in containerd with runc. 

linux to manage resources (HW,SW) and isolated grup of process use namespace by cgruop (control group) module. we just see and manage namespace (ns). linux automatically use cgroups to. cgroup is kernel module is bg of ns in os module. k8s force all related container runtimes to use its linux cgroup not them cgroup. then we shold change cgroup in containerd to use linux cgroup not containerd cgroups. it means in config file SystemdCgroup = true. then :

vi /etc/containerd/config.toml  or best practice is use sed instead:


sed -E -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml


systemctl daemon-reload

systemctl restart containerd.service


systemctl status containerd.service

## 4- Install kubeadm, kubelet & kubectl on all nodes:


#### kernel module 

kernel include modules hw and sw ro comniucate with hardware

monolithic kernel supports all harware and load it

none monolithic or mikro kernel not include all driver = windows

linux is hybrid kernel cause linux scan your hw and install on your hard. we can load or unload modules in linux

kernel.org have kernerl release.

too see kernel file 

cd /boot/

ls -lh

vmlinuz-5.19.0-50-generic is kernel module. 12 m. 

lsmod   - list of module

lsmod|wc -l   - count of list of module

insmod  - insert mod in module but we need to add dependency manually. its too dificult ( works same ast dkpg)

modeprobe   -  module prober but we do not need to add dependency manually. its automaticaly and easy and recommanded ( works same ast apt)

delmod  -  delete module

to install k8s we need to load module br_netfilter (bridge switch) , overlay (file format)

  
  modprobe br_netfilter
  
  modprobe overlay
  
   
  lsmod | grep  br_netfilter
  
  lsmod | grep overlay
  

#### kernel parameters:


configs of kernel module is  parameters. for ex.: swappiness=80x parameter in one module --> when ram usage reach to 80% then swith module to swap mem.

to check kernel parameters use:

sysctl  --> to manage kernel parameters. its config store in the /etc/sysctl.conf to persist them. 

systemctl ---> to manage daemons


K8s need to add below parameter. then we uncommnet it in that file:

net.ipv4.ip_forward=1

sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

sysctl --system    - to reload sysctl and apply new config without reboot. 

sysctl -a | grep net.ipv4.ip_forward

to change paramater from command:

sysctl -w net.ipv4.ip_forward=1    - this temporary becaouse when system reboot os read file /etc/sysctl.conf



now install below pakage:

apt update; apt install apt-transport-https ca-certificates curl conntrack -y

conntrack is virtual switch and ip forward . 

now add google repo and sign it:


curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt update

apt install kubelet kubeadm kubectl -y

sudo apt-mark hold kubelet kubeadm kubectl

to see other release version of a app run:

apt-cache policy kubeadm    - see all version of kubeadm 

apt install kubeadm=1.27.4-00 


apt-mark hold  - when we hold this its not upgrade

apt-mark unhold  -when we unhold this its upgrade automatically

k8s upgrade is very heavy works and nead much downtime in datacenters. then we need to hold it for specific time as you need.

apt-mark hold kubelet kubeadm kubectl


systemctl status kubelet

kubectl version

kubeadm version


kubelet --version





 

hint: 
sysctl -a | grep swap

vm.swappiness = 60   - linux swappiness is 60 but we increase it to 80 or 90 every where if we have not k8s there. then when ram goes 90 it swith to swap and add it to file to persist it


sysctl -w vm.swappiness=90

# k8s initialization


kubeadm init --help


advertise ip that all node see and ping each other on that ip  - ip a

pod net work cidr - k8s gives pods ip and port and ns ,..  . we should specify rang ip /16 for k8s. ex. pattern:

10.244.1.1   - worker1

   10.244.1.2   - pod2

   10.244.1.3   - pod3

   10.244.1.4   - pod4

   .
  

10.244.2.1   - worker2

     10.244.2.2   - pod2

     10.244.2.3   - pod3

     10.244.2.4   - pod4

     .

.

.

.


k8s make vswitch to handle connection between nodes , pods ,... that called pod network addon. 

#### pod network flannel

networks on k8s is yaml file that runs as pods. to run it apply it. its iclude 5-6 resource object writen in yml that merge together. 
note that we can merge multiple yml fiel in one yml file with --- (3dash role) to specify seperation of them. frist section in this yaml file is in kind of namespace then have not spec section.


wget https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml


   ---
kind: Namespace
apiVersion: v1
metadata:
  name: kube-flannel
  labels:
    k8s-app: flannel
    pod-security.kubernetes.io/enforce: privileged
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  labels:
    k8s-app: flannel
  name: flannel
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - nodes/status
  verbs:
  - patch
- apiGroups:
  - networking.k8s.io
  resources:
  - clustercidrs
  verbs:
  - list
  - watch
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  labels:
    k8s-app: flannel
  name: flannel
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: flannel
subjects:
- kind: ServiceAccount
  name: flannel
  namespace: kube-flannel
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: flannel
  name: flannel
  namespace: kube-flannel
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: kube-flannel-cfg
  namespace: kube-flannel
  labels:
    tier: node
    k8s-app: flannel
    app: flannel
data:
  cni-conf.json: |
    {
      "name": "cbr0",
      "cniVersion": "0.3.1",
      "plugins": [
        {
          "type": "flannel",
          "delegate": {
            "hairpinMode": true,
            "isDefaultGateway": true
          }
        },
        {
          "type": "portmap",
          "capabilities": {
            "portMappings": true
          }
        }
      ]
    }
  net-conf.json: |
    {
      "Network": "10.244.0.0/16",
      "Backend": {
        "Type": "vxlan"
      }
    }
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: kube-flannel-ds
  namespace: kube-flannel
  labels:
    tier: node
    app: flannel
    k8s-app: flannel
spec:
  selector:
    matchLabels:
      app: flannel
  template:
    metadata:
      labels:
        tier: node
        app: flannel
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/os
                operator: In
                values:
                - linux
      hostNetwork: true
      priorityClassName: system-node-critical
      tolerations:
      - operator: Exists
        effect: NoSchedule
      serviceAccountName: flannel
      initContainers:
      - name: install-cni-plugin
        image: docker.io/flannel/flannel-cni-plugin:v1.2.0
        command:
        - cp
        args:
        - -f
        - /flannel
        - /opt/cni/bin/flannel
        volumeMounts:
        - name: cni-plugin
          mountPath: /opt/cni/bin
      - name: install-cni
        image: docker.io/flannel/flannel:v0.22.1
        command:
        - cp
        args:
        - -f
        - /etc/kube-flannel/cni-conf.json
        - /etc/cni/net.d/10-flannel.conflist
        volumeMounts:
        - name: cni
          mountPath: /etc/cni/net.d
        - name: flannel-cfg
          mountPath: /etc/kube-flannel/
      containers:
      - name: kube-flannel
        image: docker.io/flannel/flannel:v0.22.1
        command:
        - /opt/bin/flanneld
        args:
        - --ip-masq
        - --kube-subnet-mgr
        resources:
          requests:
            cpu: "100m"
            memory: "50Mi"
        securityContext:
          privileged: false
          capabilities:
            add: ["NET_ADMIN", "NET_RAW"]
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: EVENT_QUEUE_DEPTH
          value: "5000"
        volumeMounts:
        - name: run
          mountPath: /run/flannel
        - name: flannel-cfg
          mountPath: /etc/kube-flannel/
        - name: xtables-lock
          mountPath: /run/xtables.lock
      volumes:
      - name: run
        hostPath:
          path: /run/flannel
      - name: cni-plugin
        hostPath:
          path: /opt/cni/bin
      - name: cni
        hostPath:
          path: /etc/cni/net.d
      - name: flannel-cfg
        configMap:
          name: kube-flannel-cfg
      - name: xtables-lock
        hostPath:
          path: /run/xtables.lock
          type: FileOrCreate
   

kubectl apply -f 

or write:

kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml


it downloads flannel.

kubectl get pods -A -o wide


then we see flannel is a pod that include 2 containers. 

use watch to see and follow result :


 watch kubectl get pods -A


 after running flannel --> core dns is ruuning ---> after core dns running ---> our pods status change to ready.


 kubectl get pods -A 

 kubectl describe pods podname1 -n namesspaceofpods


 hint:

 to relate master and worker turn off vpns cause it make vrtual network on them. 1core 1gig freet ier aws is good for vpn. for 1 years.100 gig teraffic is free and limit it. then you should config limit badget managment to 1 $ . then ssuttle to it. 


 when all done and all nodes get ready then reboot your all servers. 


 to drop a node from cluster :

 kubeadm reset   - delet every configuration and left cluster. that on master get all cluster down.

 when a coomadn didnot work that write completion for it.


 kubeadm completion --help


 kubeadm completion bash > /etc/bash_completion.d/kubeadm

/etc/bash_completion    ----> is a file for bash completion (tab)

for third parthy bash completion we have directory (/etc/bash_completion.d) then add third party file to this directory. with above command. becareful about .d/  -  then make file with that thirdparty name and out put completion output to it. then logout and login again or press:

bash -l   - reload bash again

or

exit



do above stage again for kubectl

 kubectl completion bash > /etc/bash_completion.d/kubectl

 bash -l




upgrade is used for major version 1.27 ---> 1.28




kubeadm token list   - show topken list

kubeadm token delete   - delete token


kubectl delete nodes nodename1   - delet that node 


kubeadm token create --print-join-command   - it makes token and give you join command


when we add nodes its bestpractice to keep security delete tokens.


k8s role for nodes (worker) is none we can put it names (worker) with :  

kubectl label node nodenamezizi node-role.kubernetes.io/worker=worker


kubectl get namespaces

kubectl get ns


kubectl create namespace monitoring

kubectl get ns


vim pod2.yml

apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  namespaces: monitoring
spec:
  containers:
  - name: nginx-ctr
    image: nginx:latest
    ports:
    - containerPort: 80 




kubectl apply -f pod2.yml

kubectl get pods -n monitoring

kubectl get pods -n monitoring -o wide


kubectl delete pods nginx -n monitoring   - delete it



kubectl apply -f pod2.yml  --v=2   -verbose to debag message when apply what happens. its recommanded. *******  

slide76









 



 


 


 



























kubeadm init --apiserver-advertise-address 192.168.44.136 --pod-network-cidr 10.244.0.0/16


kubeadm config images pull


if we encounterd an error we should 

kubeadm reset  - clear cluster (opsitte of kubeadm init)


rm -rf $HOME/.kube/config 


then run 

kubeadm init --apiserver-advertise-address 192.168.44.136 --pod-network-cidr 10.244.0.0/16


again. when you get succefully initialize message! 3 parameters should be set:


Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf



kubeadm join 192.168.44.136:6443 --token sayq8e.845wmtdxxkdycndy \
        --discovery-token-ca-cert-hash sha256:e680b25aa2debb1c6100e2677ba012b90e23db14a2f7814beac84348415a7472


kubectl get nodes


when pod network installed then node status change from not ready to ready.

kubectl get pods -A


coredns also depends on pod network. if it up it change from pending to running

 kubectl get pods -o wide -A


 kubeadm --help

### kubespray

a opensource tools in github repo to easy installing k8s. Kubespray is a composition of Ansible playbooks, inventory, provisioning tools, and domain knowledge for generic OS/Kubernetes clusters configuration management tasks.


*****best practice*****
you can write yous kubespray and put it on github. write a playbook and bashscript for install and initial k8s and push it on github. (500-600 line)







 

