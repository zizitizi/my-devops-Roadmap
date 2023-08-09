
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

apt update; apt install kubelet kubeadm kubectl –y

sudo apt-mark hold kubelet kubeadm kubectl
































