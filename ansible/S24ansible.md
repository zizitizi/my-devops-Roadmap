


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

ansible: ssh based. os sould be installed and run and ssh is installed too. its daemon less or service less. agent less its run when we need it call it for run. then its light weight app. just need to install ansible in controller . and pythin in remote machines for extra feature,( linux has pythin in default on itself. cisco has too) if not ansible use it self python module too for base feature.

puppet: ssl based. os sould be installed and run and ssl is installed too. its agent base to check config in some minute. then its heavy agent app.
 can freeze config - then changing puppet made config. generate a log and reset new config after for ex.: 1 hour to puppet config in that device. 

teraform: its Iac and infrastucutre provisioners too. can use ssh. it can use for low level provision in ilo levet and in adition of use port ssh it can use IPMI port to install os on bare metal server . in cloud environment for ex.: in private cloud like openstack we can use teraform to install many os . in aws we can use teraform to create many vm with specified config and os. its heavy agent app.

- other chef ,... 3 above is very famous. 



in Iac need a controller ( in our laptop - our in controller server in datacenters) and remote machines (server- switches - routers ,...) . 

devops: automation for servers

devnet: automation for switches and routers- ansible - linux- network - ccna , ...






