


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






