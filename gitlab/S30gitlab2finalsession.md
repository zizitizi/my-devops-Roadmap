


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



we can define test or production or develop environment in gitlab menu> operate >environemt


when we define environmet  in .gitlab-ci.yml use stage environmet and set manual in pipeline env sections.


in setting menu use to integration and runners ,..


integration: use this and webhook to integrate


in access token to access without pssword.


in ci/cd section we do more:

public pipeline or not. git strategy : git clone is more better that git fetch(just loqs and incremental).

in runner section :  Project runners in left is internal ruuner for our project. in right or  Shared runners  is wordwide runners.


shared runner we add it we its tag to use as our server then our pipeline run there and then finished and exit and clean. 

we use gitlab onpromise and its agent.



puse act as cordon in pods. 

set new runner and set tag and type of runner then create runner . in next page use commands.


to install runner click on  How do I install GitLab Runner?   and follow the instruction.


after installation copy token command and run on that server:

gitlab-runner register  --url https://gitlab.com  --token glrt-Who2625aD6LHb5V-1yje



clone project in working directory


than start project: gitlab-runner run

systemctl gitlab-runner start


then register it to that site or host address:


gitlab-runner register


then follow instruction. give gitlab.com to url if you host give it name\

after com[letion verify it:

gitlab-runner verify


we protect branch from merge , push ,..for ex: production



real senario: 4 server - gitlab- monitoring - production- development - test - ha - backup -7 website - 1 ip public- 7 domain name:

to solve if we use k8s its low performance- then we choose docker swarm - 

let 3 node be cluster node . 

other one is to be as server for : gitab-grafana-prom - bookstack - backup takes here and send to cluster master nfs server with most biggest storage to save them 3 tb and docker hub integration and build image there and deploy for staging with labaling stg.

2 other cluster node is for build and push to hub. deploy for production with labaling stg. and this 2 servers have load balancing with nginx. pull from hub and are nfs client. 

in ci/cd we have 2 docker compose file : dockercompose-stg.yml  - dockercompose-prod.yml

then in gitlan make 2 env with 2 butoon : stg - prod. when developers hit the stg button pipeline related to it with dockercompose-stg.yml runs. when developers hit the prod button  pipeline related to it with dockercompose-prod.yml runs.

data is persisted there. data have 2 copy one is in self server other is in nfs server.

we have 7 site .all html web site run with nginx and nodejs app run with nodejs pm2. one extra nginx for reverse proxy . just pubishe 80:80 reverse proxy to public its safe. it forward request of web sites to specific container. all 7 is one ip set dns domain. we map one ip public. reverse proxy looks at header http request that with domain then forward for ex.: web1.com to specific internal ip 

in reverse proxy we use docker compose for it map conf folder and log folder 

./conf:/etc/nginx/conf.d

./log:/var/log/nginx

in conf folder we have one file for each site (domain name) - but its recommand not to delete default.conf file ( to handle errors)

server name is domain name that we buy. 

proxy_pass tell where go the client requests. if we add reverse proxy and web1 container in same network then call it with it name and port. for ex.: http://kpi-dashboard:80/; 







bookstack and conflouence is documentation software. bookstack is open source an d self hosted. and integration with diagram.net . 



in dns server we have to just 2 port: 80 or 443 . to use other port one solutin is ingress. other solution is nginx as reverse proxy.


ingress is mre lb. cillium -treafic metal, nginx can use as ingress. nginx is distr. with nginx and k8s company but which is developed by k8s  is more efficient.


in k8s cluster one is master who have nginx with reverse proxy and clusterip with pods ip and ports. svc that point to specific pods.






