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







# # replication controller (rc)










