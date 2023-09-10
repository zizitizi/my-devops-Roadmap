


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





Jump-start your automation project with great content from the Ansible community. Galaxy provides pre-packaged units of work known to Ansible as roles and collections.

Content from roles and collections can be referenced in Ansible PlayBooks and immediately put to work. You'll find content for provisioning infrastructure, deploying applications, and all of the tasks you do everyday.

Use the Search page to find content for your project, then download them onto your Ansible host using ansible-galaxy, the command line tool that comes bundled with Ansible.

https://galaxy.ansible.com/



## ssh connection authentication

we can use password phrase but it nit recommand save it on laptop it may be leak.

its recommand to use public and private key .



#### solving partition resize

https://packetpushers.net/ubuntu-extend-your-default-lvm-space/








