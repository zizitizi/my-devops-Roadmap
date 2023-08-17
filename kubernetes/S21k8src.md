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



# # replication controller (rc)







