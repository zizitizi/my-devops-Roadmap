


## some hints in k8s


in multi master senario we have 2 otions:

1- change one node role to master then it will be just master and did not sync with master leader couse has not ca cert server . for sync you should upload cert from leader to it . you can add node from just leader.


2- from initial cluster from begin use cert control plane and cert option to upload cert to any master . but we should have one leader in every multi master cluster that we specify it with control plane end point. after it we can add any master that we desired:


 kubeadm init --control-plane-endpoint "192.168.44.136:6443" --upload-certs --pod-network-cidr=10.244.0.0/16


 it give you token for worker and masters.

 for master token its valid for 2 hour and to give it again you can use:

 kubeadm init phase upload-certs --upload-certs


 


to see logs in k8s :

kubectl describe pods ----

kubectl logs pods ----




in some ttshoot becarefil to node affinity and configmap ,... nginx write mysql then nedd node affinity. redis write in ram that other node not have permission to see it.





# ansible

one of IAC - infra as code - tools. it prevent man made mistake, reduce speed , maintain os config,... . Rolling out new configs to all applicable servers.
Centralizing modify all server configurations.
Manage servers easier in different groups & subgroups.
Define automate configurations like patches & updates.
Identify outdated & old configs & define to update them.
Setups are free of human-mistake errors.
Makes infrastructure more flexible and ready to use.


main 3 iac tools that use in all interview is: 

- ansible: ssh based. os sould be installed and run and ssh is installed too. its daemon less or service less. agent less its run when we need it call it for run. then its light weight app. just need to install ansible in controller . and pythin in remote machines for extra feature,( linux has pythin in default on itself. cisco has too) if not ansible use it self python module too for base feature.

- puppet: ssl based. os sould be installed and run and ssl is installed too. its agent base to check config in some minute. then its heavy agent app.
 can freeze config - then changing puppet made config. generate a log and reset new config after for ex.: 1 hour to puppet config in that device. 

- teraform: its Iac and infrastucutre provisioners too. can use ssh. it can use for low level provision in ilo levet and in adition of use port ssh it can use IPMI port to install os on bare metal server . in cloud environment for ex.: in private cloud like openstack we can use teraform to install many os . in aws we can use teraform to create many vm with specified config and os. its heavy agent app.

- other chef ,... 3 above is very famous. 



in Iac need a controller ( in our laptop - our in controller server in datacenters) and remote machines (server- switches - routers ,...) . 

devops: automation for servers

devnet: automation for switches and routers- ansible - linux- network - ccna , ...



in practical we use hybrid senario . use ansible to install puppet agent on all machine. use terafform to instal os and ..... use ansible to install salt and teraform on servers. 

example:

in cloud openstack senario we have all 3 below to use as:

ansible: for regular config that we have thier playbook before. its use to config managments. we have its config yml before and use them many times.

puppet: its use to freeze our config in servers. 

saltstack: we us its cli to get status of serves. its cli tools is very good. 


ssh coneection is low speed connections. ansible is good to 100 server for 1000 server puppet is good and good performance then ansible. 


ansible has 2 type of file:

- playbook: yaml file to keep config of server. ansible and teraform use yaml language but other use different.

- host inventory: config file of server info's. include: ip - user -pass- protocol - port. for every company we have one of it. in ssl based we have not this file.



	Ansible Control Machine Requirements:
I.	Install Python 2 (2.6 or 2.7) or Python 3 (3.5 or Higher).(mandatory)
II.	Install Python 2 or 3 on Remote Machines. (optional)
III.	Windows does not support as a Control Machine (Just by WSL).



with raw module in ansible we can run ansible playbook in remote machines without python but just run that commands and then we can not use extra feature (module ) of ansible in that machines.



## install ansible:


sudo -i

apt update; apt install ansible -y   - in controller machines. 

 ansible --version



Jump-start your automation project with great content from the Ansible community. Galaxy provides pre-packaged units of work known to Ansible as roles and collections.

Content from roles and collections can be referenced in Ansible PlayBooks and immediately put to work. You'll find content for provisioning infrastructure, deploying applications, and all of the tasks you do everyday.

Use the Search page to find content for your project, then download them onto your Ansible host using ansible-galaxy, the command line tool that comes bundled with Ansible.

https://galaxy.ansible.com/



## ssh connection authentication

we can use password phrase (in inventory file or..) but it not recommand save it on laptop it may be leak.

its recommand to use public and private key for ansible user. and disable password authentication in sshd-config file.


best practice is use user ansible to ssh from controller to remote machines. to see log in syslog if config change with it or other user. 

ansible user should be sudoer with no pass to change config . keep in mind not to use root to keep security .


make ansible user in all machines locally or by activedirectory or using ldap. 

#### solving partition resize

https://packetpushers.net/ubuntu-extend-your-default-lvm-space/


## axample: use 3 server. one in controller and remote machine. 2 is just remote machine.


add user ansible to all 3 machines: in debian use -D.

useradd -m -s /bin/bash -c “Ansible User” ansible

add user to sudo group:

usermod -aG sudo ansible

passwd ansible


we use pub key method in controller and one of remote machine and third serve base on password.

in controller:

ssh-keygen

su - ansible

in all machines do:


visudo  or vi /etc/sudoer 

% means group - 

in below of lines:
#Allow members of group sudo to execute any command  
add following line:

ansible ALL=(ALL:ALL) NOPASSWD: ALL

SAVE AND EXIT FILE. this change make prevent from asking sudo password of ansible user.

ssh-keygen

ssh-copy-id ansible@192.168.44.151  - in all machines - it means rsa-key.pub copy to in authorize-key. 

best practice to go to sshd-config controller server:

 vi /etc/ssh/sshd_config


 
change port:

Port 2022

PubkeyAuthentication yes

PasswordAuthentication no
PermitEmptyPasswords no

save and exit

systemctl restart sshd




hint: platform engineering is : devops(docker-yaml) + SRE(monitoring-ansible) + cloud partitioner (aws- vm- service-ceph-openstack)



note: add ansible user pub key that you trust him or her.


## ansible inventory

we make default directory for ansible and place inventory file for our projects or related inventory file there. and use an inventory file with -i .

 mkdir /etc/ansible/

 vi /etc/ansible/hosts



 we can write domain name and ip or range of ip . or range:

 server[001:015].sematech.com

 192.168.44.[110:130]

 #is commenting

 #Ex 1: Ungrouped hosts, specify before any group headers.
blue.example.com
192.168.100.10

 grouping:

 #Ex 2: A collection of hosts belonging to the 'webservers' group
[webservers]
www[001:006].example.com
192.168.1.110

[db-servers]
db01.intranet.mydomain.net
10.25.1.56

[all_servers]
webservers
db-servers


an ip may be member in many groups. 


Parameters	Description:


ansible_host=192.168.1.10   -	IP or DNS Name of the Host.


ansible_port=2022	 -  SSH Default port for connecting to.


ansible_connection=ssh	  -  Ansible Connection Type [ssh/winrm/localhost]. winrm is windows remote desktop.


ansible_user=ansible   - 	SSH User, if no user specified current user will used.


ansible_ssh_pass=Aa@123	  -  SSH Password. sshpass -p test123 scp user@ip ....



zizi51 ansible_host=192.168.44.151 ansible_connection=ssh ansible1_user=ansible ansible1_port=22   - you can ignore default parameter like below
zizi ansible_host=192.168.44.136 ansible_user=ansible
zizi50 ansible_host=192.168.44.150 ansible_ssh_pass=123

#Sample Inventory parameters
web1 ansible_host=web1.example.com ansible_connection=ssh ansible_user=root
db01 ansible_host=db01.example.com ansible_connection=winrm ansible_user=admin
mail1 ansible_host=192.168.10.3 ansible_connection=ssh ansible_ssh_pass=Aa@123

ubuntu1 ansible_host=localhost ansible_connection=localhost




if user not specified above in inventory file then ansible consider user that run commmand ansible_playbook. 


yaml file in k8s --> manifest

yaml file in ansible --> playbook

send config in ansible in 2 way:

1- ad-hoc command : ansible

2- playbook yaml file : ansible-playbook 



 ansible --list-hosts all   - list all hosts


 ansible --list-hosts all -i inventory.txt
 
 
 ansible ubuntu1 -m ping -i inventory.txt
 
 

 ansible all -m ping -i /etc/ansible/hosts  - when use default inventory no need -i like below:

 ansible all -m ping 

you should install sshpass on controller and login with ansible user.

sudo apt install sshpass -y

for using sshpass to send -y to hosts you should change below config in /etc/ssh/sshd_config file host key cheking to no and uncomment it. or just for one time ssh to that host to transfer fingerprint then use sshpass.

sudo vi /etc/ssh/sshd_config

#IgnoreUserKnownHosts no  ---> IgnoreUserKnownHosts yes

or ssh to that host one time:

 ssh ansible@192.168.44.150   - add fingerprint



 ## list of built-in ansible module that we learn in this section:

 1- ping
 2- command
 3- raw
 4- shell
 5- apt
 6- service
 7- copy
 8- file
 9- setup










#### 1- ping 

  ansible all -m ping   -- no need extra arg


#### 2- command

this is default command for -m in ansible and we can ignore it 

like:

ansible all -a "cat /etc/hostname"


command module needs an arguments:

ansible all -m command -a "cat /etc/hostname"

ansible all -m command -a "uptime"

ansible all -m command -a "date"  - you can see ansible send command In parallel

ansible all -m command -a "timedatectl"

ansible all -a "whoami"   - return ansible user but:


ansible all -a "sudo whoami"  - return root user for ssh with pub key connection but error for sshpass connection that need sudo password to pass. send ctlr+c to break. we can solve this error in 2 way:

this not recommanded:


 sudo vi /etc/ansible/hosts

 zizi50 ansible_host=192.168.44.150 ansible_ssh_pass=123 ansible_sudo_pass=123

or:

ansible all -b -a "whoami"   - -b or --become  - change user to root


ansible all -bK -a "whoami"   - K --ask-become-pass ask for sudo pass to become - its recommanded- becarefull all sudo pass for ansible user should be the same on all hosts.

ansible all --become-user zizi -K -a "whoami"   - run as zizi and ask pass zizi on all hosts.

3 color in output of ansible command means:

1- green : unchanged but successful command

2- yellow: change in result

3- red : failed


#### 3- raw

This module, unlike all others, doesn’t use python on the remote system.
This means it could be used on devices like IoT kit or networking devices that don’t have any other supported methods.



if we have not python on a server we have just a option using raw module other feature and module not work.

ansible all -b -m raw -a "apt install apache2 -y"







#### 4- shell 


If the command you want to execute should use local environment variables or you want to pipe the output to a file or grep (“<", ">“, “|”, “;”, “&”), then this is the droid you are looking for.



ansible all -b -m shell -a "apt install apache2 -y"






###### note:

difference  between raw shell and command is :

command execute and compile and build in python .

shell is open shell in destination commonly bash and execute in it .

raw just run a coomand in destination no matter python is exist or not. 

performance: 1- command 2- shell 3- raw

for example:

 ansible all -m command -a "echo "hello" > ~/outputtest.txt"  - did not work and correctly and not create output


  ansible all -m shell -a "echo "hello" > ~/outputtest.txt"  - make output correctly

  ansible all -m raw -a "echo "hello" > ~/outputtest.txt"  - make output correctly

in linux server we run shell . raw is for unix or other type of server.

command is python based and have not option for piping or environment or redirection out put ,... (echo $USER) not run in command.


#### 5- apt


this command is for install , uninstall , update package. that have 2 arguments. name and state=(present for install,latest for update,absent for uninstall) package

ansible all -m apt -a "name=figlet state=present"   - can not work becaouse user become root to install then run below command instead:

ansible all -bK -m apt -a "name=figlet state=present"


***important note:*** 
when you got this error :

zizi51 | FAILED | rc=-1 >>
Timeout (12s) waiting for privilege escalation prompt:

one of reasons may be in network layer. check (cat /etc/hosts ) that host name be correct


  

ansible is service less and cache less every time it runs first collect facts and then change or unchanged.


to remove docker repo with ansuble from all servers:

 ansible all -bK -a "rm -rf /etc/apt/source.list.d/docker.list"



DO ALL BELOW IN VISUDO TO PREVENT ASK PASS WORD EVERYTIME.

 ansible ALL=(ALL:ALL) NOPASSWD: ALL

THEN WE CAN IGNORE -K:

ansible all -b -m apt -a "name=figlet state=present"


OR WE CAN USE SUDO IN COMMMAND INSTEAD -b:

 ansible all  -a "sudo rm -rf /etc/apt/source.list.d/docker.list"



ansible-doc apt


ansible web-srv -b -m apt -a “name=apache2 state=latest only_upgrade=yes”    - only if apache2 existed update it to latest. use yes or on.

 ansible all -b -m apt -a "name=apache2 state=latest only_upgrade=yes"


 ansible all -b -m apt -a "name=apache2 state=absent purge=yes"  - when remove it purge its configuration.


to run apt update befor apt install set update_cache=yes. we can write this option any where of our arguments.cause it compile with python.

 
 ansible all -b -m apt -a "name=apache2 state=latest update_cache=yes"  - first run apt update then install or update to latest apache2


to force verbose or create debug log set -v increasinly to more log: -v or -vv or -vvv or -vvvv  --> its common to use -v or -vv.


ansible all -m command -a "figlet $USER"


figlet print banner.

figlet banner


#### 6- service


this module is same as systemctl. it has 2 main arguments: name - state : Reloaded , Restarted,  Running, Started or Stopped. enabled=yes


ansible-doc service


ansible all -b -m service -a "name=apache2 state=started enabeled=yes"




#### 7- copy

copy a file from controller to servers

src on controller and dest on remote machines.


ansible all -m copy -a “src=/etc/passwd dest=/tmp”

when we use backup option time stamp is same with that file. but for copy time is copy time

content to create content in place . we can use content or src.

directory_mode=yes copy the directory not that file and create dir.

force=yes copy the file newly even if exist replaced.

group=root make group owner change to root .need sudo or  -b and that may be it make copy in root home

mode=640 change the permisions to 640  .need sudo or  -b and that may be it make copy in root home


owner=root  change the owner of that file to root

remote_src  copy from remote machin to remote machines ip/target.

date is not update when file replaced.


#### 8- file

we can create file or directory and delete it . also emty file can created with. many similarity to copy.

its state may be soft link or hrad link or toouch. we dont have src here. main option is dest and state.

ansible all -m file -a “dest=/tmp/new mode=777 owner=ansible group=ansible state=directory”

ansible all -m file -a “dest=/tmp/new state=absent”


also it used for change persmision in a file on servers.




#### 9- setup


is just gathering facts on a server.
This module is automatically called by playbooks to gather useful variables about remote hosts. It can also be executed directly to check what variables are available to a host. ip - ipv6 - hardware resource - informations - kernel -time -....... every thing uoy need. in puppet we have factor like setup to gathering fact.


ansible all -m setup




ansible zizi -m setup



## ansible playbook














