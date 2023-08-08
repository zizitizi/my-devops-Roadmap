
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




sudo sed -i '/swap/s/^\//\#\//g' /etc/fstab















