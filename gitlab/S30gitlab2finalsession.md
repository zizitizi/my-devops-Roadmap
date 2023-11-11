


# gitlab



in gitlab we have git repo and ci/cd . then clone it and build image and push it to repo (for ex: dockerhub). then deploy it (for ex: k8s or compose).



in all pipeline we have 2 mandatory stage: build (ci) and deploy (cd) .


devops: is ci process in actual. when we publish ci from gitlab to deploy it called push based. when we publish cd process from deploy to gitlab it called pull based. 

in devops automation tools is placed in gitlab and push to deploy.

in gitops automation tools is placed in gitlab and pull from deploy.

gitops tool: argo that is k8s based and install on it. give it git repo addres then it pulls projects. flux is too. learn it too.



in real world commonly we have : a repo. 1 build server (compile -build tag push) with good config then keep file to hub or or a nexus. deploy server for deploy.

each server that work with gitlab should install gitlab runner.

for each project or repo add a runner . couse each project may have multiple task that each task need a executor if not the queue made. we prevent to make queue.

so we register runners in servers. register runner in  git repo with ssl and token.


best pracice is one runner for each project and repo with one executer if repo need it increase executer fot that repo. 

we have runner type: shell-docker-k8s-virtualbox,...


shell runner run cmmand in linux shell type. in .gitlan-ci.yml

docker runner excute command in a container like a nginx we should define wich docker image is. push run and delete container.

k8s runner excute command in a pod. it make pods run commands and exit pods.

vbox runner make ova or ovh run coomand and exit. it used rarely.


script in pipeline is mandatory

when : manual - when we manually start pipeline it run.

only: - develop    - pipeline only on develope branch lunch

tags:   registerd runner label























