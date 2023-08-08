
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














